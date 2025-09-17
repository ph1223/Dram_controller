import matplotlib.pyplot as plt
import numpy as np

ROW_SIZE_BYTES = 2048  # 2KB per row

def analyze_rows(trace_file):
    row_state = {}  # row_idx -> (valid_flag, data_type)

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

            row_idx = addr // ROW_SIZE_BYTES

            if op == "ST":
                # Mark row as valid + record data type
                row_state[row_idx] = (1, dtype)

    return row_state

def plot_row_map(row_state, max_rows=None):
    if not row_state:
        print("No rows were written.")
        return

    # Determine max row index
    max_row = max(row_state.keys()) if max_rows is None else max_rows
    rows = np.arange(max_row + 1)

    # Default: invalid (gray)
    colors = np.full(len(rows), "lightgray", dtype=object)

    # Apply valid rows
    for row_idx, (valid, dtype) in row_state.items():
        if row_idx > max_row:
            continue
        if dtype == 0:  # weights
            colors[row_idx] = "blue"
        elif dtype == 1:  # KV
            colors[row_idx] = "red"

    plt.figure(figsize=(12, 4))
    plt.scatter(rows, np.zeros_like(rows), c=colors, marker='s', s=10)

    plt.xlabel("Row Index")
    plt.yticks([])  # remove y axis (not needed)
    plt.title("Final DRAM Row Occupancy (Valid/Invalid + Data Type)")
    plt.grid(False)

    legend_elements = [
        plt.Line2D([0], [0], marker='s', color='w', label='Invalid Row', markerfacecolor='lightgray', markersize=10),
        plt.Line2D([0], [0], marker='s', color='w', label='Weights (valid)', markerfacecolor='blue', markersize=10),
        plt.Line2D([0], [0], marker='s', color='w', label='KV (valid)', markerfacecolor='red', markersize=10)
    ]
    plt.legend(handles=legend_elements, loc="upper right")
    plt.tight_layout()
    plt.show()

def main():
    trace_file = "llm_core_trace.txt"
    row_state = analyze_rows(trace_file)
    print(f"Total valid rows: {len(row_state)}")

    plot_row_map(row_state, max_rows=2000)  # cap to first 2000 rows for readability

if __name__ == "__main__":
    main()
