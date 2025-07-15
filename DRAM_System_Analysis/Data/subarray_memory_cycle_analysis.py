import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.patches import Patch
from matplotlib.colors import LinearSegmentedColormap

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Ndbl size (e.g., from "UCA1_Ndbl_32AR" → 32)
def extract_ndbl_size(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) if match else None

# Plot only Auto Refresh data
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

    # Get unique subarray counts
    subarray_vals = sorted(df['Subarray'].dropna().unique())

    # Color map for subarray values
    cmap = LinearSegmentedColormap.from_list("purple_yellow", ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"], N=len(subarray_vals))
    color_list = [cmap(i / (len(subarray_vals) - 1)) for i in range(len(subarray_vals))]
    color_palette = dict(zip(subarray_vals, color_list))
    df['Color'] = df['Subarray'].map(color_palette)

    # Plotting
    fig, ax = plt.subplots(figsize=(12, 6))
    bar_positions = list(range(len(df)))
    bar_colors = df['Color'].tolist()

    bars = ax.bar(
        bar_positions,
        df['memory_system_cycles_val'],
        color=bar_colors,
        edgecolor='black'
    )

    # Value labels (no 'M')
    for idx, val in enumerate(df['memory_system_cycles_val']):
        if pd.notna(val):
            ax.text(idx, val + max(df['memory_system_cycles_val']) * 0.01,
                    f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # X-axis ticks
    ax.set_xticks(bar_positions)
    ax.set_xticklabels([f'{int(sub)}' for sub in df['Subarray']], rotation=45)
    ax.set_xlabel("Number of Subarrays Per Bank")

    # Labels and legend
    ax.set_ylabel("Memory System Cycles (Million)")
    ax.set_title("Memory System Cycles Trend Under Different Number of Subarrays Per Bank")
    ax.grid(True, linestyle='--', alpha=0.5)

    # Legend
    legend_elements = [
        Patch(facecolor=color_palette[sub], edgecolor='black', label=f'{int(sub)}')
        for sub in subarray_vals
    ]
    ax.legend(handles=legend_elements, title='Subarray Count',
              loc='center left', bbox_to_anchor=(1.02, 0.5), borderaxespad=0.)

    plt.tight_layout(rect=[0, 0, 0.85, 1])  # Room for legend
    plt.show()

if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_auto_refresh_only(df)
