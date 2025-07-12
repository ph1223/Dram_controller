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

# Split and plot memory_system_cycles grouped and color-coded by subarray count
def split_and_plot(df):
    # Add Group and Subarray columns
    df['Group'] = df['name'].apply(lambda x: 'Auto Refresh' if 'AR' in x else 'WUPR')
    df['Subarray'] = df['name'].apply(extract_ndbl_size)

    # Remove Subarray == 32
    df = df[df['Subarray'] != 32]

    # Use memory_system_cycles directly (no unit conversion)
    df['memory_system_cycles_val'] = df['memory_system_cycles']

    # Sort within each group by memory_system_cycles ascending
    group_ar = df[df['Group'] == 'Auto Refresh'].sort_values(by='memory_system_cycles_val').reset_index(drop=True)
    group_non_ar = df[df['Group'] == 'WUPR'].sort_values(by='memory_system_cycles_val').reset_index(drop=True)

    # Create separator row
    separator = pd.DataFrame([{col: (np.nan if df[col].dtype.kind in 'fiu' else '') for col in df.columns}])
    separator['Group'] = 'Separator'

    # Combine groups with separator
    df_sorted = pd.concat([group_ar, separator, group_non_ar], ignore_index=True)

    # Get unique subarray counts (excluding NaN)
    subarray_vals = sorted(df_sorted['Subarray'].dropna().unique())

    # Create purple-to-yellow colormap
    cmap = LinearSegmentedColormap.from_list("purple_yellow", ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"], N=len(subarray_vals))
    color_list = [cmap(i / (len(subarray_vals) - 1)) for i in range(len(subarray_vals))]
    color_palette = dict(zip(subarray_vals, color_list))

    # Map colors
    df_sorted['Color'] = df_sorted['Subarray'].map(color_palette).fillna('#ffffff')

    # Plotting
    plt.figure(figsize=(14, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    bars = plt.bar(
        bar_positions,
        df_sorted['memory_system_cycles_val'],
        color=bar_colors,
        edgecolor='black'
    )

    # Value labels
    for idx, val in enumerate(df_sorted['memory_system_cycles_val']):
        if pd.notna(val):
            plt.text(idx, val + max(df_sorted['memory_system_cycles_val']) * 0.01, f'{val}', ha='center', va='bottom', fontsize=9)

    # X-axis group labels
    ar_center = len(group_ar) // 2
    wupr_center = len(group_ar) + 1 + len(group_non_ar) // 2
    plt.xticks([ar_center, wupr_center], ['Auto Refresh', 'WUPR'])

    # Legend with integer labels
    legend_elements = [
        Patch(facecolor=color_palette[sub], edgecolor='black', label=f'{int(sub)}')
        for sub in subarray_vals
    ]
    plt.legend(handles=legend_elements, title='Number of Subarrays Per Bank')

    # Labels and layout
    plt.ylabel("Memory System Cycles")
    plt.title("Memory System Cycles: Auto Refresh & WUPR Trend under Different Number of Subarrays")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
