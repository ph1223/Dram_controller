import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.patches import Patch

# Load data
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract delay and refresh types
def extract_delay_group(name):
    match = re.match(r'^(8ms|16ms|32ms)', name)
    return match.group(1) if match else 'Unknown'

def extract_refresh_type(name):
    if 'ideal' in name:
        return 'No Refresh'
    elif 'With_WUPR' in name:
        return 'WUPR'
    elif 'Without_WUPR' in name:
        return 'Auto Refresh'
    else:
        return 'Unknown'

# Combined plot
def combined_plot(df):
    df['DelayGroup'] = df['name'].apply(extract_delay_group)
    df['RefreshType'] = df['name'].apply(extract_refresh_type)

    delay_groups = ['32ms', '16ms', '8ms']
    temp_labels  = ['<85°C', '85°C~95°C', '>95°C']
    refresh_order = ['Auto Refresh', 'WUPR', 'No Refresh']
    refresh_color = {
        'Auto Refresh': '#D3D3D3',
        'WUPR':         '#6A1B9A',
        'No Refresh':   '#C04B00'
    }

    # get the 'ideal' (no-refresh) baseline row
    ideal_row = df[df['RefreshType'] == 'No Refresh']
    if ideal_row.empty:
        print("No 'ideal' data point found.")
        return
    ideal_row = ideal_row.iloc[0]

    metrics = [
        ("frontend_avg_bandwidth", "Average Bandwidth (GB/s)",   "Improvement",   lambda x, y: (x - y) / y * 100, 128),
        ("memory_system_cycles",   "Simulation Cycles (Million)", "Speedup",       lambda x, y: (x - y) / x * 100, None),
        ("total_energy",           "Total Energy (mJ)",          "Energy Saving", lambda x, y: (x - y) / x * 100, None)
    ]

    fig, axes = plt.subplots(nrows=3, ncols=1, figsize=(12, 14), sharex=True)
    plt.subplots_adjust(hspace=0.4)

    for ax, (key, ylabel, label, calc_func, ideal_line) in zip(axes, metrics):
        df_grouped  = []
        separator   = pd.DataFrame([{key: np.nan, 'DelayGroup': 'Separator', 'RefreshType': '', 'name': ''}])
        annotations = []
        positions   = []

        for i, delay in enumerate(delay_groups):
            df_sub = df[df['DelayGroup'] == delay]
            entries = []
            val_auto = val_wupr = None

            for rtype in refresh_order:
                if rtype == 'No Refresh':
                    new_ideal = ideal_row.copy()
                    new_ideal['DelayGroup'] = delay
                    entries.append(pd.DataFrame([new_ideal]))
                else:
                    match = df_sub[df_sub['RefreshType'] == rtype]
                    if not match.empty:
                        sel = match.sort_values(by=key).iloc[[0]]
                        entries.append(sel)
                        if rtype == 'Auto Refresh':
                            val_auto = sel[key].values[0]
                        elif rtype == 'WUPR':
                            val_wupr = sel[key].values[0]

            if entries:
                group_df = pd.concat(entries, ignore_index=True)
                df_grouped.append(group_df)
                df_grouped.append(separator)

                if val_auto is not None and val_wupr is not None and val_auto != 0:
                    pct = calc_func(val_auto, val_wupr)
                    annotations.append(f"{label}: {abs(pct):.2f}%")
                else:
                    annotations.append("")
                positions.append(i * (len(refresh_order) + 1) + 1)

        df_sorted = pd.concat(df_grouped[:-1], ignore_index=True)
        df_sorted['Color'] = df_sorted['RefreshType'].map(refresh_color).fillna('#ffffff')

        # Convert plotting values
        if key == 'memory_system_cycles':
            df_sorted['PlotVal'] = df_sorted[key] / 1e6
        elif key == 'total_energy':
            df_sorted['PlotVal'] = df_sorted[key] / 1e6
        else:
            df_sorted['PlotVal'] = df_sorted[key]

        bar_positions = list(range(len(df_sorted)))
        bar_colors    = df_sorted['Color'].tolist()

        ax.bar(bar_positions, df_sorted['PlotVal'], color=bar_colors,
               edgecolor='black', linewidth=1.2)

        # Value labels
        for idx, v in enumerate(df_sorted['PlotVal']):
            if pd.notna(v):
                ax.text(idx, v + v * 0.01, f'{v:.2f}', ha='center', va='bottom', fontsize=9)

        # Annotation positions & text
        group_ys = []
        for pos in positions:
            grp = df_sorted['PlotVal'][pos-1:pos+2]
            max_h = grp.max()
            group_ys.append(max_h + max_h * 0.05)

        for pos, txt, y in zip(positions, annotations, group_ys):
            if txt:
                ax.text(pos, y, txt, ha='center', va='bottom', fontsize=10, fontweight='bold')

        # Optional ideal line (only for bandwidth plot)
        if ideal_line is not None:
            ax.axhline(y=ideal_line, color='black', linestyle='--', linewidth=1.5)
            ax.text(len(df_sorted) - 0.5, ideal_line + ideal_line*0.05,
                    f'Upper Bound Bandwidth for Partial LLM Workload ({ideal_line} GB/s)',
                    color='black', fontsize=12, ha='right', va='bottom')

        ax.set_ylabel(ylabel)
        ax.grid(True, linestyle='--', alpha=0.5)

    # X‑axis: apply group labels to all subplots
    group_size = len(refresh_order)  # 3 bars per temperature group
    spacing    = 1
    centers    = [(group_size + spacing) * i + 1 for i in range(len(delay_groups))]

    for ax in axes:
        ax.set_xticks(centers)
        ax.set_xticklabels(temp_labels)
        ax.tick_params(axis='x', which='both', labelbottom=True)
    axes[-1].set_xlabel("Temperature Range")

    # Shared legend
    legend_elements = [Patch(color=color, label=label)
                       for label, color in refresh_color.items()]
    axes[0].legend(handles=legend_elements,
                   title='Refresh Type',
                   bbox_to_anchor=(1.02, 1), loc='upper left')

    plt.suptitle("Comparison of Bandwidth, Simulation Cycles, and Energy Across Temperatures & Refresh Types",
                 fontsize=14, fontweight='bold')
    plt.tight_layout(rect=[0, 0, 0.85, 0.95])
    plt.show()


# Main
if __name__ == "__main__":
    json_file = 'Temperature_analysis_trace_summary.json'
    df        = load_trace_summary(json_file)
    combined_plot(df)
