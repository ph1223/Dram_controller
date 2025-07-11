import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np

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

    # Step 2: Sort within each group by bandwidth
    group_ar = df[df['Group'] == 'Auto Refresh'].sort_values(by='frontend_avg_bandwidth')
    group_non_ar = df[df['Group'] == 'WUPR'].sort_values(by='frontend_avg_bandwidth')

    # Step 3: Add a separator row (NaNs) between groups
    separator = pd.DataFrame([{
        'name': '',
        'frontend_avg_bandwidth': np.nan,
        'Group': 'Separator',
        'Subarray': '',
        'Color': '#ffffff'  # invisible
    }])

    # Step 4: Combine groups with separator
    df_sorted = pd.concat([group_ar, separator, group_non_ar], ignore_index=True)

    # Step 5: Define custom color palette for Subarray
    custom_palette = {
        "32": "#ce6a6b",
        "64": "#8c564b",
        "128": "#bed3c3",
        "256": "#4a919e",
        "512": "#212e53",
        "1024": "#ebaca2"
    }

    # Map color to each row (including NaN-safe map)
    df_sorted['Color'] = df_sorted['Subarray'].map(custom_palette).fillna('#ffffff')

    # Step 6: Plotting
    plt.figure(figsize=(14, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    bars = plt.bar(
        bar_positions,
        df_sorted['frontend_avg_bandwidth'],
        color=bar_colors
    )

    # Add value labels above bars (skip NaNs)
    for idx, val in enumerate(df_sorted['frontend_avg_bandwidth']):
        if pd.notna(val):
            plt.text(
                idx, val + 1,
                f'{val:.2f}',
                ha='center', va='bottom',
                fontsize=9
            )

    # Add horizontal line for upper bound
    plt.axhline(
        y=128,
        color='black',
        linestyle='--',
        linewidth=1.5,
        label='128 GB/s Upper Bound'
    )

    # Add text label for the upper bound
    plt.text(
        x=len(df_sorted) - 1,
        y=128 + 2,
        s='Ideal Bandwidth (128 GB/s)',
        color='black',
        fontsize=10,
        ha='right'
    )

    # X-axis ticks for group labels
    ar_center = len(group_ar) // 2
    wupr_center = len(group_ar) + 1 + len(group_non_ar) // 2
    plt.xticks(
        [ar_center, wupr_center],
        ['Auto Refresh', 'WUPR']
    )

    # Legend for Subarray count
    legend_elements = []
    for sub, color in custom_palette.items():
        patch = plt.Rectangle((0, 0), 1, 1, color=color)
        legend_elements.append((sub, patch))

    # Add the upper bound line to legend
    # legend_elements.append(("128 GB/s Upper Bound", plt.Line2D([0], [0], color='black', linestyle='--')))

    # Sort and show legend
    legend_elements.sort(key=lambda x: int(x[0]) if x[0].isdigit() else 999)
    plt.legend(
        [p for _, p in legend_elements],
        [l for l, _ in legend_elements],
        title='# of Subarrays'
    )

    # Final touches
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
