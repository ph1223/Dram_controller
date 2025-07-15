import os
import json
import re

def extract_refab_from_cmd(file_path):
    """Extract the REFab value from a .cmd file."""
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("REFab"):
                parts = line.strip().split(",")
                if len(parts) == 2:
                    return int(parts[1])
    return None

def process_cmd_files(cmd_dir, output_json='Temperature_refab_summary.json'):
    summary = []

    for filename in os.listdir(cmd_dir):
        if filename.endswith(".cmd"):
            name = os.path.splitext(filename)[0]
            file_path = os.path.join(cmd_dir, filename)
            refab_value = extract_refab_from_cmd(file_path)
            if refab_value is not None:
                summary.append({"name": name, "REFab": refab_value})

    # Write to JSON
    with open(output_json, 'w') as jsonfile:
        json.dump(summary, jsonfile, indent=4)

    # Print results for verification
    for row in summary:
        print(row)

# Example usage:
process_cmd_files('../traces_log/')  # replace with your actual folder path
