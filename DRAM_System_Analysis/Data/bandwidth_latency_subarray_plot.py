import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.colors import LinearSegmentedColormap

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Subarray Count from Name
def extract_subarray_count(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) // 2 if match else None

# Main Plotting Function
def plot_all_combined(df):
    # Preprocessing
    df['Subarray'] = df['name'].apply(extract_subarray_count)
    df = df[df['Subarray'].notnull()].copy()
    df['Subarray'] = df['Subarray'].astype(int)
    df['memory_system_cycles_m'] = df['memory_system_cycles'] / 1e6
    df['total_energy_mJ'] = df['total_energy'] / 1e6
    df = df.sort_values(by='Subarray').reset_index(drop=True)

    # Setup bar positions and widths
    n = len(df)
    scale_factor = 0.2
    bar_positions = np.arange(n) * scale_factor
    bar_width = 0.12
    subarray_labels = [str(sub) for sub in df['Subarray']]

    # Define colormap
    unique_subarrays = sorted(df['Subarray'].unique())
    cmap = LinearSegmentedColormap.from_list(
        "purple_orange",
        ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"],
        N=len(unique_subarrays)
    )
    color_dict = {sub: cmap(i) for i, sub in enumerate(unique_subarrays)}
    colors = df['Subarray'].map(color_dict)

    # Create larger figure
    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 11), sharex=True)
    plt.subplots_adjust(hspace=0.25, bottom=0.15)

    # --- Plot 1: Average Bandwidth ---
    ax1.bar(bar_positions, df['frontend_avg_bandwidth'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['frontend_avg_bandwidth']):
        ax1.text(x, val + 0.8, f'{val:.2f}', ha='center', va='bottom', fontsize=12)
    ax1.axhline(y=128, color='black', linestyle='--', linewidth=1.2)
    ax1.text(bar_positions[-1], 127.5, 'Upper Bound Bandwidth (128 GB/s)',
             ha='right', va='top', fontsize=11)
    ax1.set_ylabel("Avg Bandwidth (GB/s)", fontsize=12)
    ax1.set_ylim(df['frontend_avg_bandwidth'].min() - 2, 130)
    ax1.grid(False)

    # --- Plot 2: Simulation Cycles ---
    ax2.bar(bar_positions, df['memory_system_cycles_m'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['memory_system_cycles_m']):
        ax2.text(x, val + 0.8, f'{val:.2f}', ha='center', va='bottom', fontsize=12)
    ax2.set_ylabel("Cycles (Million)", fontsize=12)
    ax2.set_ylim(df['memory_system_cycles_m'].min() - 2,
                 df['memory_system_cycles_m'].max() + 4)
    ax2.grid(False)

    # --- Plot 3: Total Energy ---
    ax3.bar(bar_positions, df['total_energy_mJ'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['total_energy_mJ']):
        ax3.text(x, val + 0.8, f'{val:.3f}', ha='center', va='bottom', fontsize=12)
    ax3.set_ylabel("Total Energy (mJ)", fontsize=12)
    ax3.set_ylim(df['total_energy_mJ'].min() * 0.95,
                 df['total_energy_mJ'].max() * 1.05)
    ax3.grid(False)

    # X-axis ticks and label
    plt.xticks(bar_positions, subarray_labels, rotation=45, fontsize=11)
    for ax in (ax1, ax2, ax3):
        ax.tick_params(axis='x', which='both', bottom=True, top=False, labelbottom=True)
        ax.set_xlim(bar_positions[0] - 0.5, bar_positions[-1] + 0.5)

    # Global labels
    fig.text(0.5, 0.06, "Number of Subarrays Per Bank", ha='center', fontsize=13)
    fig.suptitle("Average Bandwidth, Simulation Cycles & Total Energy Trend"
                 "for Different Number of Subarrays per Bank", fontsize=14)

    plt.show()

# Entry Point
if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_all_combined(df)
