import os
import re
import json
import math

log_dir = "scripts_design_space_exploration/3DDRAM_Design_Exploration/Logs"
output_json_path = "3d_dram_config_results.json"
T_cycle = 1  # in ns

def extract_config(filepath):
    with open(filepath, 'r') as file:
        content = file.read()

    key = os.path.basename(filepath).replace('.log', '')

    # Extract and round timing components
    timing_matches = re.findall(r"t_(\w+)\s+\(.*?\):\s+([\d\.]+)\s+ns", content)
    timing_rounded = {f"t_{name}": math.ceil(float(value) / T_cycle) for name, value in timing_matches}

    # Extract power components
    power_matches = re.findall(r"(\w+ energy):\s+([\d\.]+)\s+nJ", content)
    power = {name: float(value) for name, value in power_matches}

    return {
        "key": key,
        "cycle_time": T_cycle,
        "timing_rounded": timing_rounded,
        "power": power
    }

# Collect config data from all logs
all_results = []
for filename in os.listdir(log_dir):
    if filename.endswith(".log"):
        full_path = os.path.join(log_dir, filename)
        result = extract_config(full_path)
        all_results.append(result)

# Save to JSON
with open(output_json_path, 'w') as json_file:
    json.dump(all_results, json_file, indent=2)

print(f"Timing (rounded), power, and cycle time saved to {output_json_path}")
