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

    # Extract ideal row
    ideal_row = df[df['RefreshType'] == 'No Refresh']
    if not ideal_row.empty:
        ideal_row = ideal_row.iloc[0]
    else:
        print("No 'ideal' data point found.")
        return

    delay_groups = ['32ms', '16ms', '8ms']
    refresh_order = ['Auto Refresh', 'WUPR', 'No Refresh']
    refresh_color = {
        'Auto Refresh': '#1f77b4',
        'WUPR': '#ff7f0e',
        'No Refresh': '#2ca02c'
    }

    df_grouped = []
    separator = pd.DataFrame([{'total_energy': np.nan, 'DelayGroup': 'Separator', 'RefreshType': '', 'name': ''}])
    saving_texts = []
    saving_positions = []

    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        entries = []
        energy_auto = None
        energy_wupr = None

        for rtype in refresh_order:
            if rtype == 'No Refresh':
                new_ideal = ideal_row.copy()
                new_ideal['DelayGroup'] = delay
                entries.append(pd.DataFrame([new_ideal]))
            else:
                match = df_sub[df_sub['RefreshType'] == rtype]
                if not match.empty:
                    selected = match.sort_values(by='total_energy').iloc[[0]]
                    entries.append(selected)
                    if rtype == 'Auto Refresh':
                        energy_auto = selected['total_energy'].values[0]
                    elif rtype == 'WUPR':
                        energy_wupr = selected['total_energy'].values[0]

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

    df_sorted = pd.concat(df_grouped[:-1], ignore_index=True)
    df_sorted['Color'] = df_sorted['RefreshType'].map(refresh_color).fillna('#ffffff')
    df_sorted['total_energy_uJ'] = df_sorted['total_energy'] / 1e6  # Convert to μJ

    # Plotting
    plt.figure(figsize=(12, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    plt.bar(bar_positions, df_sorted['total_energy_uJ'], color=bar_colors)

    # Add bar values
    for idx, val in enumerate(df_sorted['total_energy_uJ']):
        if pd.notna(val):
            plt.text(idx, val + val * 0.01, f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # Add energy saving % text
    for pos, text in zip(saving_positions, saving_texts):
        group_vals = df_sorted['total_energy_uJ'][pos - 1:pos + 2]
        max_height = group_vals.max()
        text_y = max_height + max_height * 0.07
        plt.text(pos, text_y, text, ha='center', va='bottom', fontsize=10, fontweight='bold')

    # Set Y-axis limit
    max_energy = df_sorted['total_energy_uJ'].max()
    plt.ylim(0, max_energy * 1.2)

    # X-axis label alignment (center of each 3-bar group)
    group_size = 3
    spacing = 1
    centers = [(group_size + spacing) * i + 1 for i in range(len(delay_groups))]
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

    # Labels and title
    plt.ylabel("Total Energy (μJ)")
    plt.title("Total Energy Comparison by Temperature Range and Refresh Type")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
