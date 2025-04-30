PREAMBLE_CYCLES = 897  # Number of idle cycles before actual trace starts

state_map = {
    'NOP':   '01001',  # FSM_IDLE       = 9
    'ACT':   '01011',  # FSM_ACTIVE     = 11
    'WR':    '01111',  # FSM_WRITE      = 15
    'PRE':   '10001',  # FSM_PRE        = 17
    'RD':    '10000',  # FSM_READ       = 16
    'REFab': '01101',  # FSM_REFRESH    = 13
    'PREA':  '10001',  # Alias for PRE   = 17
}



def parse_trace(lines):
    trace = {}
    for line in lines:
        parts = line.strip().split(',')
        timestamp = int(parts[0].strip())
        command = parts[1].strip()
        trace[timestamp] = command
    return trace

def generate_vcd(trace, max_cycle):
    vcd = []
    vcd.append("$date today $end")
    vcd.append("$version trace_to_vcd.py with precise 1ns clock $end")
    vcd.append("$timescale 0.5ns $end")  # Every timestamp unit is 0.5ns
    vcd.append("$scope module dram $end")
    vcd.append("$var wire 1 ! clock $end")
    vcd.append("$var wire 5 # state $end")
    vcd.append("$upscope $end")
    vcd.append("$enddefinitions $end")
    vcd.append("$dumpvars")
    vcd.append("0!")          # initial clock value
    vcd.append("b0000 #")     # initial state
    vcd.append("$end")

    last_state = 'NOP'
    current_state = 'NOP'
    delayed_trace = {
        ts + PREAMBLE_CYCLES + 1: cmd for ts, cmd in trace.items()
    }

    total_cycles = max_cycle + PREAMBLE_CYCLES + 10  # Extra buffer
    timestamp = 0  # 0.5ns steps

    for cycle in range(total_cycles):
        # Rising edge (clock = 1)
        vcd.append(f"#{timestamp}")
        vcd.append("1!")

        if cycle == PREAMBLE_CYCLES:
            vcd.append("$comment Begin actual trace $end")

        new_state = delayed_trace.get(cycle, 'NOP')
        if new_state != current_state:
            state_bits = state_map.get(new_state, '0000')
            vcd.append(f"b{state_bits} #")
            current_state = new_state

        timestamp += 1  # next step = 0.5ns

        # Falling edge (clock = 0)
        vcd.append(f"#{timestamp}")
        vcd.append("0!")

        timestamp += 1  # next step = 0.5ns

    return "\n".join(vcd)

# Load trace
with open("cmd_records/row_buffer_conflicts_traces.trace.ch0") as f:
    lines = f.readlines()

trace = parse_trace(lines)
max_cycle = max(trace.keys()) + 1

vcd_data = generate_vcd(trace, max_cycle)

with open("output.vcd", "w") as f:
    f.write(vcd_data)

print("VCD waveform saved as output.vcd")
