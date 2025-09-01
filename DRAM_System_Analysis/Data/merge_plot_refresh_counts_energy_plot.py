import json
import pandas as pd
import matplotlib.pyplot as plt
import re
from matplotlib.patches import Patch

# Load JSON data
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract delay group (temperature category)
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

# Plot combined REFab and Energy in one plot
def plot_combined_refresh_metrics(df_energy, df_refab):
    df_energy['DelayGroup'] = df_energy['name'].apply(extract_delay_group)
    df_energy['RefreshType'] = df_energy['name'].apply(extract_refresh_type)

    df_refab['DelayGroup'] = df_refab['name'].apply(extract_delay_group)
    df_refab['RefreshType'] = df_refab['name'].apply(extract_refresh_type)

    delay_groups = ['32ms', '16ms', '8ms']
    temp_labels = ['<85°C', '85°C~95°C', '>95°C']
    refresh_order = ['Auto Refresh', 'WUPR']

    refresh_color_top = {
        'Auto Refresh': '#D3D3D3',
        'WUPR': '#6A1B9A'
    }
    energy_segment_colors = {
        'Base': '#D3D3D3',
        'WUPR_overhead': '#6A1B9A'
    }

    group_size = len(refresh_order)
    spacing = 1
    positions = {}
    centers = []
    refab_entries, energy_entries = [], []
    refab_arrows, energy_arrows = [], []

    for i, delay in enumerate(delay_groups):
        refab_sub = df_refab[df_refab['DelayGroup'] == delay]
        energy_sub = df_energy[df_energy['DelayGroup'] == delay]

        refab_auto = refab_wupr = None
        energy_auto = energy_wupr = None

        for j, rtype in enumerate(refresh_order):
            pos = i * (group_size + spacing) + j
            positions[(delay, rtype)] = pos

            # --- REFab ---
            match_r = refab_sub[refab_sub['RefreshType'] == rtype]
            if not match_r.empty:
                val = match_r.sort_values(by='REFab').iloc[0]['REFab']
                refab_entries.append({
                    'DelayGroup': delay,
                    'RefreshType': rtype,
                    'Value': val,
                    'Position': pos,
                    'Color': refresh_color_top[rtype]
                })
                if rtype == 'Auto Refresh':
                    refab_auto = val
                else:
                    refab_wupr = val

            # --- Energy ---
            match_e = energy_sub[energy_sub['RefreshType'] == rtype]
            if not match_e.empty:
                sel = match_e.sort_values(by='total_refresh_energy').iloc[0]
                base_mJ = sel['total_refresh_energy'] / 1e6
                wupr_mJ = (sel.get('total_wupr_energy', 0) or 0) / 1e6

                if rtype == 'WUPR':
                    total_mJ = base_mJ + wupr_mJ
                    wupr_pct = (wupr_mJ / total_mJ * 100) if total_mJ > 0 else None
                else:
                    total_mJ = base_mJ
                    wupr_pct = None

                energy_entries.append({
                    'DelayGroup': delay,
                    'RefreshType': rtype,
                    'Position': pos,
                    'base_mJ': base_mJ,
                    'wupr_mJ': wupr_mJ,
                    'total_mJ': total_mJ,
                    'WUPR_pct': wupr_pct
                })

                if rtype == 'Auto Refresh':
                    energy_auto = total_mJ
                else:
                    energy_wupr = total_mJ

        centers.append(i * (group_size + spacing) + (group_size - 1) / 2.0)

        if refab_auto is not None and refab_wupr is not None and refab_wupr > 0:
            mult = refab_auto / refab_wupr
            refab_arrows.append({
                'x': centers[-1],
                'y1': max(refab_auto, refab_wupr),
                'y2': min(refab_auto, refab_wupr),
                'multiple': mult
            })

        if energy_auto is not None and energy_wupr is not None and energy_wupr > 0:
            mult = energy_auto / energy_wupr
            if mult >= 1.0:
                energy_arrows.append({
                    'x': centers[-1],
                    'y1': max(energy_auto, energy_wupr),
                    'y2': min(energy_auto, energy_wupr),
                    'multiple': mult
                })

    refab_df  = pd.DataFrame(refab_entries)
    energy_df = pd.DataFrame(energy_entries)

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(20,14), sharex=True)

    # --- Plot 1: REFab ---
    ax1.bar(refab_df['Position'], refab_df['Value'],
            color=refab_df['Color'], edgecolor='black', linewidth=1.2)
    for _, row in refab_df.iterrows():
        ax1.text(row['Position'], row['Value'] + max(row['Value'] * 0.01, 10),
                 f'{int(row["Value"])}', ha='center', va='bottom', fontsize=14)  # Increased fontsize

    for arrow in refab_arrows:
        ax1.annotate('', xy=(arrow['x'], arrow['y2']), xytext=(arrow['x'], arrow['y1']),
                     arrowprops=dict(arrowstyle='<->', color='#A020F0', lw=3))  # Increased line width
        ax1.text(arrow['x'] + 0.25, (arrow['y1'] + arrow['y2']) / 2 + 10,
                 f'x{arrow["multiple"]:.2f}', fontsize=18, color='#A020F0', fontweight='bold')  # Increased fontsize

    ax1.set_ylabel("Number of Refresh Counts", fontsize=16)  # Increased fontsize
    ax1.set_title("WUPR vs Auto Refresh Scheme Refresh Counts & Refresh Energy Under Different Temperature", fontsize=20)
    ax1.grid(False)  # Remove grid

    # --- Plot 2: Energy ---
    for _, row in energy_df.iterrows():
        x     = row['Position']
        base  = row['base_mJ']
        wupr  = row['wupr_mJ']
        total = row['total_mJ']

        if row['RefreshType'] == 'Auto Refresh':
            ax2.bar(x, base,
                    color=energy_segment_colors['Base'],
                    edgecolor='black', linewidth=1.2)
        else:
            ax2.bar(x, base,
                    color=energy_segment_colors['Base'],
                    edgecolor='black', linewidth=1.2, hatch='////', alpha=0.9)
            if wupr > 0:
                ax2.bar(x, wupr, bottom=base,
                        color=energy_segment_colors['WUPR_overhead'],
                        edgecolor='black', linewidth=1.2)

        ax2.text(x, total + max(total * 0.01, 0.0005),
                 f'{total:.4f}', ha='center', va='bottom', fontsize=14)  # Increased fontsize

        if row['RefreshType'] == 'WUPR' and row['WUPR_pct'] is not None and wupr > 0:
            ax2.text(
                x + 0.45,
                base + wupr / 2,
                f'WUPR\n{wupr:.4f} mJ\n({row["WUPR_pct"]:.1f}%)',
                ha='left', va='center', fontsize=16,  # Increased fontsize
                fontstyle='italic', color=energy_segment_colors['WUPR_overhead']
            )

    for i, arrow in enumerate(energy_arrows):
        ax2.annotate('', xy=(arrow['x'], arrow['y2']), xytext=(arrow['x'], arrow['y1']),
                     arrowprops=dict(arrowstyle='<->', color='#A020F0', lw=3))  # Increased line width
        y_offset = 0.12 if i == 0 else 0.001
        ax2.text(arrow['x'] + 0.25,
                 (arrow['y1'] + arrow['y2']) / 2 + y_offset,
                 f'x{arrow["multiple"]:.2f}', fontsize=18, color='#A020F0', fontweight='bold')  # Increased fontsize

    ax2.set_ylabel("Total Refresh Energy (mJ)", fontsize=16)  # Increased fontsize
    ax2.grid(False)  # Remove grid

    # --- Apply temperature group ticks & labels on both subplots ---
    for ax in (ax1, ax2):
        ax.set_xticks(centers)
        ax.set_xticklabels(temp_labels, fontsize=16)  # Increased fontsize
        ax.tick_params(axis='x', which='both', labelbottom=True)
    ax2.set_xlabel("Temperature Range", fontsize=18)  # Increased fontsize

    # Legends
    legend_top = [Patch(color=color, label=label) for label, color in refresh_color_top.items()]
    ax1.legend(handles=legend_top, title='Refresh Type', fontsize=14, title_fontsize=16,
               bbox_to_anchor=(1.02, 1), loc='upper left')

    auto_handle = Patch(facecolor=energy_segment_colors['Base'], edgecolor='black', label='Auto Refresh')
    wupr_base_handle = Patch(facecolor=energy_segment_colors['Base'], edgecolor='black',
                             hatch='////', label='WUPR Base (excluding overhead)')
    wupr_overhead_handle = Patch(facecolor=energy_segment_colors['WUPR_overhead'], edgecolor='black',
                                 label='WUPR Overhead')
    ax2.legend(handles=[auto_handle, wupr_base_handle, wupr_overhead_handle],
               title='Energy Bars', fontsize=14, title_fontsize=16,
               bbox_to_anchor=(1.02, 1), loc='upper left')

    plt.tight_layout(rect=[0, 0, 0.85, 0.96])
    plt.show()

# Main
if __name__ == "__main__":
    df_energy = load_trace_summary('Temperature_analysis_trace_summary.json')
    df_refab  = load_trace_summary('Temperature_refab_summary.json')
    plot_combined_refresh_metrics(df_energy, df_refab)
