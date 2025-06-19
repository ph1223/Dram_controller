import os
import re
import csv

def extract_metrics_from_log(file_path):
    metrics = {
        "total_energy": None,
        "memory_system_cycles": None,
        "bandwidth_utilization": None,
        "peak_bandwidth": None,
        "frontend_avg_bandwidth": None,
        "total_read_energy": None,
        "total_write_energy": None,
        "total_refresh_energy": None,
        "total_activation_energy": None,
        "total_precharge_energy": None
    }

    with open(file_path, 'r') as file:
        content = file.read()

        # Extract from MemorySystem block
        memsys_match = re.search(r"MemorySystem:(.*?)(?:\n\S|\Z)", content, re.DOTALL)
        if memsys_match:
            memsys_block = memsys_match.group(1)

            peak_bandwidth_match = re.search(r"peak_bandwidth:\s*([0-9\.eE+-]+)", memsys_block)
            bandwidth_util_match = re.search(r"bandwidth_utilization:\s*([0-9\.eE+-]+)", memsys_block)
            mem_cycles_match = re.search(r"memory_system_cycles:\s*(\d+)", memsys_block)

            if peak_bandwidth_match:
                metrics["peak_bandwidth"] = float(peak_bandwidth_match.group(1))
            if bandwidth_util_match:
                metrics["bandwidth_utilization"] = float(bandwidth_util_match.group(1))
            if mem_cycles_match:
                metrics["memory_system_cycles"] = int(mem_cycles_match.group(1))

            # Extract DRAM block from MemorySystem
            dram_match = re.search(r"DRAM:(.*?)(?:\n\S|\Z)", memsys_block, re.DOTALL)
            if dram_match:
                dram_block = dram_match.group(1)

                # Extract additional energy metrics
                energy_patterns = {
                    "total_read_energy": r"total_read_energy:\s*([0-9\.eE+-]+)",
                    "total_write_energy": r"total_write_energy:\s*([0-9\.eE+-]+)",
                    "total_refresh_energy": r"total_refresh_energy:\s*([0-9\.eE+-]+)",
                    "total_activation_energy": r"total_activation_energy:\s*([0-9\.eE+-]+)",
                    "total_precharge_energy": r"total_precharge_energy:\s*([0-9\.eE+-]+)"
                }

                for key, pattern in energy_patterns.items():
                    match = re.search(pattern, dram_block)
                    if match:
                        metrics[key] = float(match.group(1))

        # Extract from Frontend block
        frontend_match = re.search(r"Frontend:(.*?)(?:\n\S|\Z)", content, re.DOTALL)
        if frontend_match:
            frontend_block = frontend_match.group(1)
            avg_bw_match = re.search(r"average_bandwidth:\s*([0-9\.eE+-]+)", frontend_block)
            if avg_bw_match:
                metrics["frontend_avg_bandwidth"] = float(avg_bw_match.group(1))

        # Extract total_energy from top-level
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

    # Define the order of keys (columns in CSV)
    keys = [
        "name",
        "total_energy",
        "memory_system_cycles",
        "bandwidth_utilization",
        "peak_bandwidth",
        "frontend_avg_bandwidth",
        "total_read_energy",
        "total_write_energy",
        "total_refresh_energy",
        "total_activation_energy",
        "total_precharge_energy"
    ]

    # Write summary to CSV
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=keys)
        writer.writeheader()
        writer.writerows(summary)

    # Optional: Print each row
    for row in summary:
        print(row)


# Example usage:
process_trace_logs('../bank_analysis/trace_log/')
