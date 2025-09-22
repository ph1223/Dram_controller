#include <cstddef>
#include <vector>

#include "base/base.h"
#include "dram_controller/controller.h"
#include "dram_controller/refresh.h"
#include <fstream>

namespace Ramulator {

class AllBankRefresh : public IRefreshManager, public Implementation {
  RAMULATOR_REGISTER_IMPLEMENTATION(IRefreshManager, AllBankRefresh, "AllBank", "All-Bank Refresh scheme.")
  private:
    Clk_t m_clk = 0;
    IDRAM* m_dram;
    IDRAMController* m_ctrl;

    int m_dram_org_levels = -1;
    int m_num_ranks = -1;

    int m_nrefi = -1;
    int m_ref_req_id = -1;
    Clk_t m_next_refresh_cycle = -1;

    int m_num_refresh_blocks = -1;

    std::ofstream refresh_log_file;

  public:
    void init() override {
      m_ctrl = cast_parent<IDRAMController>();
    };

    void setup(IFrontEnd* frontend, IMemorySystem* memory_system) override {



      m_num_refresh_blocks = param<int>("num_refresh_blocks").default_val(4); // Number of refresh blocks

      m_dram = m_ctrl->m_dram;

      m_dram_org_levels = m_dram->m_levels.size();
      m_num_ranks = m_dram->get_level_size("rank");

      m_nrefi = m_dram->m_timing_vals("nREFI"); //Gets the Refresh interval from dram device
      m_ref_req_id = m_dram->m_requests("all-bank-refresh"); // Gets the request id for all bank refresh

      m_next_refresh_cycle = m_nrefi; // Use the refresh interval as next refresh cycle

      refresh_log_file.open("refresh_log.txt");
    };
    void tick(ReqBuffer::iterator& req_it){};

    void tick() {
      m_clk++;

      if (m_clk == m_next_refresh_cycle) {
        m_next_refresh_cycle += m_nrefi;
        for (int r = 0; r < m_num_ranks; r++) {
          std::vector<int> addr_vec(m_dram_org_levels, -1);
          addr_vec[0] = m_ctrl->m_channel_id;
          addr_vec[1] = r;
          Request req(addr_vec, m_ref_req_id);

          bool is_success = m_ctrl->priority_send(req);
          if (!is_success) {
            throw std::runtime_error("Failed to send refresh!");
          }
        }
      }
    };

};

class WriteUpdateRefresh : public IRefreshManager, public Implementation {
  RAMULATOR_REGISTER_IMPLEMENTATION(IRefreshManager, WriteUpdateRefresh, "PartialRefresh", "Write Update Refresh scheme.")
  private:
    Clk_t m_clk = 0;
    IDRAM* m_dram;
    IDRAMController* m_ctrl;

    int m_dram_org_levels = -1;
    int m_dram_row_level = -1;
    int m_num_ranks = -1;
    int m_num_bankgroups = -1;
    int m_num_banks = -1;
    int m_num_rows = -1;

    int refresh_counter;

    int m_nrefi = -1;
    int m_ref_req_id = -1;
    Clk_t m_next_refresh_cycle = -1;
    bool m_is_debug = false;

    int initial_row_tracker_value = param<int>("initial_row_tracker_value").default_val(0);
    int m_num_refresh_blocks = param<int>("num_refresh_blocks").default_val(4);
    Clk_t refresh_counter_sample_interval = param<Clk_t>("refresh_counter_sample_interval").default_val(3000); // Sample interval for refresh counter
    std::string m_refresh_log_file_path = param<std::string>("refresh_log_file_path").default_val("refresh_log.txt");
    int m_num_refresh_rows = -1;
    // Number of refresh rows per bank group
    int* partial_refresh_pointers = new int[m_num_refresh_blocks]();
    // For initializing the partial refresh pointers to a set value for further analysis and testing
    int sp0 = param<int>("sp0").default_val(0);
    int sp1 = param<int>("sp1").default_val(0);
    int sp2 = param<int>("sp2").default_val(0);
    int sp3 = param<int>("sp3").default_val(0);

    size_t s_wupr_num_of_compare = -1;
    float  m_compare_energy_cost = 0;
    float  s_total_energy_cost = 0;
    float s_segment_ptr_energy_cost = 0 ; // Energy cost for storing the segment pointers

    std::ofstream refresh_log_file;

  public:
    void init() override {
      m_ctrl = cast_parent<IDRAMController>();
    };

