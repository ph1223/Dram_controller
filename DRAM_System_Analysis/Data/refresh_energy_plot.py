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

# Extract delay group
def extract_delay_group(name):
    match = re.match(r'^(8ms|16ms|32ms)', name)
    return match.group(1) if match else 'Unknown'

# Extract refresh type
def extract_refresh_type(name):
    if 'ideal' in name:
        return 'No Refresh'
    elif 'With_WUPR' in name:
        return 'WUPR'
    elif 'Without_WUPR' in name:
        return 'Auto Refresh'
    else:
        return 'Unknown'

# Plotting energy bars + reduction arrows
def split_and_plot(df):
    df['DelayGroup'] = df['name'].apply(extract_delay_group)
    df['RefreshType'] = df['name'].apply(extract_refresh_type)

    delay_groups = ['32ms', '16ms', '8ms']
    refresh_order = ['Auto Refresh', 'WUPR']
    refresh_color = {
        'Auto Refresh': '#D3D3D3',
        'WUPR': '#6A1B9A'
    }

    df_plot = []
    arrows = []
    centers = []

    group_size = 2
    spacing = 1

    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        auto_val, wupr_val = None, None
        entries = []

        for j, rtype in enumerate(refresh_order):
            match = df_sub[df_sub['RefreshType'] == rtype]
            if not match.empty:
                selected = match.sort_values(by='total_refresh_energy').iloc[0]
                val = selected['total_refresh_energy'] / 1e6  # convert to mJ
                pos = i * (group_size + spacing) + j
                entries.append({
                    'total_refresh_energy_mJ': val,
                    'RefreshType': rtype,
                    'Color': refresh_color[rtype],
                    'Position': pos
                })
                if rtype == 'Auto Refresh':
                    auto_val = val
                elif rtype == 'WUPR':
                    wupr_val = val

        if entries:
            df_plot.extend(entries)
            center_x = i * (group_size + spacing) + 0.5
            centers.append(center_x)

            if auto_val is not None and wupr_val is not None and auto_val != 0:
                y_top = max(auto_val, wupr_val)
                y_bot = min(auto_val, wupr_val)
                reduction = (auto_val - wupr_val) / auto_val * 100
                arrows.append({
                    'x': center_x,
                    'y1': y_top,
                    'y2': y_bot,
                    'percent': reduction
                })

    plot_df = pd.DataFrame(df_plot)

    # Plot
    plt.figure(figsize=(12, 6))
    plt.bar(
        plot_df['Position'],
        plot_df['total_refresh_energy_mJ'],
        color=plot_df['Color'],
        edgecolor='black',
        linewidth=1.2
    )

    # Bar value labels
    for _, row in plot_df.iterrows():
        val = row['total_refresh_energy_mJ']
        plt.text(
            row['Position'],
            val + max(val * 0.01, 0.0005),
            f'{val:.4f}',
            ha='center',
            va='bottom',
            fontsize=9
        )

    # Arrows + percentage text
    for arrow in arrows:
        x = arrow['x']
        y1, y2 = arrow['y1'], arrow['y2']
        y_mid = (y1 + y2) / 2
        reduction_str = f'{arrow["percent"]:.1f}%'

        # Arrow
        plt.annotate(
            '',
            xy=(x, y2),
            xytext=(x, y1),
            arrowprops=dict(arrowstyle='<->', color='#A020F0', lw=2)
        )

        # Side label (right of arrow)
        text_x = x + 0.25
        text_y = y_mid + max((y1 - y2) * 0.05, 0.0008)
        plt.text(
            text_x, text_y,
            f'Reduction\n{reduction_str}',
            ha='left',
            va='bottom',
            fontsize=9,
            fontweight='bold',
            color='#A020F0'
        )

    # X-axis label centers
    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    plt.xticks(centers, temp_labels)

    # Y limit
    max_energy = plot_df['total_refresh_energy_mJ'].max()
    plt.ylim(0, max_energy * 1.4)

    # Legend
    legend_elements = [Patch(color=refresh_color[label], label=label) for label in refresh_order]
    plt.legend(
        handles=legend_elements,
        title='Refresh Type',
        bbox_to_anchor=(1.02, 1),
        loc='upper left',
        borderaxespad=0.
    )

    plt.ylabel("Total Refresh Energy (mJ)")
    plt.title("Total Refresh Energy & Reduction by Temperature and Strategy")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
