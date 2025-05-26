# Each column is a 128B chunk
# Each row is a 2KB chunk
ROW_SIZE = 16      # Columns
MAX_ADDR = 2**22-1 # Columns
COL_SIZE = 128 # Bytes

# This is a simple LLM trace generator that generates a trace of LLM calls
# and their parameters. The trace is generated in a format that can be
# easily be parsed by a trace parser. The trace is generated in a format
# that can be easily be parsed by a trace parser. The trace is generated

PORTION_OF_V_WEIGHTS = 0.07
# PORTION_OF_V_WEIGHTS = 0.001
PORTION_OF_K_WEIGHTS = 0.07
# PORTION_OF_K_WEIGHTS = 0.001
PORTION_OF_Q_WEIGHTS = 0.21
# PORTION_OF_Q_WEIGHTS = 0.001

NUMBER_OF_REPEATED_DECODE_TIMES = 16

PORTION_OF_INITIAL_ST_V = 0.01
PORTION_OF_INITIAL_ST_K = 0.01

# Generates the traces of LLM with these parameters in mind:
# The generated format should be following: LD <address> <stall_cycles>
# The generated format should be following: ST <address> <stall_cycles>
# 1. First ST 35% of whole DRAM with Weights
# 2. Then  LD 7%  of Weights for V
# 3. Then  ST 1%  of V back to DRAM
# 4. Then  LD 7%  of Weights for K
# 5. Then  ST 1%  of K back to DRAMs
# 6. Then  LD 21% of Weights for Qs
# 7. Then  ST 0.0001% of KV back to DRAMs
# 8. Load  the whole 35% of Weights + new 0.0001% of KVs
# 9. ST 0.0001% of KV back to DRAMs
# Repeats 8~9 for 32 times
# end
#end of traces
## The starting positions of each weights and traces
WEIGHTS_COLUMN_OFFSET = int((2**22-1) // 2)
ST_KV_COLUMN_OFFSET = 0

V_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET
K_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_V_WEIGHTS)*MAX_ADDR)
Q_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_V_WEIGHTS)*MAX_ADDR) + int((PORTION_OF_K_WEIGHTS)*MAX_ADDR)

V_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET
K_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR)

KV_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET + K_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_K)*MAX_ADDR)
number_of_stored_kv = 0

ST_BACK_KV_PORTION = 0.0001
end_offset_of_stored_kv =  KV_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR) + int((ST_BACK_KV_PORTION)*MAX_ADDR)


# Trace counter, count the number of traces
trace_counter = 0

# Write the trace to a file
with open("llm_core_trace.txt", "w") as f:
    # 1. First ST 35% of whole DRAM with Weights
    for column_addr in range(WEIGHTS_COLUMN_OFFSET,WEIGHTS_COLUMN_OFFSET+int((PORTION_OF_K_WEIGHTS+PORTION_OF_Q_WEIGHTS+PORTION_OF_V_WEIGHTS)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"ST {address} {stall_cycles} {0}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 2. Then  LD 7%  of Weights for V
    for column_addr in range(V_WEIGHTS_COLUMN_OFFSET,V_WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_V_WEIGHTS)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"LD {address} {stall_cycles} {0}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 3. Then ST 1%  of V back to DRAM
    for column_addr in range(V_ST_COLUMN_OFFSET,V_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"ST {address} {stall_cycles} {1}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 4. Then  LD 7%  of Weights for K
    for column_addr in range(K_WEIGHTS_COLUMN_OFFSET,K_WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_K_WEIGHTS)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"LD {address} {stall_cycles} {0}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 5. Then  ST 1%  of K back to DRAM
    for column_addr in range(K_ST_COLUMN_OFFSET,K_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_K)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"ST {address} {stall_cycles} {1}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 6. Then  LD 21% of Weights for Qs
    for column_addr in range(Q_WEIGHTS_COLUMN_OFFSET,Q_WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_Q_WEIGHTS)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"LD {address} {stall_cycles} {0}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # 7. Then  ST 0.0001% of KV back to DRAMs
    for column_addr in range(KV_ST_COLUMN_OFFSET,KV_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR)):
        # Generate the address
        address = column_addr * COL_SIZE
        stall_cycles = 0
        f.write(f"ST {address} {stall_cycles} {1}\n")
        # Write the value of channel,row,column,word
        # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
        trace_counter += 1

    # Repeat 8~9 for 32 times
    for num_token in range(NUMBER_OF_REPEATED_DECODE_TIMES):
        # 8. Load the whole 35% of Weights
        for column_addr in range(WEIGHTS_COLUMN_OFFSET,WEIGHTS_COLUMN_OFFSET+int((PORTION_OF_K_WEIGHTS+PORTION_OF_Q_WEIGHTS+PORTION_OF_V_WEIGHTS)*MAX_ADDR)):
            # Generate the address
            address = column_addr * COL_SIZE
            stall_cycles = 0
            f.write(f"LD {address} {stall_cycles} {0}\n")
            # Write the value of channel,row,column,word
            # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
            trace_counter += 1

        # LD 1% of STORED V
        for column_addr in range(V_ST_COLUMN_OFFSET,V_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR)):
            # Generate the address
            address = column_addr * COL_SIZE
            stall_cycles = 0
            f.write(f"LD {address} {stall_cycles} {1}\n")
            # Write the value of channel,row,column,word
            # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
            trace_counter += 1

        # LD 1% of STORED K
        for column_addr in range(K_ST_COLUMN_OFFSET,K_ST_COLUMN_OFFSET + int((PORTION_OF_INITIAL_ST_K)*MAX_ADDR)):
            # Generate the address
            address = column_addr * COL_SIZE
            stall_cycles = 0
            f.write(f"LD {address} {stall_cycles} {1}\n")
            # Write the value of channel,row,column,word
            # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
            trace_counter += 1

        # LD Additional portion of KVs
        for column_addr in range(KV_ST_COLUMN_OFFSET, KV_ST_COLUMN_OFFSET+ end_offset_of_stored_kv):
            # Generate the address
            address = column_addr * COL_SIZE
            stall_cycles = 0
            f.write(f"LD {address} {stall_cycles} {1}\n")
            # Write the value of channel,row,column,word
            # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
            trace_counter += 1

        # 9. ST 0.0001% of KV back to DRAMs
        for column_addr in range(end_offset_of_stored_kv,end_offset_of_stored_kv + int((ST_BACK_KV_PORTION)*MAX_ADDR)):
            # Generate the address
            address = column_addr * COL_SIZE
            stall_cycles = 0
            # print(f"ST {address} {stall_cycles}")
            # Write the value of channel,row,column,word
            # print("{0} {1} {2} {3}".format(0,column_addr,0,0))
            f.write(f"ST {address} {stall_cycles} {1}\n")
            trace_counter += 1

        # update the end offset of stored kv
        end_offset_of_stored_kv += int((PORTION_OF_INITIAL_ST_V)*MAX_ADDR)


# Trace generated
print("Trace generated")
print("Total number of traces: ", trace_counter)