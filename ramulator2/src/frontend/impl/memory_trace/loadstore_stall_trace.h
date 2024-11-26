#include <filesystem>
#include <fstream>
#include <functional>
#include <iostream>

#include "base/exception.h"
#include "base/request.h"
#include "frontend/frontend.h"
#include "loadstore_stall_trace.h"

namespace Ramulator
{

class LoadStoreTraces{

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


  //callback
  std::function<void(Request &)> m_callback;

public:
  LoadStoreStallCore(int clk_ratio, std::string trace_path_str);

  void tick() override;

  void receive(Request &req);

  void connect_memory_system(IMemorySystem *memory_system) override;

private:

  void init_trace(const std::string &file_path_str);

  // TODO: FIXME
  bool is_finished();
};

}
}// namespace Ramulator