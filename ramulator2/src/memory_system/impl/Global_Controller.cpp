#include "addr_mapper/addr_mapper.h"
#include "base/request.h"
#include "dram/dram.h"
#include "dram_controller/controller.h"
#include "memory_system/memory_system.h"
#include "translation/translation.h"
#include <deque>

namespace Ramulator {

class GlobalController final : public IMemorySystem, public Implementation {
  RAMULATOR_REGISTER_IMPLEMENTATION(IMemorySystem, GlobalController,
                                    "Global_Controller",
                                    "Global Controller for bank level DRAM system");
  // I suppose should reorder and ensure the data in-order property is
  // maintained We use callbank function to inform the frontend the request has
  // ended thus returning the control

protected:
  Clk_t m_clk = 0;
  IDRAM *m_dram;
  IAddrMapper *m_addr_mapper;
  std::vector<IDRAMController *> m_controllers;
  std::deque<Request> m_read_in_order_q;
  std::deque<Request> m_receive_merge_q;

public:
  int s_num_read_requests = 0;
  int s_num_write_requests = 0;
  int s_num_other_requests = 0;
  int    m_bandwidth_sample_time_interval = 500;
  int    m_read_datapath_width = 1024; // in bits
  int    m_received_request_in_interval = 0; // Count the number of requests received in the current interval
  float s_average_bandwidth = 0;
  float s_peak_bandwidth = 0;
  float s_worst_bandwidth = 0;
  float bandwidth_ultilization = 0.0f;

  int m_read_in_order_q_size = 0;
  bool m_is_debug = false;


public:
  void init() override {
    // Create device (a top-level node wrapping all channel nodes)
    m_dram = create_child_ifce<IDRAM>();
    m_addr_mapper = create_child_ifce<IAddrMapper>();

    int num_channels = m_dram->get_level_size("channel");

    // Create memory controllers
    for (int i = 0; i < num_channels; i++) {
      IDRAMController *controller = create_child_ifce<IDRAMController>();
      controller->m_impl->set_id(fmt::format("Channel {}", i));
      controller->m_channel_id = i;
      m_controllers.push_back(controller);
    }

    m_logger = Logging::create_logger("GenericDRAMSystemLog");

    m_clock_ratio = param<uint>("clock_ratio").required();

    m_read_in_order_q_size = param<int>("read_in_order_q_size").default_val(128);

    m_is_debug = param<bool>("debug").default_val(true);

    m_bandwidth_sample_time_interval = param<int>("bandwidth_sample_time_interval").default_val(2000);

    register_stat(m_clk).name("memory_system_cycles");
    register_stat(s_num_read_requests).name("total_num_read_requests");
    register_stat(s_num_write_requests).name("total_num_write_requests");
    register_stat(s_num_other_requests).name("total_num_other_requests");

    register_stat(s_average_bandwidth).name("average_bandwidth");
    register_stat(s_peak_bandwidth).name("peak_bandwidth");
    register_stat(s_worst_bandwidth).name("worst_bandwidth");
    register_stat(bandwidth_ultilization).name("bandwidth_utilization").desc("The bandwidth utilization in percentage");

  };

  void setup(IFrontEnd *frontend, IMemorySystem *memory_system) override {}

  bool send(Request req) override {
    m_addr_mapper->apply(req);
    int channel_id = req.addr_vec[0];

    // Is success only if the read_in_order_q have spaces, otherwise fail
    if (m_read_in_order_q.size() >= m_read_in_order_q_size) {
      return false;
    }

    bool is_success = m_controllers[channel_id]->send(req); // Sends the request to the controller

    if(m_is_debug){
        // clk cycles
        m_logger->debug("Send request to channel {} at Clk={}, Addr={}, Type={}", channel_id, m_clk, req.addr, req.type_id);
    }

    if (is_success) {
      switch (req.type_id) {
      case Request::Type::Read: {
        s_num_read_requests++;

        m_read_in_order_q.push_back(req);
        break;
      }
      case Request::Type::Write: {
        s_num_write_requests++;
        // m_logger->debug("Enqueueing write request at Clk={}, Addr={}, Type={}",
        //                 m_clk, req.addr, req.type_id);
        break;
      }
      default: {
        s_num_other_requests++;
        break;
      }
      }
    }

    return is_success;
  };

  bool ordered_receive(Request req) override {
    // Called by the DRAM Controller to issue the request to the frontend
    m_receive_merge_q.push_back(req);
    return false;
  }

  void tick() override {
    m_clk++;
    m_dram->tick();
    for (auto controller : m_controllers) {
      controller->tick(); // Tick the controller
    }
    bandwidth_calculation(); // Calculate the bandwidth
    in_order_callback();
  };

  float get_tCK() override { return m_dram->m_timing_vals("tCK_ps") / 1000.0f; }

  void issue() override{
    // This function is not used in the global controller, but it is here for
    // compatibility with the IMemorySystem interface
    //Throw Exception
    throw std::runtime_error("Issue function is not implemented in the Normal GlobalController");
  };

private:
  void bandwidth_calculation(){
    float bandwidth = 0.0f;
    // Bandwidth statistics
    if(m_clk % m_bandwidth_sample_time_interval == 0)
    {
      // Total Received data / Time = (Data bit width*Requests)/Time
      bandwidth = float((m_received_request_in_interval*(m_read_datapath_width/8)))/float(m_bandwidth_sample_time_interval); // in bytes
      // Exception, check if the bandwidth is greater than the read data path width
      if(bandwidth > m_read_datapath_width/8)
      {
        bandwidth = 0;
      }

      if(s_peak_bandwidth < bandwidth)
        s_peak_bandwidth = bandwidth;
      if(s_worst_bandwidth > bandwidth)
        s_worst_bandwidth = bandwidth;

      m_received_request_in_interval = 0;

      if(m_is_debug)
        std::cerr << "Bandwidth at " << m_clk << " clk cycle is " << bandwidth << " G_bytes" << std::endl;
    }
    bandwidth_ultilization = s_peak_bandwidth / float(float(m_read_datapath_width) / float(8)); // in percentage

  }

  void in_order_callback() {
    // First check if the receive merge queue is empty
    if (m_receive_merge_q.empty()) {
      return;
    }

    // reorder the merge queue with the arrival time
    std::sort(m_receive_merge_q.begin(), m_receive_merge_q.end(),
              [](const Request &a, const Request &b) {
                return a.arrive < b.arrive;
              });

    // Traverse the whole m_receive_merge_q
    for (auto it = m_receive_merge_q.begin(); it != m_receive_merge_q.end();) {
      // check if the request is the same as the first request in the in order
      // queue
      if (m_read_in_order_q.front().arrive == it->arrive) {
        // If the request is the same as the first request in the in order queue
        // then we can send the request to the frontend
        // m_logger->debug(
        //     "Sending request to frontend at Clk={}, Addr={}, Type={}", m_clk,
        //     it->addr, it->type_id);

        Request req_to_callback = m_read_in_order_q.front();

        it = m_receive_merge_q.erase(it);
        m_read_in_order_q.pop_front();

        // TO-DO Callback to the frontend if it has a callback to do
        if (req_to_callback.callback != nullptr) {
          req_to_callback.callback(req_to_callback);
          m_received_request_in_interval++;
        }
        break;
      } else {
        // If the request is not the same as the first request in the in order
        // queue then we can break the loop
        break;
      }
    }
  }
};

} // namespace Ramulator
