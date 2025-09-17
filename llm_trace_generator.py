# Each column is a 128B chunk
# Each row is a 2KB chunk
ROW_SIZE = 16      # Columns
MAX_ADDR = 2**22-1 # Columns
COL_SIZE = 128     # Bytes

# ----- STOP AFTER THIS MANY LINES -----
MAX_TRACES = 193_881_265

PORTION_OF_V_WEIGHTS = 0.07
PORTION_OF_K_WEIGHTS = 0.07
PORTION_OF_Q_WEIGHTS = 0.21

NUMBER_OF_REPEATED_DECODE_TIMES = 0

PORTION_OF_INITIAL_ST_V = 0.001
PORTION_OF_INITIAL_ST_K = 0.001

stall_times = 1000

# 1. First ST 35% of whole DRAM with Weights
# 2. LD 7% V, ST 0.1% V
# 3. LD 7% K, ST 0.1% K
# 4. LD 21% Q
# 5. ST tiny KV
# 6. Repeat:
#    - LD 35% weights, LD stored V, LD stored K, LD [KV base .. KV end), ST next KV slice

WEIGHTS_COLUMN_OFFSET = int((2**22-1) // 2)
ST_KV_COLUMN_OFFSET = 0

V_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET
K_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int(PORTION_OF_V_WEIGHTS * MAX_ADDR)
Q_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_V_WEIGHTS + PORTION_OF_K_WEIGHTS) * MAX_ADDR)

V_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET
K_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET + int(PORTION_OF_INITIAL_ST_V * MAX_ADDR)

# FIXED: KV base should be V_store + K_store, not double-adding an absolute
KV_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET \
                    + int(PORTION_OF_INITIAL_ST_V * MAX_ADDR) \
                    + int(PORTION_OF_INITIAL_ST_K * MAX_ADDR)

ST_BACK_KV_PORTION = 0.002
end_offset_of_stored_kv = KV_ST_COLUMN_OFFSET \
                        + int(PORTION_OF_INITIAL_ST_V * MAX_ADDR) \
                        + int(ST_BACK_KV_PORTION * MAX_ADDR)

trace_counter = 0

def _emit(f, op, address, stall, dtype):
    """Write one trace line, respecting MAX_TRACES. Raises StopIteration when quota is reached."""
    global trace_counter
    if trace_counter >= MAX_TRACES:
        raise StopIteration
    f.write(f"{op} {address} {stall} {dtype}\n")
    trace_counter += 1