    void setup(IFrontEnd* frontend, IMemorySystem* memory_system) override {

      //m_num_refresh_blocks = param<int>("num_refresh_blocks").default_val(4); // Number of refresh blocks

      m_dram = m_ctrl->m_dram;
      refresh_counter = initial_row_tracker_value;

      m_dram_org_levels = m_dram->m_levels.size();
      m_dram_row_level = m_dram->m_levels("row");
      m_num_ranks = m_dram->get_level_size("rank");
      m_num_bankgroups = m_dram->get_level_size("bankgroup");
      m_num_banks = m_dram->get_level_size("bank");
      m_num_rows = m_dram->get_level_size("row");
      m_compare_energy_cost = 0; // 16nm comparator using nJ, also the energy for storing the segments information


      m_num_refresh_rows = m_num_rows / m_num_refresh_blocks; // Number of refresh rows per bank group
      if(m_num_refresh_rows == 0) {
        throw std::runtime_error("Number of refresh rows cannot be zero!");
      }


      partial_refresh_pointers = new int[m_num_refresh_blocks]();
      // note add an exception that setting of partial pointer is allowed only when num_refresh_blocks is 4
      // if(m_num_refresh_blocks != 4) {
      //   throw std::runtime_error("Number of refresh blocks must be 4!");
      // }
      // Initialize the partial refresh pointers to a set value for further analysis and testing
      for (int i = 0; i < m_num_refresh_blocks; i++) {
        if(i == 0) {
          partial_refresh_pointers[i] = sp0;
        } else if(i == 1) {
          partial_refresh_pointers[i] = sp1;
        } else if(i == 2) {
          partial_refresh_pointers[i] = sp2;
        } else if(i == 3) {
          partial_refresh_pointers[i] = sp3;
        }
        if(partial_refresh_pointers[i] >= m_num_refresh_rows) {
          throw std::runtime_error("Partial refresh pointer value cannot be greater than or equal to number of refresh rows!");
        }
      }

      m_nrefi = m_dram->m_timing_vals("nREFI"); //Gets the Refresh interval from dram device
      m_ref_req_id = m_dram->m_requests("all-bank-refresh"); // Gets the request id for all bank refresh

      m_next_refresh_cycle = m_nrefi; // Use the refresh interval as next refresh cycle
      register_stat(s_wupr_num_of_compare).name("write_update_refresh_num_of_compare: ");
      register_stat(s_total_energy_cost).name("write_update_refresh_total_energy_cost: ");
      // refresh log file
      // Create a return trace file
      refresh_log_file.open(m_refresh_log_file_path);
      if (!refresh_log_file.is_open()) {
        throw ConfigurationError("Refresh log file {} cannot be opened!", m_refresh_log_file_path);
      }
    };

    void tick(){
      m_clk++;

      if (m_clk == m_next_refresh_cycle) {
        m_next_refresh_cycle += m_nrefi;
        for (int r = 0; r < m_num_ranks; r++) {
          if((refresh_counter % m_num_refresh_rows) <= partial_refresh_pointers[refresh_counter/m_num_refresh_rows]) {
            std::vector<int> addr_vec(m_dram_org_levels, -1);
            addr_vec[0] = m_ctrl->m_channel_id;
            addr_vec[1] = r;
            Request req(addr_vec, m_ref_req_id);

            bool is_success = m_ctrl->priority_send(req);
            if (!is_success) {
              throw std::runtime_error("Failed to send refresh!");
            }
          }
        }

        refresh_counter++;
      }
      if(m_clk % refresh_counter_sample_interval == 0) {
          // Cycle , row tracker, SP0,SP1,SP2,SP3
          // output the refresh counter and the partial refresh pointers to a file
          refresh_log_file << " " << m_clk << " " << refresh_counter << " ";
          for(int i = 0; i < m_num_refresh_blocks; i++) {
            refresh_log_file << partial_refresh_pointers[i] << " ";
          }
          refresh_log_file << '\n';
        }

        if(refresh_counter == m_num_rows) {
          refresh_counter = 0;
      }
    };

    void tick(ReqBuffer::iterator& req_it) {


      if(((req_it->addr_vec[m_dram_row_level]) % m_num_refresh_rows) > partial_refresh_pointers[(req_it->addr_vec[m_dram_row_level])/m_num_refresh_rows]) {
        // check if req_it is a write request
        if(req_it->type_id == Request::Type::Write) {
          s_wupr_num_of_compare++;
          s_total_energy_cost += m_compare_energy_cost; // Update the total energy cost
        }
        partial_refresh_pointers[(req_it->addr_vec[m_dram_row_level])/m_num_refresh_rows] = req_it->addr_vec[m_dram_row_level] % m_num_refresh_rows;
          s_total_energy_cost += s_segment_ptr_energy_cost;
      }


    };

};

}       // namespace Ramulator
