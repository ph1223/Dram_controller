while (std::getline(trace_file, line)) {
  // This is for the case where trace file has 2 & 3 tokens
  std::vector<std::string> tokens;
  tokenize(tokens, line, " ");
  int num_tokens = tokens.size();
  int type_position = 0;
  int bubble_count = 0;
  bool has_store = false;
  Addr_t load_addr = 0;
  Addr_t store_addr = 0;
  // Now make case for 5 tokens
  if (num_tokens == 5) {
    // Case specifically for high-mem trace and low-mem trace of
    // multi-programmed workload case for 5 tokens
    // Copied from Trace::get_filtered_request2 in Processor.cpp of Ramulator
    for (int i = 0; i < tokens.size(); i++) {
      if ((tokens[i] == "L") || (tokens[i] == "S")) {
        type_position = i;
        break;
      }
    }
    if ((type_position >= 3) && ((type_position + 1) < tokens.size())) {
      if (tokens[type_position - 1] != "-")
        bubble_count = std::stoi(tokens[type_position - 1]);
      else
        bubble_count = 0;
      if (tokens[type_position] == "L")
        has_store = false;
      else if (tokens[type_position] == "S") {
        has_store = true;
        store_addr = std::stoll(tokens[type_position + 1]);
      }
      load_addr = std::stoll(tokens[type_position + 1]);
    }
  } else if (num_tokens == 2 || num_tokens == 3) {
    // If it is a store request, 2 tokens are expected, this is the general
    // case for 3 tokens
    bubble_count = std::stoi(tokens[0]);
    load_addr = std::stoll(tokens[1]);
    has_store = num_tokens == 2 ? false : true;
    if (num_tokens == 3)
      store_addr = std::stoll(tokens[2]);
  } else {
    throw ConfigurationError("Trace {} format invalid!", file_path_str);
  }
  if (has_store) {
    m_trace.push_back({bubble_count, load_addr, store_addr});
  } else {
    m_trace.push_back({bubble_count, load_addr, -1});
  }
}