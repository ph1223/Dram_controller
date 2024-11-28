import subprocess
import sys
import os
import glob

def run_ramulator(config_file):
    # Extract the base name of the input file (without the directory and extension)
    base_name = os.path.splitext(os.path.basename(config_file))[0]
    log_file = f"{base_name}.log"

    # Run ramulator2 and redirect output to the derived log file name
    with open(log_file, 'w') as log:
        process = subprocess.run(["./build/ramulator2", "-f", config_file], stdout=log, stderr=subprocess.STDOUT)

    # Check if the process completed successfully
    if process.returncode == 0:
        print(f"Execution completed successfully. Log written to {log_file}")
    else:
        print(f"Execution failed. Check the log file {log_file} for details.")

def run_all_ramulator(config_dir):
    # Find all YAML files in the specified directory
    yaml_files = glob.glob(os.path.join(config_dir, "*.yaml"))

    if not yaml_files:
        print(f"No YAML files found in directory: {config_dir}")
        return

    for yaml_file in yaml_files:
        print(f"Running ramulator2 with config file: {yaml_file}")
        run_ramulator(yaml_file)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python run_stats.py <config_directory>")
        sys.exit(1)

    config_dir = sys.argv[1]
    run_all_ramulator(config_dir)