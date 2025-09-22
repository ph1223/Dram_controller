import os
import json
import re
from collections import defaultdict

def extract_refab_from_cmd(file_path):
    """Extract the REFab value from a .cmd file."""
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("REFab"):
                parts = line.strip().split(",")
                if len(parts) == 2:
                    return int(parts[1])
    return 0  # Return 0 if not found, so summing works

def process_cmd_files(cmd_dir, output_json='Temperature_refab_summary.json'):
    summary_dict = defaultdict(int)

    for filename in os.listdir(cmd_dir):
        if filename.endswith(".cmd"):
            name = os.path.splitext(filename)[0]

            # Remove trailing digits from file name (part index)
            base_match = re.match(r"(.+?)(\d+)?$", name)
            if base_match:
                base_name = base_match.group(1)
            else:
                base_name = name

            file_path = os.path.join(cmd_dir, filename)
            refab_value = extract_refab_from_cmd(file_path)
            summary_dict[base_name] += refab_value

    # Multiply final REFab by 4 (for 4 banks)
    summary = [{"name": k, "REFab": v * 4} for k, v in summary_dict.items()]

    # Write to JSON
    with open(output_json, 'w') as jsonfile:
        json.dump(summary, jsonfile, indent=4)

    # Print results for verification
    for row in summary:
        print(row)

# Example usage:
process_cmd_files('../cmd_records/')  # replace with your actual folder path
