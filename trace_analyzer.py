import matplotlib.pyplot as plt
import numpy as np

ROW_SIZE_BYTES = 2048          # 2KB per row
TOTAL_ROWS     = 65536 * 4     # known total number of rows = 262,144

def analyze_rows(trace_file):
    """
    Return a NumPy array of shape (TOTAL_ROWS,) with values:
    -1 = invalid (never written)
     0 = valid weight row
     1 = valid KV row
    """
    row_state = np.full(TOTAL_ROWS, -1, dtype=np.int8)

    with open(trace_file, 'r') as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) != 4:
                continue
            op, addr, stall, dtype = parts
            try:
                addr = int(addr)
                dtype = int(dtype)
            except ValueError:
                continue

            if op != "ST":
                continue  # we only update rows on writes

            row_idx = addr // ROW_SIZE_BYTES
            if 0 <= row_idx < TOTAL_ROWS:
                row_state[row_idx] = dtype  # overwrite with last write's type

    return row_state

def plot_row_map(row_state, max_rows=None):
    """
    Visualize final DRAM row occupancy as a scatter plot.
    """
    n_rows = len(row_state) if max_rows is None else min(max_rows, len(row_state))
    rows = np.arange(n_rows)

    # Color map: -1 (invalid)=gray, 0 (weight)=blue, 1 (KV)=red
    color_map = np.full(n_rows, "lightgray", dtype=object)
    color_map[row_state[:n_rows] == 0] = "blue"
    color_map[row_state[:n_rows] == 1] = "red"

    plt.figure(figsize=(14, 3))
    plt.scatter(rows, np.zeros_like(rows), c=color_map, marker='s', s=6)

    plt.xlabel("Row Index (0–{:,})".format(len(row_state)-1))
    plt.yticks([])
    plt.title("Final 3D-DRAM Row Occupancy (Valid/Invalid + Data Type)")
    plt.grid(False)

    legend_elements = [
        plt.Line2D([0], [0], marker='s', color='w', label='Invalid (Never Written)',
                   markerfacecolor='lightgray', markersize=8),
        plt.Line2D([0], [0], marker='s', color='w', label='Weights (Valid)',
                   markerfacecolor='blue', markersize=8),
        plt.Line2D([0], [0], marker='s', color='w', label='KV (Valid)',
                   markerfacecolor='red', markersize=8)
    ]
    plt.legend(handles=legend_elements, loc="upper right")
    plt.tight_layout()
    plt.show()

def main():
    trace_file = "llm_core_trace.txt"
    row_state = analyze_rows(trace_file)

    valid_rows = np.sum(row_state != -1)
    weight_rows = np.sum(row_state == 0)
    kv_rows = np.sum(row_state == 1)
    print(f"Total rows: {len(row_state)} | Valid: {valid_rows} | Weight: {weight_rows} | KV: {kv_rows}")

    # Plot first 20k rows for readability; remove max_rows to plot all 262k rows
    plot_row_map(row_state)

if __name__ == "__main__":
    main()
