import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math

def read_trace(trace_file):
    data = []

    with open(trace_file, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if len(parts) != 4:
                continue  # skip malformed lines
            op, addr, stall, _ = parts
            try:
                addr = int(addr)
                stall = int(stall)
                # Avoid log(0), skip if address is zero or negative
                if addr <= 0:
                    continue
                log_addr = math.log2(addr)
                data.append((op, log_addr, stall))
            except ValueError:
                continue  # skip lines with invalid integers

    return pd.DataFrame(data, columns=['Operation', 'Log2Address', 'StallCycles'])

def plot_trace(df):
    df['Cycle'] = df.index
    df['Color'] = df['Operation'].map({'LD': 'blue', 'ST': 'red'})

    plt.figure(figsize=(12, 6))
    print(df.dtypes)
    print(df.head())
    print(df['Color'].value_counts())

    plt.scatter(df['Cycle'], df['Log2Address'], c=df['Color'], alpha=0.6, label='Accesses')

    plt.xlabel('Cycle')
    plt.ylabel('log2(Address)')
    plt.title('LLM Core Memory Access Trace')
    plt.grid(True)
    plt.legend(handles=[
        plt.Line2D([0], [0], marker='o', color='w', label='LD', markerfacecolor='blue', markersize=8),
        plt.Line2D([0], [0], marker='o', color='w', label='ST', markerfacecolor='red', markersize=8)
    ])
    plt.tight_layout()
    # plt.show()
    plt.savefig("trace_plot.png", dpi=300)


def main():
    trace_file = 'llm_core_trace.txt'
    df = read_trace(trace_file)

    if df.empty:
        print("No valid trace data found.")
        return

    print(f"Loaded {len(df)} trace entries.")
    plot_trace(df)

if __name__ == '__main__':
    main()
