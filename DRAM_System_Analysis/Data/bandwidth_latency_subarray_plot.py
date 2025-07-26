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

# Extract Subarray count from Ndbl (Subarray = Ndbl / 2)
def extract_subarray_count(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) // 2 if match else None

# Merged plot: Bandwidth, Cycles, Energy
def plot_all_combined(df):
    # Extract Subarray and compute metrics
    df['Subarray'] = df['name'].apply(extract_subarray_count)
    df = df[df['Subarray'].notnull()].copy()
    df['Subarray'] = df['Subarray'].astype(int)
    df['memory_system_cycles_m'] = df['memory_system_cycles'] / 1e6
    df['total_energy_mJ'] = df['total_energy'] / 1e6
    df = df.sort_values(by='Subarray').reset_index(drop=True)

    # Plot setup
    bar_width = 0.2
    x_spacing = 0.35
    bar_positions = np.arange(len(df)) * x_spacing
    subarray_labels = [str(sub) for sub in df['Subarray']]

    # Color mapping
    unique_subarrays = sorted(df['Subarray'].unique())
    cmap = LinearSegmentedColormap.from_list(
        "purple_orange",
        ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"],
        N=len(unique_subarrays)
    )
    color_dict = {sub: cmap(i) for i, sub in enumerate(unique_subarrays)}
    colors = df['Subarray'].map(color_dict)

    # Create figure with 3 stacked subplots
    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(13, 13), sharex=True)
    plt.subplots_adjust(hspace=0.6, bottom=0.15)

    # Plot 1: Average Bandwidth
    ax1.bar(bar_positions, df['frontend_avg_bandwidth'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['frontend_avg_bandwidth']):
        ax1.text(x, val + 0.8, f'{val:.2f}', ha='center', va='bottom', fontsize=9)
    ax1.axhline(y=128, color='black', linestyle='--', linewidth=1.5)
    ax1.text(bar_positions[-1], 127.5,
             'Upper Bound Bandwidth (128 GB/s)', ha='right', va='top', fontsize=10)
    ax1.set_ylabel("Avg Bandwidth (GB/s)")
    ax1.set_ylim(df['frontend_avg_bandwidth'].min() - 2, 130)
    ax1.grid(True, linestyle='--', alpha=0.5)
    ax1.set_xticks(bar_positions)
    ax1.set_xticklabels(subarray_labels, rotation=45)
    ax1.tick_params(labelbottom=True)

    # Plot 2: Simulation Cycles
    ax2.bar(bar_positions, df['memory_system_cycles_m'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['memory_system_cycles_m']):
        ax2.text(x, val + 0.8, f'{val:.2f}', ha='center', va='bottom', fontsize=9)
    ax2.set_ylabel("Cycles (Million)")
    ax2.set_ylim(df['memory_system_cycles_m'].min() - 2,
                 df['memory_system_cycles_m'].max() + 4)
    ax2.grid(True, linestyle='--', alpha=0.5)
    ax2.set_xticks(bar_positions)
    ax2.set_xticklabels(subarray_labels, rotation=45)
    ax2.tick_params(axis='x', labelbottom=True)

    # Plot 3: Total Energy
    ax3.bar(bar_positions, df['total_energy_mJ'], width=bar_width,
            color=colors, edgecolor='black')
    for x, val in zip(bar_positions, df['total_energy_mJ']):
        ax3.text(x, val + 0.8, f'{val:.3f}', ha='center', va='bottom', fontsize=9)
    ax3.set_ylabel("Total Energy (mJ)")
    ax3.set_ylim(df['total_energy_mJ'].min() * 0.95,
                 df['total_energy_mJ'].max() * 1.05)
    ax3.grid(True, linestyle='--', alpha=0.5)
    ax3.set_xticks(bar_positions)
    ax3.set_xticklabels(subarray_labels, rotation=45)

    # Shared X label and updated title
    fig.text(0.5, 0.05, "Number of Subarrays Per Bank", ha='center', fontsize=12)
    fig.suptitle(
        "Average Bandwidth, Simulation Cycles & Total Energy Trend\n"
        "for Different Number of Subarrays per Bank",
        fontsize=14
    )

    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_all_combined(df)
