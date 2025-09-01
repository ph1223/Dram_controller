import json
import pandas as pd
import matplotlib.pyplot as plt
import re
import numpy as np
from matplotlib.colors import LinearSegmentedColormap

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Subarray count from Ndbl (Subarray = Ndbl / 2)
def extract_subarray_count(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return int(match.group(1)) // 2 if match else None

# Plot total energy with custom purple→orange color map and tighter y-scaling
def plot_total_energy(df):
    # Extract and include all Subarray values
    df['Subarray'] = df['name'].apply(extract_subarray_count)
    df = df[df['Subarray'].notnull()].copy()

    # Convert to mJ
    df['total_energy_mJ'] = df['total_energy'] / 1e6

    # Sort by Subarray
    df = df.sort_values(by='Subarray').reset_index(drop=True)

    # --- Custom purple-to-orange colormap ---
    unique_subarrays = sorted(df['Subarray'].unique())
    cmap = LinearSegmentedColormap.from_list(
        "purple_yellow", ["#5e3c99", "#b2abd2", "#fdb863", "#e66101"], N=len(unique_subarrays)
    )
    color_dict = {sub: cmap(i) for i, sub in enumerate(unique_subarrays)}
    df['Color'] = df['Subarray'].map(color_dict)

    # Plot setup
    width = 0.5
    x = np.arange(len(df))

    plt.rcParams['figure.dpi'] = 200
    fig, ax = plt.subplots(figsize=(14, 8))

    bars = ax.bar(x, df['total_energy_mJ'], width=width,
                  color=df['Color'], edgecolor='black', linewidth=0.8)

    # Add value labels
    for xi, val in zip(x, df['total_energy_mJ']):
        if pd.notna(val):
            ax.text(xi, val * 1.01, f'{val:.3f}', ha='center', va='bottom', fontsize=10)

    # X-axis
    ax.set_xticks(x)
    ax.set_xticklabels([str(int(s)) for s in df['Subarray']], rotation=45)
    ax.set_xlabel("Number of Subarrays Per Bank", fontsize=12)

    # Y-axis with tighter scaling
    ymin = df['total_energy_mJ'].min()
    ymax = df['total_energy_mJ'].max()
    ax.set_ylim([ymin * 0.95, ymax * 1.05])
    ax.set_ylabel("Total Energy (mJ)", fontsize=12)

    ax.set_title("Total Energy with Different Number of Subarrays per Bank", fontsize=14)
    ax.grid(True, linestyle='--', alpha=0.5, axis='y')
    ax.margins(x=0.02)

    plt.tight_layout(pad=2.0)
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_total_energy(df)
