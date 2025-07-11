import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.patches import Patch

# Load JSON data
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract delay prefix (8ms, 16ms, 32ms)
def extract_delay_group(name):
    match = re.match(r'^(8ms|16ms|32ms)', name)
    return match.group(1) if match else 'Unknown'

# Define Refresh Type based on name content
def extract_refresh_type(name):
    if 'ideal' in name:
        return 'No Refresh'
    elif 'With_WUPR' in name:
        return 'WUPR'
    elif 'Without_WUPR' in name:
        return 'Auto Refresh'
    else:
        return 'Unknown'

# Plotting function
def split_and_plot(df):
    # Tag rows
    df['DelayGroup'] = df['name'].apply(extract_delay_group)
    df['RefreshType'] = df['name'].apply(extract_refresh_type)

    # Extract single ideal point
    ideal_row = df[df['RefreshType'] == 'No Refresh']
    if not ideal_row.empty:
        ideal_row = ideal_row.iloc[0]
    else:
        print("No 'ideal' data point found.")
        return

    # Delay groups and refresh order
    delay_groups = ['32ms', '16ms', '8ms']
    refresh_order = ['Auto Refresh', 'WUPR', 'No Refresh']

    # Color map
    refresh_color = {
        'Auto Refresh': '#1f77b4',  # blue
        'WUPR': '#ff7f0e',          # orange
        'No Refresh': '#2ca02c'     # green
    }

    df_grouped = []
    separator = pd.DataFrame([{'frontend_avg_bandwidth': np.nan, 'DelayGroup': 'Separator', 'RefreshType': '', 'name': ''}])

    # Will store improvement text and positions
    improvement_texts = []
    improvement_positions = []

    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        entries = []
        bw_auto = None
        bw_wupr = None

        for rtype in refresh_order:
            if rtype == 'No Refresh':
                # Duplicate ideal_row with new DelayGroup
                new_ideal = ideal_row.copy()
                new_ideal['DelayGroup'] = delay
                entries.append(pd.DataFrame([new_ideal]))
            else:
                match = df_sub[df_sub['RefreshType'] == rtype]
                if not match.empty:
                    selected = match.sort_values(by='frontend_avg_bandwidth').iloc[[0]]
                    entries.append(selected)
                    # Capture bandwidths for improvement calc
                    if rtype == 'Auto Refresh':
                        bw_auto = selected['frontend_avg_bandwidth'].values[0]
                    elif rtype == 'WUPR':
                        bw_wupr = selected['frontend_avg_bandwidth'].values[0]

        if entries:
            group_df = pd.concat(entries, ignore_index=True)
            df_grouped.append(group_df)
            df_grouped.append(separator)

            # Calculate improvement if possible
            if bw_auto is not None and bw_wupr is not None and bw_auto != 0:
                improvement = (bw_wupr - bw_auto) / bw_auto * 100
                improvement_texts.append(f"Improvement: {improvement:.1f}%")
            else:
                improvement_texts.append("Improvement: N/A")

            # Calculate x-position for the group label (middle bar in group of 3)
            group_size = 3
            pos = i * (group_size + 1) + 1  # middle bar index in group
            improvement_positions.append(pos)

    # Combine everything
    df_sorted = pd.concat(df_grouped[:-1], ignore_index=True)  # remove last separator
    df_sorted['Color'] = df_sorted['RefreshType'].map(refresh_color).fillna('#ffffff')

    # Plotting
    plt.figure(figsize=(12, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    plt.bar(bar_positions, df_sorted['frontend_avg_bandwidth'], color=bar_colors)

    # Add text labels on bars
    for idx, val in enumerate(df_sorted['frontend_avg_bandwidth']):
        if pd.notna(val):
            plt.text(idx, val + 1, f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # Add improvement text closer to the top of the tallest bar in the group (less vertical offset)
    for pos, text in zip(improvement_positions, improvement_texts):
        group_vals = df_sorted['frontend_avg_bandwidth'][pos-1:pos+2]
        max_height = group_vals.max()
        text_y = max_height + max_height * 0.07  # ~7% above max bar height
        plt.text(pos, text_y, text, ha='center', va='bottom', fontsize=10, fontweight='bold', color='black')

    # Add horizontal line for 128 GB/s ideal bandwidth (no label line)
    plt.axhline(
        y=128,
        color='black',
        linestyle='--',
        linewidth=1.5,
    )
    # Add text label for ideal bandwidth near the right end of the line
    plt.text(
        x=len(df_sorted) - 0.5,
        y=128 + 3,
        s='Ideal Bandwidth (128 GB/s)',
        color='black',
        fontsize=10,
        ha='right',
        va='bottom'
    )

    # Adjust y-axis limit to ensure enough space for text and ideal line
    max_bandwidth = df_sorted['frontend_avg_bandwidth'].max()
    plt.ylim(0, max(max_bandwidth * 1.2, 140))  # At least 140 for clarity

    # X-axis centers per group
    group_size = 3
    centers = [i * (group_size + 1) + 1 for i in range(len(delay_groups))]

    # Replace delay groups with temperature labels
    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    plt.xticks(centers, temp_labels)

    # Legend (outside the plot area)
    legend_elements = [Patch(color=color, label=label) for label, color in refresh_color.items()]
    plt.legend(
        handles=legend_elements,
        title='Refresh Type',
        bbox_to_anchor=(1.02, 1),
        loc='upper left',
        borderaxespad=0.
    )

    # Final style
    plt.ylabel("Average Bandwidth (GB/s)")
    plt.title("Average Bandwidth Comparison Under Different Temperatures & Refresh Types")
    plt.grid(True, linestyle='--', alpha=0.5)

    # Adjust layout to make space for legend and improvement text
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
