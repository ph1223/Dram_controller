import math

# ========== USER CONFIG ==========
ROW_SIZE = 16
MAX_ADDR = 2**22 - 1
COL_SIZE = 128

MAX_TRACES_PER_FILE = 193881265  # <-- HARD CAP per trace file

PORTION_OF_V_WEIGHTS = 0.07
PORTION_OF_K_WEIGHTS = 0.07
PORTION_OF_Q_WEIGHTS = 0.21

NUMBER_OF_REPEATED_DECODE_TIMES = 128
NUMBER_OF_REPEATED_DECODE_TIMES_NEW_INPUT = 128

PORTION_OF_INITIAL_ST_V = 0.001
PORTION_OF_INITIAL_ST_K = 0.001

ST_BACK_KV_PORTION = 0.002
STALL_CYCLES = 1000

NUMBER_OF_NEW_INPUT_SESSIONS = 2
RESET_KV_FOR_NEW_INPUT = True  # Always start KV from base for new input

# ---- ADDRESS MAP ----
WEIGHTS_COLUMN_OFFSET  = int((2**22-1) // 2)
ST_KV_COLUMN_OFFSET    = 0

V_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET
K_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int(PORTION_OF_V_WEIGHTS * MAX_ADDR)
Q_WEIGHTS_COLUMN_OFFSET = WEIGHTS_COLUMN_OFFSET + int((PORTION_OF_V_WEIGHTS + PORTION_OF_K_WEIGHTS) * MAX_ADDR)

V_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET
K_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET + int(PORTION_OF_INITIAL_ST_V * MAX_ADDR)

KV_ST_COLUMN_OFFSET = ST_KV_COLUMN_OFFSET \
                    + int(PORTION_OF_INITIAL_ST_V * MAX_ADDR) \
                    + int(PORTION_OF_INITIAL_ST_K * MAX_ADDR)

# ========== FAST EMIT UTIL ==========
def bulk_emit_range(op, start_col, end_col, dtype, stall_last=False, remaining=None):
    """
    Return a big string with all lines for given column range.
    If remaining is provided, emit at most that many lines.
    Returns (string, lines_emitted).
    """
    n = end_col - start_col
    if remaining is not None:
        n = min(n, remaining)

    last_col = start_col + n - 1 if stall_last else -1
    lines = []
    append = lines.append
    for i in range(n):
        col = start_col + i
        stall = STALL_CYCLES if col == last_col else 0
        append(f"{op} {col * COL_SIZE} {stall} {dtype}\n")
    return "".join(lines), n

# ========== TRACE GENERATOR ==========
def generate_trace(out_path,
                   max_traces_cap,
                   include_initial_weight_store=True,
                   include_vqk_bootstrap=True,
                   num_decode_loops=128,
                   kv_start_offset=None):
    """
    Generate trace and stop if we exceed max_traces_cap lines.
    Returns final KV offset after generation (for continuity if needed).
    """
    total_weights_cols = int((PORTION_OF_V_WEIGHTS + PORTION_OF_K_WEIGHTS + PORTION_OF_Q_WEIGHTS) * MAX_ADDR)
    v_cols  = int(PORTION_OF_V_WEIGHTS * MAX_ADDR)
    k_cols  = int(PORTION_OF_K_WEIGHTS * MAX_ADDR)
    q_cols  = int(PORTION_OF_Q_WEIGHTS * MAX_ADDR)
    init_v_cols = int(PORTION_OF_INITIAL_ST_V * MAX_ADDR)
    init_k_cols = int(PORTION_OF_INITIAL_ST_K * MAX_ADDR)

    # --- Correct KV window initialization ---
    if kv_start_offset is not None:
        kv_offset = kv_start_offset
    else:
        if include_vqk_bootstrap:
            # Session 1: we stored a tiny KV bootstrap, so the first decode LD
            # should read exactly that bootstrapped window.
            kv_offset = KV_ST_COLUMN_OFFSET + init_v_cols
        else:
            # New-input decode-only session: KV$ starts empty; the first decode pass
            # has an empty KV window and grows only after the first ST slice.
            kv_offset = KV_ST_COLUMN_OFFSET

    remaining = max_traces_cap
    with open(out_path, "w") as f:
        # ---------- INITIAL STAGES ----------
        if include_initial_weight_store and remaining > 0:
            chunk, used = bulk_emit_range("ST", WEIGHTS_COLUMN_OFFSET, WEIGHTS_COLUMN_OFFSET + total_weights_cols, 0, remaining=remaining)
            f.write(chunk); remaining -= used
            if remaining <= 0: return kv_offset

        if include_vqk_bootstrap and remaining > 0:
            for (op, start, end, dtype, stall) in [
                ("LD", V_WEIGHTS_COLUMN_OFFSET, V_WEIGHTS_COLUMN_OFFSET + v_cols, 0, True),
                ("ST", V_ST_COLUMN_OFFSET, V_ST_COLUMN_OFFSET + init_v_cols, 1, False),
                ("LD", K_WEIGHTS_COLUMN_OFFSET, K_WEIGHTS_COLUMN_OFFSET + k_cols, 0, True),
                ("ST", K_ST_COLUMN_OFFSET, K_ST_COLUMN_OFFSET + init_k_cols, 1, False),
                ("LD", Q_WEIGHTS_COLUMN_OFFSET, Q_WEIGHTS_COLUMN_OFFSET + q_cols, 0, True),
                ("ST", KV_ST_COLUMN_OFFSET, KV_ST_COLUMN_OFFSET + init_v_cols, 1, False),
            ]:
                chunk, used = bulk_emit_range(op, start, end, dtype, stall_last=stall, remaining=remaining)
                f.write(chunk); remaining -= used
                if remaining <= 0: return kv_offset

        # ---------- DECODE LOOPS ----------
        for _ in range(num_decode_loops):
            for (op, start, end, dtype, stall) in [
                ("LD", WEIGHTS_COLUMN_OFFSET, WEIGHTS_COLUMN_OFFSET + total_weights_cols, 0, True),
                ("LD", V_ST_COLUMN_OFFSET, V_ST_COLUMN_OFFSET + init_v_cols, 1, True),
                ("LD", K_ST_COLUMN_OFFSET, K_ST_COLUMN_OFFSET + init_k_cols, 1, True),
                ("LD", KV_ST_COLUMN_OFFSET, kv_offset, 1, True),
                ("ST", kv_offset, kv_offset + int(ST_BACK_KV_PORTION * MAX_ADDR), 1, False)
            ]:
                chunk, used = bulk_emit_range(op, start, end, dtype, stall_last=stall, remaining=remaining)
                f.write(chunk); remaining -= used
                if remaining <= 0: return kv_offset
                if op == "ST": kv_offset = end  # update KV offset after ST

    print(f"[{out_path}] capped at {max_traces_cap} lines, kv_end={kv_offset}")
    return kv_offset

# ========= RUN SESSION 1 (bootstrap + decode loops) =========
kv_end = generate_trace(
    out_path="llm_core_trace0.txt",
    max_traces_cap=MAX_TRACES_PER_FILE,
    include_initial_weight_store=True,
    include_vqk_bootstrap=True,      # bootstraps KV$, then decode loops run
    num_decode_loops=NUMBER_OF_REPEATED_DECODE_TIMES
)

# ========= RUN MULTIPLE NEW INPUT SESSIONS (decode-only, KV$ empty at start) =========
for i in range(1, NUMBER_OF_NEW_INPUT_SESSIONS + 1):
    kv_start = None if RESET_KV_FOR_NEW_INPUT else kv_end
    kv_end = generate_trace(
        out_path=f"llm_core_trace{i}.txt",
        max_traces_cap=MAX_TRACES_PER_FILE,
        include_initial_weight_store=False,
        include_vqk_bootstrap=False,  # decode-only
        num_decode_loops=NUMBER_OF_REPEATED_DECODE_TIMES_NEW_INPUT,
        kv_start_offset=kv_start
    )
