import pandas as pd
import yaml
import os
import copy
import sys

# === User Settings =========================================================
input_pickle  = "filtered_dram_config.pkl"
baseline_yaml = "32ms_With_WUPR_Analysis.yaml"

# Linux-style destination path (WSL)
linux_output_dir = "/home/sicajc/user/new_DDR/Master_Thesis_MC/ramulator2/bank_analysis"

# Your WSL distro name
wsl_distro = "Ubuntu"

# New trace instruction count
new_num_insts = 193881265
# ===========================================================================

def linux_to_unc_path(linux_path: str, distro: str) -> str:
    linux_path = linux_path.lstrip("/")
    unc = f"\\\\wsl$\\{distro}\\" + linux_path.replace("/", "\\")
    return unc

# === Output directory path mapping =========================================
if os.name == "nt":
    output_dir = linux_to_unc_path(linux_output_dir, wsl_distro)
else:
    output_dir = linux_output_dir

os.makedirs(output_dir, exist_ok=True)
print(f"[INFO] YAML files will be written to: {output_dir}")

# === Load baseline YAML ====================================================
try:
    with open(baseline_yaml, "r") as f:
        baseline_config = yaml.safe_load(f)
except FileNotFoundError:
    print(f"[ERROR] Baseline YAML '{baseline_yaml}' not found.", file=sys.stderr)
    sys.exit(1)

# === Load DataFrame ========================================================
df = pd.read_pickle(input_pickle)

# === Helper: recursively update model parameters ===========================
def recursive_update(cfg, params):
    if isinstance(cfg, dict):
        for k, v in cfg.items():
            if isinstance(v, (dict, list)):
                recursive_update(v, params)
            elif k in params:
                cfg[k] = params[k]
    elif isinstance(cfg, list):
        for item in cfg:
            recursive_update(item, params)

# === Generate customized YAMLs =============================================
for _, row in df.iterrows():
    row_dict = row.to_dict()
    key_name = row_dict["key"]

    # Deep copy and patch base config
    cfg_instance = copy.deepcopy(baseline_config)

    # Update timing/power parameters
    recursive_update(cfg_instance, row_dict)

    # ✅ Update ControllerPlugin.path
    try:
        plugins = cfg_instance.get("MemorySystem", {}).get("Controller", {}).get("plugins", [])
        for plugin in plugins:
            if isinstance(plugin, dict) and "ControllerPlugin" in plugin:
                plugin_cfg = plugin["ControllerPlugin"]
                if isinstance(plugin_cfg, dict) and "path" in plugin_cfg:
                    old_path = plugin_cfg["path"]
                    new_path = f"../cmd_records/{key_name}.cmd"
                    plugin_cfg["path"] = new_path
                    print(f"[DEBUG] Patched cmd path: {old_path} → {new_path}")
    except Exception as e:
        print(f"[WARNING] ControllerPlugin path patch failed for {key_name}: {e}")

    # ✅ Update Frontend.num_expected_insts
    try:
        if "Frontend" in cfg_instance and isinstance(cfg_instance["Frontend"], dict):
            cfg_instance["Frontend"]["num_expected_insts"] = new_num_insts
            print(f"[DEBUG] Patched num_expected_insts → {new_num_insts}")
    except Exception as e:
        print(f"[WARNING] Failed to update Frontend.num_expected_insts for {key_name}: {e}")

    # === Save YAML ===
    out_path = os.path.join(output_dir, f"{key_name}.yaml")
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w") as f:
        yaml.dump(cfg_instance, f, sort_keys=False)

    print(f"✅ Generated: {out_path}")

# === Export entire DataFrame to CSV for easy viewing ========================
csv_out_path = os.path.join(output_dir, "dataframe_export.csv")
df.to_csv(csv_out_path, index=False)
print(f"\n✅ DataFrame exported as CSV: {csv_out_path}")

print("\n[DONE] All YAMLs and CSV have been generated successfully.")
