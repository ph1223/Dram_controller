import os
import re

def extract_values(log_file):
    with open(log_file, 'r') as file:
        content = file.read()

    # Extract specific timing values
    timing_values = {}
    timing_keys = [
        't_RCD (Row to column command delay)',
        't_RAS (Row access strobe latency)',
        't_RC (Row cycle)',
        't_CAS (Column access strobe latency)',
        't_RP (Row precharge latency)',
        't_RRD (Row activation to row activation delay)'
    ]

    for key in timing_keys:
        pattern = re.compile(rf'{re.escape(key)}:\s+([\d.]+)\s+ns')
        match = pattern.search(content)
        if match:
            timing_values[key] = float(match.group(1))

    # Extract specific power values
    power_values = {}
    power_keys = [
        'Activation energy',
        'Read energy',
        'Write energy',
        'Precharge energy'
    ]

    for key in power_keys:
        pattern = re.compile(rf'{re.escape(key)}:\s+([\d.]+)\s+nJ')
        match = pattern.search(content)
        if match:
            power_values[key] = float(match.group(1))

    # Extract specific area values
    area_values = {}
    area_keys = [
        'Area efficiency'
    ]

    for key in area_keys:
        pattern = re.compile(rf'{re.escape(key)}:\s+([\d.]+)%')
        match = pattern.search(content)
        if match:
            area_values[key] = float(match.group(1))

    # Extract specific TSV values
    tsv_values = {}
    tsv_keys = [
        'TSV latency overhead',
        'TSV energy overhead per access'
    ]

    for key in tsv_keys:
        pattern = re.compile(rf'{re.escape(key)}:\s+([\d.]+)\s+(ns|nJ)')
        match = pattern.search(content)
        if match:
            tsv_values[key] = float(match.group(1))

    return timing_values, power_values, area_values, tsv_values

def extract_all_logs(output_dir):
    log_files = [f for f in os.listdir(output_dir) if f.endswith('.log')]
    results = {}

    for log_file in log_files:
        log_path = os.path.join(output_dir, log_file)
        timing_values, power_values, area_values, tsv_values = extract_values(log_path)

        # Extract the last number from the log file name
        key = re.search(r'(\d+)(?=\.\w+$)', log_file).group(1)

        if key not in results:
            results[key] = []

        results[key].append({
            "log_file": log_file,
            "timing_values": timing_values,
            "power_values": power_values,
            "area_values": area_values,
            "tsv_values": tsv_values
        })

    return results

# Usage
output_dir = '3DDRAM_Design_Exploration/output'
results = extract_all_logs(output_dir)

frequency = 800

for key, logs in results.items():
    print(f"Key: {key}")

    for log in logs:
        print(f"Log File: {log['log_file']}")
        print("Timing Values:")
        for timing_key, value in log['timing_values'].items():

            # round up the time_in_tck to nearest integer
            time_in_tck = value*1000 / 1250
            time_in_tck = round(time_in_tck) if time_in_tck % 1 >= 0.5 else round(time_in_tck) + 1

            print(f"  {timing_key}: {time_in_tck} tCK")
        print("Power Values:")
        for power_key, value in log['power_values'].items():
            print(f"  {power_key}: {value} nJ")
        print("Area Values:")
        for area_key, value in log['area_values'].items():
            print(f"  {area_key}: {value} %")
        print("TSV Values:")
        for tsv_key, value in log['tsv_values'].items():
            print(f"  {tsv_key}: {value} ns" if 'latency' in tsv_key else f"  {tsv_key}: {value} nJ")
        print("\n" + "="*40 + "\n")
