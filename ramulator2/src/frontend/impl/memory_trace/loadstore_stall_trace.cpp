#include <filesystem>
#include <fstream>
#include <functional>
#include <iostream>

#include "base/exception.h"
#include "base/request.h"
#include "frontend/frontend.h"

namespace Ramulator {

namespace fs = std::filesystem;

class LoadStoreStallTrace : public IFrontEnd, public Implementation {
  RAMULATOR_REGISTER_IMPLEMENTATION(
      IFrontEnd, LoadStoreStallTrace, "LoadStoreStallTrace",
      "Load/Store memory address trace with stall_cycles.")

private:
  struct Trace {
    bool is_write;
    Addr_t addr;
    int stall_cycles;
  };

  std::vector<Trace> m_trace;

  bool m_waiting_for_request = false;
  int  m_current_stall_cycles = 0;

  size_t m_trace_length = 0;
  size_t m_curr_trace_idx = 0;

  size_t m_trace_count = 0;

  Logger_t m_logger;

public:
  void init() override {
    std::string trace_path_str = param<std::string>("path")
                                     .desc("Path to the load store trace file.")
                                     .required();
    m_clock_ratio = param<uint>("clock_ratio").required();

    m_logger = Logging::create_logger("LoadStoreStallTrace");
    m_logger->info("Loading trace file {} ...", trace_path_str);
    init_trace(trace_path_str);
    m_logger->info("Loaded {} lines.", m_trace.size());
  };

  void tick() override {
    m_clk++;
    if (m_current_stall_cycles > 0) {
      m_current_stall_cycles--;
      return;
    }

    if(m_waiting_for_request == true) {
      return;
    }

    const Trace &t = m_trace[m_curr_trace_idx];

    // addr, type, callback
    Request request(t.addr, t.is_write ? Request::Type::Write : Request::Type::Read,
                    [this](Request &req) { this->receive(req); });

    bool request_sent = m_memory_system->send(request);

    if (request_sent) {
      if(t.is_write == false)
        m_waiting_for_request = true;

      m_current_stall_cycles = t.stall_cycles;
      m_curr_trace_idx = (m_curr_trace_idx + 1) % m_trace_length;
      m_trace_count++;
    }
  };

private:
  void receive(Request &req) {
    m_waiting_for_request = false;
    m_logger->debug("Received request at Clk={}, Addr={}, Type={}",
                    m_clk, req.addr, req.type_id);
  };

  void init_trace(const std::string &file_path_str) {
    fs::path trace_path(file_path_str);
    if (!fs::exists(trace_path)) {
      throw ConfigurationError("Trace {} does not exist!", file_path_str);
    }

    std::ifstream trace_file(trace_path);
    if (!trace_file.is_open()) {
      throw ConfigurationError("Trace {} cannot be opened!", file_path_str);
    }

    std::string line;
    while (std::getline(trace_file, line)) {
      std::vector<std::string> tokens;
      tokenize(tokens, line, " ");

      // cmd addr       stall_cycles
      // LD  0x12345678 3

      // TODO: Add line number here for better error messages
      if (tokens.size() != 3) {
        throw ConfigurationError("Trace {} format invalid!", file_path_str);
      }

      bool is_write = false;
      if (tokens[0] == "LD") {
        is_write = false;
      } else if (tokens[0] == "ST") {
        is_write = true;
      } else {
        throw ConfigurationError("Trace {} format invalid!", file_path_str);
      }

      Addr_t addr = -1;
      if (tokens[1].compare(0, 2, "0x") == 0 |
          tokens[1].compare(0, 2, "0X") == 0) {
        addr = std::stoll(tokens[1].substr(2), nullptr, 16);
      } else {
        addr = std::stoll(tokens[1]);
      }

      int stall_cycles = std::stoi(tokens[2]);

      m_trace.push_back({is_write, addr, stall_cycles});
    }

    trace_file.close();

    m_trace_length = m_trace.size();
  };

  // TODO: FIXME
  bool is_finished() override { return m_trace_count >= m_trace_length; };
};

} // namespace Ramulator