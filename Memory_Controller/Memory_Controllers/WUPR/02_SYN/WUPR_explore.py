import subprocess
import re
import os

# List of N values to try
N_list = [2**i for i in range(1, 12)]  # 2, 4, ..., 128 (adjust as needed)

# File paths
sv_file_path = "WUPR.sv"
log_file_path = "wupr_area_log.txt"
area_report_path = "Report/WUPR.area"  # Adjust if your report path is different

# Regex to match the specific N parameter line with optional whitespace
param_pattern = re.compile(
    r"(parameter\s+int\s+N\s*=\s*)\d+(\s*,\s*//.*segments\s*\(must\s+be\s+power\s+of\s+2\))"
)

# Start logging
with open(log_file_path, "w") as log:
    log.write("WUPR Area Sweep Log\n")
    log.write("====================\n\n")

# Sweep over different N values
for N in N_list:
    print(f"\n[INFO] Synthesizing WUPR with N = {N}")

    # Step 1: Modify the N parameter in WUPR.sv
    try:
        with open(sv_file_path, "r") as f:
            content = f.read()

        # Replace the N assignment line specifically
        def replace_N(match):
            return f"{match.group(1)}{N}" + match.group(2)

        content_new = re.sub(param_pattern, replace_N, content)

        with open(sv_file_path, "w") as f:
            f.write(content_new)

        print(f"[✓] Updated N to ((({N}))) in {sv_file_path}")
    except Exception as e:
        print(f"[✗] Failed to update {sv_file_path} for N={N}: {e}")
        continue

    # Step 2: Run synthesis using `make syn`
    try:
        subprocess.run(["make", "syn"], check=True)
        print("[✓] Synthesis completed")
    except subprocess.CalledProcessError:
        print(f"[✗] Synthesis failed for N={N}")
        continue
    except OSError as e:
        print(f"[✗] Make command execution failed: {e}")
        continue

    # Step 3: Extract area from report
    try:
        if not os.path.isfile(area_report_path):
            print(f"[✗] Area report file '{area_report_path}' not found after synthesis for N={N}")
            continue

        area = None
        with open(area_report_path, "r") as rpt:
            lines = rpt.readlines()

        print(f"[DEBUG] Contents of '{area_report_path}':")
        for l in lines:
            print(l.strip())

        for line in lines:
            # Regex: allow leading spaces, exact match to 'Total cell area:'
            match = re.search(r"^\s*Total cell area:\s*([\d\.]+)", line)
            if match:
                area = float(match.group(1))
                print(f"[DEBUG] Matched line: {line.strip()} with area = {area}")
                break

        if area is not None:
            print(f"[✓] Area = {area}")
            with open(log_file_path, "a") as log:
                log.write(f"N = {N:>4} => Area = {area:.2f}\n")
        else:
            print("[✗] Area not found in report")
    except Exception as e:
        print(f"[✗] Failed to parse area for N={N}: {e}")
