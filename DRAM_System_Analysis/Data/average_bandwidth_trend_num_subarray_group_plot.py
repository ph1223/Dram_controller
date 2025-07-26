import json
import pandas as pd
import matplotlib.pyplot as plt
import re

# Load the JSON data into a DataFrame
def load_trace_summary(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    return pd.DataFrame(data)

# Extract Ndbl size (e.g., from "UCA1_Ndbl_32AR" → "32")
def extract_ndbl_size(name):
    match = re.search(r'_Ndbl_(\d+)', name)
    return match.group(1) if match else "unknown"

# Plot only Auto Refresh bandwidth trend with uniform gray color and value labels
def plot_auto_refresh_bandwidth(df):
    # Filter only Auto Refresh group
    df['Group'] = df['name'].apply(lambda x: 'Auto Refresh' if 'AR' in x else 'WUPR')
    df = df[df['Group'] == 'Auto Refresh'].copy()

    # Extract subarray size and filter out "32"
    df['Subarray'] = df['name'].apply(extract_ndbl_size)
    df = df[df['Subarray'] != "32"]

    # Convert Subarray to int for sorting
    df['Subarray_int'] = df['Subarray'].astype(int)
    df = df.sort_values(by='Subarray_int').reset_index(drop=True)

    # Plotting
    plt.figure(figsize=(12, 6))
    bar_positions = list(range(len(df)))
    bar_color = 'gray'  # Uniform gray bar color

    bars = plt.bar(
        bar_positions,
        df['frontend_avg_bandwidth'],
        color=bar_color,
        edgecolor='black'
    )

    # Add value labels above bars
    for idx, val in enumerate(df['frontend_avg_bandwidth']):
        if pd.notna(val):
            plt.text(
                idx,
                val + 1,
                f'{val:.2f}',
                ha='center',
                va='bottom',
                fontsize=9
            )

    # Ideal bandwidth line
    plt.axhline(
        y=128,
        color='black',
        linestyle='--',
        linewidth=1.5
    )
    plt.text(
        x=len(df) - 1,
        y=128 + 2,
        s='Upper Bound Bandwidth(128 GB/s) Partial LLM Access Workload',
        color='black',
        fontsize=10,
        ha='right'
    )

    # X-axis ticks with Subarray labels
    plt.xticks(
        bar_positions,
        [str(sub) for sub in df['Subarray_int']],
        rotation=45
    )
    plt.xlabel("Number of Subarrays Per Bank")
    plt.ylabel("Average Bandwidth (GB/s)")
    plt.title("Average Bandwidth Trend under Auto Refresh with Different Number of Subarrays per Bank")

    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout(rect=[0, 0, 0.85, 1])
    plt.show()

# Main
if __name__ == "__main__":
    json_file = 'subarray_analysis_trace_summary.json'
    df = load_trace_summary(json_file)
    plot_auto_refresh_bandwidth(df)
