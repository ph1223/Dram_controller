import os
import re
import csv

def extract_metrics_from_log(file_path):
    metrics = {
        "total_energy": None,
        "memory_system_cycles": None,
        "bandwidth_utilization": None,
        "peak_bandwidth": None
    }

    with open(file_path, 'r') as file:
        content = file.read()

        # Find MemorySystem block
        memsys_match = re.search(r"MemorySystem:(.*?)(?:\n\s*\n|\Z)", content, re.DOTALL)
        if memsys_match:
            memsys_block = memsys_match.group(1)

            # Now extract values only from the MemorySystem block
            peak_bandwidth_match = re.search(r"peak_bandwidth:\s*([0-9\.eE+-]+)", memsys_block)
            bandwidth_util_match = re.search(r"bandwidth_utilization:\s*([0-9\.eE+-]+)", memsys_block)
            mem_cycles_match = re.search(r"memory_system_cycles:\s*(\d+)", memsys_block)

            if peak_bandwidth_match:
                metrics["peak_bandwidth"] = float(peak_bandwidth_match.group(1))
            if bandwidth_util_match:
                metrics["bandwidth_utilization"] = float(bandwidth_util_match.group(1))
            if mem_cycles_match:
                metrics["memory_system_cycles"] = int(mem_cycles_match.group(1))

        # total_energy is in DRAM section, can be anywhere after MemorySystem
        total_energy_match = re.search(r"total_energy:\s*([0-9\.eE+-]+)", content)
        if total_energy_match:
            metrics["total_energy"] = float(total_energy_match.group(1))

    return metrics


def process_trace_logs(trace_log_dir, output_csv='trace_summary.csv'):
    summary = []

    for filename in os.listdir(trace_log_dir):
        if filename.endswith(".log"):
            name = os.path.splitext(filename)[0]
            file_path = os.path.join(trace_log_dir, filename)
            metrics = extract_metrics_from_log(file_path)
            summary.append({"name": name, **metrics})

    # Write to CSV
    keys = ["name", "total_energy", "memory_system_cycles", "bandwidth_utilization", "peak_bandwidth"]
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=keys)
        writer.writeheader()
        writer.writerows(summary)

    # Output the data
    for row in summary:
        print(row)

# Example usage:
process_trace_logs('../traces_log/')