try:
    with open("llm_core_trace.txt", "w") as f:
        try:
            # 1) ST 35% weights
            total_weights_cols = int((PORTION_OF_V_WEIGHTS + PORTION_OF_K_WEIGHTS + PORTION_OF_Q_WEIGHTS) * MAX_ADDR)
            for column_addr in range(WEIGHTS_COLUMN_OFFSET, WEIGHTS_COLUMN_OFFSET + total_weights_cols):
                _emit(f, "ST", column_addr * COL_SIZE, 0, 0)

            # 2) LD 7% V
            v_cols = int(PORTION_OF_V_WEIGHTS * MAX_ADDR)
            v_last = V_WEIGHTS_COLUMN_OFFSET + v_cols - 1
            for column_addr in range(V_WEIGHTS_COLUMN_OFFSET, V_WEIGHTS_COLUMN_OFFSET + v_cols):
                stall_cycles = 1000 if column_addr == v_last else 0
                _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 0)

            # 3) ST initial V
            init_v_cols = int(PORTION_OF_INITIAL_ST_V * MAX_ADDR)
            for column_addr in range(V_ST_COLUMN_OFFSET, V_ST_COLUMN_OFFSET + init_v_cols):
                _emit(f, "ST", column_addr * COL_SIZE, 0, 1)

            # 4) LD 7% K
            k_cols = int(PORTION_OF_K_WEIGHTS * MAX_ADDR)
            k_last = K_WEIGHTS_COLUMN_OFFSET + k_cols - 1
            for column_addr in range(K_WEIGHTS_COLUMN_OFFSET, K_WEIGHTS_COLUMN_OFFSET + k_cols):
                stall_cycles = 1000 if column_addr == k_last else 0
                _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 0)

            # 5) ST initial K
            init_k_cols = int(PORTION_OF_INITIAL_ST_K * MAX_ADDR)
            for column_addr in range(K_ST_COLUMN_OFFSET, K_ST_COLUMN_OFFSET + init_k_cols):
                _emit(f, "ST", column_addr * COL_SIZE, 0, 1)

            # 6) LD 21% Q
            q_cols = int(PORTION_OF_Q_WEIGHTS * MAX_ADDR)
            q_last = Q_WEIGHTS_COLUMN_OFFSET + q_cols - 1
            for column_addr in range(Q_WEIGHTS_COLUMN_OFFSET, Q_WEIGHTS_COLUMN_OFFSET + q_cols):
                stall_cycles = 1000 if column_addr == q_last else 0
                _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 0)

            # 7) ST tiny KV (mirror your step)
            for column_addr in range(KV_ST_COLUMN_OFFSET, KV_ST_COLUMN_OFFSET + init_v_cols):
                _emit(f, "ST", column_addr * COL_SIZE, 0, 1)

            # 8–9) Decode loop repeats
            for _ in range(NUMBER_OF_REPEATED_DECODE_TIMES):
                # 8a) LD 35% weights
                last = WEIGHTS_COLUMN_OFFSET + total_weights_cols - 1
                for column_addr in range(WEIGHTS_COLUMN_OFFSET, WEIGHTS_COLUMN_OFFSET + total_weights_cols):
                    stall_cycles = 1000 if column_addr == last else 0
                    _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 0)

                # 8b) LD stored V
                last_v = V_ST_COLUMN_OFFSET + init_v_cols - 1
                for column_addr in range(V_ST_COLUMN_OFFSET, V_ST_COLUMN_OFFSET + init_v_cols):
                    stall_cycles = 1000 if column_addr == last_v else 0
                    _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 1)

                # 8c) LD stored K
                last_k = K_ST_COLUMN_OFFSET + init_k_cols - 1
                for column_addr in range(K_ST_COLUMN_OFFSET, K_ST_COLUMN_OFFSET + init_k_cols):
                    stall_cycles = 1000 if column_addr == last_k else 0
                    _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 1)

                # 8d) LD additional KV window
                # FIXED: correct range is [KV_ST_COLUMN_OFFSET, end_offset_of_stored_kv)
                last_kv_ld = end_offset_of_stored_kv - 1
                for column_addr in range(KV_ST_COLUMN_OFFSET, end_offset_of_stored_kv):
                    stall_cycles = 1000 if column_addr == last_kv_ld else 0
                    _emit(f, "LD", column_addr * COL_SIZE, stall_cycles, 1)

                # 9) ST next KV slice appended after current end
                kv_slice_cols = int(ST_BACK_KV_PORTION * MAX_ADDR)
                for column_addr in range(end_offset_of_stored_kv, end_offset_of_stored_kv + kv_slice_cols):
                    _emit(f, "ST", column_addr * COL_SIZE, 0, 1)

                end_offset_of_stored_kv += kv_slice_cols

        except StopIteration:
            # Graceful stop when MAX_TRACES reached
            pass

finally:
    print("Trace generated (capped).")
    print("Total number of traces written: ", trace_counter)
    if trace_counter < MAX_TRACES:
        print(f"Stopped early because generation completed before hitting MAX_TRACES ({MAX_TRACES}).")
    elif trace_counter == MAX_TRACES:
        print("Stopped exactly at MAX_TRACES.")
    else:
        # Should never happen due to guard in _emit
        print("Warning: wrote more than MAX_TRACES (!)")
