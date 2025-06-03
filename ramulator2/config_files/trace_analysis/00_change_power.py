import os
import yaml

# ✅ Set the directory with your .yaml files
yaml_directory = "./"  # Change to your actual path if needed

# ✅ Define new values for the powers
user_defined_powers = {
    "activation_power": 1.49164,
    "precharge_power": 1.38858,
    "read_power": 5.8933,
    "write_power": 5.8933,
}

# ✅ Mapping old keys to new ones
power_key_map = {
    "activation_power": "activation_power",
    "precharge_power": "precharge_power",
    "read_power": "read_power",
    "write_power": "write_power"
}

def update_yaml_file(filepath):
    with open(filepath, 'r') as f:
        data = yaml.safe_load(f)

    try:
        dram = data["MemorySystem"]["DRAM"]
    except (KeyError, TypeError):
        print(f"❌ Skipped (missing MemorySystem/DRAM): {filepath}")
        return

    modified = False

    for old_key, new_key in power_key_map.items():
        if old_key in dram:
            dram[new_key] = user_defined_powers.get(new_key, dram[old_key])
            del dram[old_key]
            modified = True

    if modified:
        with open(filepath, 'w') as f:
            yaml.dump(data, f, default_flow_style=False)
        print(f"✅ Updated: {filepath}")
    else:
        print(f"ℹ️ No change needed: {filepath}")

def process_yaml_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".yaml"):
            filepath = os.path.join(directory, filename)
            update_yaml_file(filepath)

if __name__ == "__main__":
    process_yaml_files(yaml_directory)
