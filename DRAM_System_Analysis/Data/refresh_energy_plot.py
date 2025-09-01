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

# Plotting energy bars + multiple arrows
def split_and_plot(df):
    df['DelayGroup'] = df['name'].apply(extract_delay_group)
    df['RefreshType'] = df['name'].apply(extract_refresh_type)

    delay_groups = ['32ms', '16ms', '8ms']
    refresh_order = ['Auto Refresh', 'WUPR']
    refresh_color = {
        'Base': '#D3D3D3',
        'WUPR_overhead': '#6A1B9A'
    }

    df_plot = []
    arrows = []
    centers = []

    group_size = 2
    spacing = 1

    for i, delay in enumerate(delay_groups):
        df_sub = df[df['DelayGroup'] == delay]

        auto_total, wupr_total = None, None
        entries = []

        for j, rtype in enumerate(refresh_order):
            match = df_sub[df_sub['RefreshType'] == rtype]
            if not match.empty:
                selected = match.sort_values(by='total_refresh_energy').iloc[0]

                base_energy_mJ = selected['total_refresh_energy'] / 1e6
                wupr_energy_mJ = (selected.get('total_wupr_energy', 0) or 0) / 1e6

                if rtype == 'WUPR':
                    total_energy_mJ = base_energy_mJ + wupr_energy_mJ
                    wupr_percentage = (wupr_energy_mJ / total_energy_mJ * 100) if total_energy_mJ > 0 else None
                else:
                    total_energy_mJ = base_energy_mJ
                    wupr_percentage = None

                pos = i * (group_size + spacing) + j
                entries.append({
                    'total_energy_mJ': total_energy_mJ,
                    'base_energy_mJ': base_energy_mJ,
                    'wupr_energy_mJ': wupr_energy_mJ,
                    'WUPR_percentage': wupr_percentage,
                    'RefreshType': rtype,
                    'Position': pos
                })

                if rtype == 'Auto Refresh':
                    auto_total = total_energy_mJ
                elif rtype == 'WUPR':
                    wupr_total = total_energy_mJ

        if entries:
            df_plot.extend(entries)
            center_x = i * (group_size + spacing) + 0.5
            centers.append(center_x)

            if auto_total is not None and wupr_total is not None and wupr_total > 0:
                multiple = auto_total / wupr_total
                # Only keep arrows if WUPR provides benefit (multiple >= 1.0)
                if multiple >= 1.0:
                    y_top = max(auto_total, wupr_total)
                    y_bot = min(auto_total, wupr_total)
                    arrows.append({
                        'x': center_x,
                        'y1': y_top,
                        'y2': y_bot,
                        'multiple': multiple
                    })

    plot_df = pd.DataFrame(df_plot)

    # Plot
    plt.figure(figsize=(18, 16))

    for idx, row in plot_df.iterrows():
        x_pos = row['Position']
        total_energy = row['total_energy_mJ']
        base_energy = row['base_energy_mJ']
        wupr_energy = row['wupr_energy_mJ']

        if row['RefreshType'] == 'WUPR':
            plt.bar(
                x_pos,
                base_energy,
                color=refresh_color['Base'],
                edgecolor='black',
                linewidth=1.2
            )
            plt.bar(
                x_pos,
                wupr_energy,
                bottom=base_energy,
                color=refresh_color['WUPR_overhead'],
                edgecolor='black',
                linewidth=1.2
            )
        else:
            plt.bar(
                x_pos,
                base_energy,
                color=refresh_color['Base'],
                edgecolor='black',
                linewidth=1.2
            )

        plt.text(
            x_pos,
            total_energy + max(total_energy * 0.01, 0.0005),
            f'{total_energy:.4f}',
            ha='center',
            va='bottom',
            fontsize=9
        )

        if row['RefreshType'] == 'WUPR' and row['WUPR_percentage'] is not None and wupr_energy > 0:
            plt.text(
                x_pos + 0.45,
                base_energy + wupr_energy / 2,
                f'WUPR\n{wupr_energy:.4f} mJ\n({row["WUPR_percentage"]:.1f}%)',
                ha='left',
                va='center',
                fontsize=11,
                fontstyle='italic',
                color=refresh_color['WUPR_overhead']
            )

    # Arrows + multiplicative text
    for arrow in arrows:
        x = arrow['x']
        y1, y2 = arrow['y1'], arrow['y2']
        y_mid = (y1 + y2) / 2
        multiple_str = f'x{arrow["multiple"]:.2f}'

        plt.annotate(
            '',
            xy=(x, y2),
            xytext=(x, y1),
            arrowprops=dict(arrowstyle='<->', color='#A020F0', lw=2)
        )
        plt.text(
            x + 0.25,
            y_mid + max((y1 - y2) * 0.05, 0.0008),
            multiple_str,
            ha='left',
            va='bottom',
            fontsize=25,
            fontweight='bold',
            color='#A020F0'
        )

    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    plt.xticks(centers, temp_labels)

    max_energy = plot_df['total_energy_mJ'].max()
    plt.ylim(0, max_energy * 1.4)

    legend_elements = [
        Patch(color=refresh_color['Base'], label='Base Refresh Energy'),
        Patch(color=refresh_color['WUPR_overhead'], label='WUPR Overhead')
    ]
    plt.legend(
        handles=legend_elements,
        title='Bar Segments',
        bbox_to_anchor=(1.02, 1),
        loc='upper left',
        borderaxespad=0.
    )

    plt.ylabel("Total Refresh Energy (mJ)")
    plt.title("Total Refresh Energy (Including WUPR) & Multiples by Temperature and Strategy")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
