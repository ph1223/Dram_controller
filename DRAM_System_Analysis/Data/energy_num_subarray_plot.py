import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.patches import Patch

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Ndbl size (e.g., from "UCA1_Ndbl_32AR" → 32)
def extract_ndbl_size(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) if match else None

# Split and plot total_energy (converted to μJ), grouped and color-coded by subarray count
def split_and_plot(df):
    # Add Group and Subarray columns
    df['Group'] = df['name'].apply(lambda x: 'Auto Refresh' if 'AR' in x else 'WUPR')
    df['Subarray'] = df['name'].apply(extract_ndbl_size)

    # Convert total_energy from pJ to μJ (1 μJ = 1e6 pJ)
    df['total_energy_uJ'] = df['total_energy'] / 1e6

    # Sort within each group by total_energy_uJ ascending
    group_ar = df[df['Group'] == 'Auto Refresh'].sort_values(by='total_energy_uJ').reset_index(drop=True)
    group_non_ar = df[df['Group'] == 'WUPR'].sort_values(by='total_energy_uJ').reset_index(drop=True)

    # Create separator row with NaN or empty string depending on dtype
    separator = pd.DataFrame([{col: (np.nan if df[col].dtype.kind in 'fiu' else '') for col in df.columns}])
    separator['Group'] = 'Separator'

    # Combine groups with separator in between
    df_sorted = pd.concat([group_ar, separator, group_non_ar], ignore_index=True)

    # Define custom color palette for Subarray counts
    custom_palette = {
        32: "#ce6a6b",
        64: "#8c564b",
        128: "#bed3c3",
        256: "#4a919e",
        512: "#212e53",
        1024: "#ebaca2"
    }

    # Map Subarray counts to colors; default white for unknown/missing
    df_sorted['Color'] = df_sorted['Subarray'].map(custom_palette).fillna('#ffffff')

    plt.figure(figsize=(14, 6))
    bar_positions = list(range(len(df_sorted)))
    bar_colors = df_sorted['Color'].tolist()

    # Plot bars of total_energy in μJ
    bars = plt.bar(bar_positions, df_sorted['total_energy_uJ'], color=bar_colors)

    # Add value labels above bars (skip NaN), formatted to 2 decimals
    for idx, val in enumerate(df_sorted['total_energy_uJ']):
        if pd.notna(val):
            plt.text(idx, val + 0.01, f'{val:.2f}', ha='center', va='bottom', fontsize=9)

    # X-axis ticks positioned at center of each group
    ar_center = len(group_ar) // 2
    wupr_center = len(group_ar) + 1 + len(group_non_ar) // 2
    plt.xticks([ar_center, wupr_center], ['Auto Refresh', 'WUPR'])

    # Create legend patches sorted by subarray count ascending
    legend_elements = [Patch(color=color, label=str(sub)) for sub, color in sorted(custom_palette.items())]
    plt.legend(handles=legend_elements, title='# of Subarrays')

    plt.ylabel("Total Energy (μJ)")
    plt.title("Total Energy (μJ): Auto Refresh & WUPR Trend under Different Number of Subarrays")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    split_and_plot(df)
