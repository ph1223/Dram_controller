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
        'Auto Refresh': '#1f77b4',
        'WUPR': '#ff7f0e',
        'No Refresh': '#2ca02c'
    }

    df_grouped = []
    separator = pd.DataFrame([{'memory_system_cycles': np.nan, 'DelayGroup': 'Separator', 'RefreshType': '', 'name': ''}])

    speedup_texts = []
    speedup_positions = []

    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        entries = []
        cycle_auto = None
        cycle_wupr = None

        for rtype in refresh_order:
            if rtype == 'No Refresh':
                new_ideal = ideal_row.copy()
                new_ideal['DelayGroup'] = delay
                entries.append(pd.DataFrame([new_ideal]))
            else:
                match = df_sub[df_sub['RefreshType'] == rtype]
                if not match.empty:
                    selected = match.sort_values(by='memory_system_cycles').iloc[[0]]
                    entries.append(selected)
                    if rtype == 'Auto Refresh':
                        cycle_auto = selected['memory_system_cycles'].values[0]
                    elif rtype == 'WUPR':
                        cycle_wupr = selected['memory_system_cycles'].values[0]

        if entries:
            group_df = pd.concat(entries, ignore_index=True)
            df_grouped.append(group_df)
            df_grouped.append(separator)

            if cycle_auto is not None and cycle_wupr is not None and cycle_auto != 0:
                speedup = (cycle_auto - cycle_wupr) / cycle_auto * 100
                speedup_texts.append(f"Speedup: {speedup:.1f}%")
            else:
                speedup_texts.append("Speedup: N/A")

            pos = i * (3 + 1) + 1  # middle of 3-bar group
            speedup_positions.append(pos)

    df_sorted = pd.concat(df_grouped[:-1], ignore_index=True)
    df_sorted['Color'] = df_sorted['RefreshType'].map(refresh_color).fillna('#ffffff')

    # Convert cycles to millions
    df_sorted['memory_system_cycles_million'] = df_sorted['memory_system_cycles'] / 1e6

    # Plot
    plt.figure(figsize=(12, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    plt.bar(bar_positions, df_sorted['memory_system_cycles_million'], color=bar_colors)

    # Add bar values
    for idx, val in enumerate(df_sorted['memory_system_cycles_million']):
        if pd.notna(val):
            plt.text(idx, val + val * 0.01, f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # Add speedup % closer to bars
    for pos, text in zip(speedup_positions, speedup_texts):
        group_vals = df_sorted['memory_system_cycles_million'][pos - 1:pos + 2]
        max_height = group_vals.max()
        text_y = max_height + max_height * 0.07
        plt.text(pos, text_y, text, ha='center', va='bottom', fontsize=10, fontweight='bold')

    # Set Y-axis limit
    max_cycles = df_sorted['memory_system_cycles_million'].max()
    plt.ylim(0, max_cycles * 1.2)

    # X-axis labels
    group_size = 3
    centers = [i * (group_size + 1) + 1 for i in range(len(delay_groups))]
    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    plt.xticks(centers, temp_labels)

    # Legend
    legend_elements = [Patch(color=color, label=label) for label, color in refresh_color.items()]
    plt.legend(
        handles=legend_elements,
        title='Refresh Type',
        bbox_to_anchor=(1.02, 1),
        loc='upper left',
        borderaxespad=0.
    )

    # Titles and labels
    plt.ylabel("Simulation Cycles (Million)")
    plt.title("Simulation Cycles Comparison of Auto Refresh & WUPR Under Different Temperatures")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
