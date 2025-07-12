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

# Extract Ndbl size (e.g., from "UCA1_Ndbl_32AR" → "32")
def extract_ndbl_size(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return match.group(1) if match else "unknown"

# Split and plot sorted, color-coded bars
def split_and_plot(df):
    # Step 1: Add Group and Subarray columns
    df['Group'] = df['name'].apply(lambda x: 'Auto Refresh' if 'AR' in x else 'WUPR')
    df['Subarray'] = df['name'].apply(extract_ndbl_size)

    # Step 2: Remove rows with Subarray == "32"
    df = df[df['Subarray'] != "32"]

    # Step 3: Sort within each group by bandwidth
    group_ar = df[df['Group'] == 'Auto Refresh'].sort_values(by='frontend_avg_bandwidth')
    group_non_ar = df[df['Group'] == 'WUPR'].sort_values(by='frontend_avg_bandwidth')

    # Step 4: Add a separator row
    separator = pd.DataFrame([{
        'name': '',
        'frontend_avg_bandwidth': np.nan,
        'Group': 'Separator',
        'Subarray': '',
        'Color': '#ffffff'
    }])

    # Step 5: Combine groups
    df_sorted = pd.concat([group_ar, separator, group_non_ar], ignore_index=True)

    # Step 6: Create purple-to-yellow colormap
    unique_subarrays = sorted(df_sorted['Subarray'].unique(), key=lambda x: int(x) if x.isdigit() else 999)
    if '' in unique_subarrays:
        unique_subarrays.remove('')

    n = len(unique_subarrays)
    cmap = LinearSegmentedColormap.from_list("purple_yellow", ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"], N=n)
    color_list = [cmap(i / (n - 1)) for i in range(n)]
    purple_yellow_palette = dict(zip(unique_subarrays, color_list))

    # Step 7: Assign color
    df_sorted['Color'] = df_sorted['Subarray'].map(purple_yellow_palette).fillna('#ffffff')

    # Step 8: Plotting
    plt.figure(figsize=(14, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    bars = plt.bar(
        bar_positions,
        df_sorted['frontend_avg_bandwidth'],
        color=bar_colors,
        edgecolor='black'
    )

    for idx, val in enumerate(df_sorted['frontend_avg_bandwidth']):
        if pd.notna(val):
            plt.text(
                idx, val + 1,
                f'{val:.2f}',
                ha='center', va='bottom',
                fontsize=9
            )

    # Horizontal line for upper bound
    plt.axhline(
        y=128,
        color='black',
        linestyle='--',
        linewidth=1.5
    )
    plt.text(
        x=len(df_sorted) - 1,
        y=128 + 2,
        s='Ideal Bandwidth (128 GB/s)',
        color='black',
        fontsize=10,
        ha='right'
    )

    # X-axis group labels
    ar_center = len(group_ar) // 2
    wupr_center = len(group_ar) + 1 + len(group_non_ar) // 2
    plt.xticks(
        [ar_center, wupr_center],
        ['Auto Refresh', 'WUPR']
    )

    # Legend with patches
    legend_elements = [
        plt.Rectangle((0, 0), 1, 1, facecolor=purple_yellow_palette[sub], edgecolor='black')
        for sub in unique_subarrays
    ]
    legend_labels = [sub for sub in unique_subarrays]

    plt.legend(
        legend_elements,
        legend_labels,
        title='Number of Subarrays Per Bank'
    )

    plt.ylabel("Average Bandwidth (GB/s)")
    plt.title("Average Bandwidth: Auto Refresh & WUPR Trend under Different Number of Subarrays")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
