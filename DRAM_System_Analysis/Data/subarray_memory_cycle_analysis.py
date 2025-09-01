import json
import pandas as pd
import matplotlib.pyplot as plt
import re

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Ndbl size (e.g., from "UCA1_Ndbl_32AR" → 32)
def extract_ndbl_size(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) if match else None

# Plot only Auto Refresh data using gray bars and no legend
def plot_auto_refresh_only(df):
    # Filter to only Auto Refresh group
    df['Group'] = df['name'].apply(lambda x: 'Auto Refresh' if 'AR' in x else 'WUPR')
    df = df[df['Group'] == 'Auto Refresh'].copy()

    # Extract Subarray values and remove Subarray == 32
    df['Subarray'] = df['name'].apply(extract_ndbl_size)
    df = df[df['Subarray'] != 32]

    # Convert cycles to millions for plotting
    df['memory_system_cycles_val'] = df['memory_system_cycles'] / 1e6

    # Sort by Subarray
    df = df.sort_values(by='Subarray').reset_index(drop=True)

    # Plotting
    fig, ax = plt.subplots(figsize=(12, 6))
    bar_positions = list(range(len(df)))
    bar_color = 'gray'

    bars = ax.bar(
        bar_positions,
        df['memory_system_cycles_val'],
        color=bar_color,
        edgecolor='black'
    )

    # Value labels above bars
    for idx, val in enumerate(df['memory_system_cycles_val']):
        if pd.notna(val):
            ax.text(idx, val + max(df['memory_system_cycles_val']) * 0.01,
                    f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # X-axis ticks
    ax.set_xticks(bar_positions)
    ax.set_xticklabels([f'{int(sub)}' for sub in df['Subarray']], rotation=45)
    ax.set_xlabel("Number of Subarrays Per Bank")

    # Labels
    ax.set_ylabel("Memory System Cycles (Million)")
    ax.set_title("Memory System Cycles Trend Under Different Number of Subarrays Per Bank")
    ax.grid(True, linestyle='--', alpha=0.5)

    # Remove legend
    plt.tight_layout(rect=[0, 0, 1, 1])  # No space needed for legend
    plt.show()

if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_auto_refresh_only(df)
