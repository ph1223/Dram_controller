import subprocess
import re

# Paths
ctrl_sv_path = "Ctrl.sv"
log_file_path = "latency_analysis.log"

# Read and backup original Ctrl.sv content
with open(ctrl_sv_path, "r") as f:
    original_ctrl_sv = f.read()

# Function to modify CTRL_FIFO_DEPTH in Ctrl.sv
def modify_ctrl_fifo_depth(depth):
    def replacer(match):
        return f"{match.group(1)}{depth}{match.group(2)}"
    
    modified = re.sub(
        r'(localparam\s+CTRL_FIFO_DEPTH\s*=\s*)\d+(\s*;)',
        replacer,
        original_ctrl_sv
    )
    with open(ctrl_sv_path, "w") as f:
        f.write(modified)

# Main script logic
with open(log_file_path, "w") as log_file:
    for depth in range(2, 9):  # ctrl_fifo_depth from 2 to 8
        print(f"\n[INFO] Running simulation for CTRL_FIFO_DEPTH = {depth}")
        modify_ctrl_fifo_depth(depth)

        try:
            result = subprocess.run("bash ./01_run_vcs_rtl", shell=True, capture_output=True, text=True, check=True)

            stdout = result.stdout

            # Extract Total Memory Simulation cycles
            match = re.search(r"Total Memory Simulation cycles:\s+(\d+)", stdout)
            if match:
                cycles = match.group(1)
                log_entry = f"CTRL_FIFO_DEPTH={depth}, Total Memory Simulation cycles: {cycles}\n"
                print(f"[RESULT] {log_entry.strip()}")
                log_file.write(log_entry)
            else:
                print(f"[WARNING] Could not find 'Total Memory Simulation cycles' for depth {depth}")
                log_file.write(f"CTRL_FIFO_DEPTH={depth}, Simulation cycles: NOT FOUND\n")

        except subprocess.CalledProcessError as e:
            print(f"[ERROR] Simulation failed for CTRL_FIFO_DEPTH={depth}")
            log_file.write(f"CTRL_FIFO_DEPTH={depth}, Simulation FAILED\n")

# Restore original Ctrl.sv
with open(ctrl_sv_path, "w") as f:
    f.write(original_ctrl_sv)

print("\n[INFO] Latency analysis completed. Results saved in 'latency_analysis.log'.")
