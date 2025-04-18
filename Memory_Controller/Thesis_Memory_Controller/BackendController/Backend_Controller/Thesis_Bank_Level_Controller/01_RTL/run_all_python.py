import shutil
import subprocess
import re

DEFINE_FILE = "define.sv"
BACKUP_FILE = "define.sv.bak"

TRACE_DEFINES = [
    "ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR",
    "READ_WRITE_INTERLEAVE",
    "CONSECUTIVE_READ_WRITE",
    "ALL_ROW_BUFFER_CONFLICTS",
    "ZIGZAG_PATTERN"
]

def extract_cycle_count(output):
    match = re.search(r"Total Memory Simulation cycles:\s+(\d+)", output)
    return match.group(1) if match else "Not Found"

def main():
    # Backup the original define.sv
    shutil.copyfile(DEFINE_FILE, BACKUP_FILE)

    for trace_define in TRACE_DEFINES:
        print(f"▶️ Running simulation with define: {trace_define}")

        # Restore the base define.sv
        shutil.copyfile(BACKUP_FILE, DEFINE_FILE)

        # Append the define to the file
        with open(DEFINE_FILE, "a") as file:
            file.write(f"\n`define {trace_define}\n")

        try:
            # Run the simulation and capture output
            result = subprocess.run(["bash", "./01_run_vcs_rtl"], capture_output=True, text=True, check=True)
            output = result.stdout + result.stderr

            # Extract cycle count
            cycle_count = extract_cycle_count(output)

            # Save to log file
            with open(f"{trace_define}.log", "w") as log_file:
                log_file.write(f"Trace: {trace_define}\n")
                log_file.write(f"Total Memory Simulation cycles: {cycle_count}\n")

            print(f"\033[92m✅ {trace_define} → Cycles: {cycle_count}\033[0m")

        except subprocess.CalledProcessError as e:
            print(f"❌ Error with {trace_define}: {e}")
            with open(f"{trace_define}.log", "w") as log_file:
                log_file.write(f"Trace: {trace_define}\n")
                log_file.write("Simulation failed.\n")
                log_file.write(e.stdout if e.stdout else "")

        print("-" * 50)

    # Restore original define.sv
    shutil.copyfile(BACKUP_FILE, DEFINE_FILE)

if __name__ == "__main__":
    main()
