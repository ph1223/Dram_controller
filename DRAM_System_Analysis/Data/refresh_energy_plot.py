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
    df['DelayGroup'] = df['name'].apply(extract_delay_group)
    df['RefreshType'] = df['name'].apply(extract_refresh_type)

    # Extract ideal row for 'No Refresh'
    ideal_row = df[df['RefreshType'] == 'No Refresh']
    if ideal_row.empty:
        print("No 'ideal' data point found.")
        return
    else:
        ideal_row = ideal_row.iloc[0]

    # Define groups and order
    delay_groups = ['32ms', '16ms', '8ms']
    refresh_order = ['Auto Refresh', 'WUPR', 'No Refresh']
    refresh_color = {
        'Auto Refresh': '#1f77b4',
        'WUPR': '#ff7f0e',
        'No Refresh': '#2ca02c'
    }

    df_grouped = []
    separator = pd.DataFrame([{'total_refresh_energy': np.nan, 'DelayGroup': 'Separator', 'RefreshType': '', 'name': ''}])
    saving_texts = []
    saving_positions = []

    # Build groups including the No Refresh row cloned per delay group
    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        entries = []
        energy_auto = None
        energy_wupr = None

        for rtype in refresh_order:
            if rtype == 'No Refresh':
                # Clone ideal row but assign current delay group for label consistency
                new_ideal = ideal_row.copy()
                new_ideal['DelayGroup'] = delay
                entries.append(pd.DataFrame([new_ideal]))
            else:
                match = df_sub[df_sub['RefreshType'] == rtype]
                if not match.empty:
                    selected = match.sort_values(by='total_refresh_energy').iloc[[0]]
                    entries.append(selected)
                    if rtype == 'Auto Refresh':
                        energy_auto = selected['total_refresh_energy'].values[0]
                    elif rtype == 'WUPR':
                        energy_wupr = selected['total_refresh_energy'].values[0]

        if entries:
            group_df = pd.concat(entries, ignore_index=True)
            df_grouped.append(group_df)
            df_grouped.append(separator)

            if energy_auto is not None and energy_wupr is not None and energy_auto != 0:
                saving = (energy_auto - energy_wupr) / energy_auto * 100
                saving_texts.append(f"Energy Saving: {saving:.1f}%")
            else:
                saving_texts.append("Energy Saving: N/A")

            pos = i * (3 + 1) + 1  # middle bar in group of 3
            saving_positions.append(pos)

    # Concatenate all groups into one DataFrame
    df_sorted = pd.concat(df_grouped[:-1], ignore_index=True)
    df_sorted['Color'] = df_sorted['RefreshType'].map(refresh_color).fillna('#ffffff')
    df_sorted['total_refresh_energy_uJ'] = df_sorted['total_refresh_energy'] / 1e6  # pJ to μJ

    # Remove No Refresh from plotting
    df_plot = df_sorted[df_sorted['RefreshType'] != 'No Refresh'].reset_index(drop=True)

    # Plotting
    plt.figure(figsize=(12, 6))
    bar_positions = list(range(len(df_plot)))
    bar_colors = df_plot['Color'].tolist()

    plt.bar(bar_positions, df_plot['total_refresh_energy_uJ'], color=bar_colors)

    # Add value labels above bars
    for idx, val in enumerate(df_plot['total_refresh_energy_uJ']):
        if pd.notna(val):
            plt.text(idx, val + max(val * 0.01, 0.05), f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # Calculate new group centers for 2 bars + spacing
    group_size = 2  # Auto Refresh + WUPR only plotted
    spacing = 1
    centers = [(group_size + spacing) * i + (group_size / 2 - 0.5) for i in range(len(delay_groups))]

    # Add Energy Saving texts above groups with increased vertical offset
    for pos, text in zip(centers, saving_texts):
        left_idx = int(pos - (group_size / 2 - 0.5))
        right_idx = left_idx + group_size
        group_vals = df_plot['total_refresh_energy_uJ'][left_idx:right_idx]
        max_height = group_vals.max()
        # Increased vertical offset here:
        text_y = max_height + 0.15 + max(max_height * 0.13, 0.15)
        plt.text(pos, text_y, text, ha='center', va='bottom', fontsize=10, fontweight='bold')

    # Y-axis limit
    max_energy = df_plot['total_refresh_energy_uJ'].max()
    plt.ylim(0, max_energy * 1.2)

    # X-axis tick labels for temperature ranges
    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    plt.xticks(centers, temp_labels)

    # Legend without No Refresh
    legend_elements = [Patch(color=refresh_color[label], label=label) for label in ['Auto Refresh', 'WUPR']]
    plt.legend(
        handles=legend_elements,
        title='Refresh Type',
        bbox_to_anchor=(1.02, 1),
        loc='upper left',
        borderaxespad=0.
    )

    # Labels and title
    plt.ylabel("Total Refresh Energy (μJ)")
    plt.title("Total Refresh Energy Comparison under Different Temperature Ranges and Refresh Types")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
