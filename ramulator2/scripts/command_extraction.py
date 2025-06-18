import os
import csv
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

def process_cmd_files(cmd_dir, output_csv='refab_summary.csv'):
    summary = []

    for filename in os.listdir(cmd_dir):
        if filename.endswith(".cmd"):
            name = os.path.splitext(filename)[0]
            file_path = os.path.join(cmd_dir, filename)
            refab_value = extract_refab_from_cmd(file_path)
            if refab_value is not None:
                summary.append({"name": name, "REFab": refab_value})

    # Write to CSV
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=["name", "REFab"])
        writer.writeheader()
        writer.writerows(summary)

    # Print results for verification
    for row in summary:
        print(row)

# Example usage:
process_cmd_files('../cmd_records/')  # replace with your actual folder path
