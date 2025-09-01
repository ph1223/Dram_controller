import json
import pandas as pd
import re

# === Settings ===
json_path = "3d_dram_config_results.json"
output_pickle = "filtered_dram_config.pkl"
bank_to_trfc = {
    "256": 60,
    "512": 80,
    "1024": 110,
    "2048": 160
}

initial_density = 1024
initial_row     = 65536
initial_column  = 16

# === Step 1: Load JSON file ===
with open(json_path, "r") as f:
    raw_data = json.load(f)

# === Step 2: Filter, flatten, and rename ===
records = []
for entry in raw_data:
    key = entry["key"]

    # Skip entries that contain Stack8
    if "Stack8" in key:
        continue

    # --- Parse key ---------------------------------------------------------
    page_match = re.search(r"Page(\d+)", key)
    page_size = int(page_match.group(1)) if page_match else None  # in bits

    bank_match = re.search(r"Bank(\d+)", key)
    bank_size = int(bank_match.group(1)) if bank_match else None  # in Mb

    if page_size is None or bank_size is None:
        continue
    # -----------------------------------------------------------------------

    # === Derived values (corrected row calculation) ===
    nRFC = bank_to_trfc.get(str(bank_size), None)
    # column = page_size // 1024
    column = initial_column
    # density = bank_size
    density = initial_density
    # row = (bank_size * 1024 * 1024) // page_size  # ✅ PageSize is in bits
    row = initial_row  # ✅ PageSize is in bits

    # Rename timing keys (t_ → n)
    timing_renamed = {
        k.replace("t_", "n"): v
        for k, v in entry["timing_rounded"].items()
    }

    # Rename power keys
    power = entry["power"]
    power_renamed = {
        "activation_power": power["Activation energy"],
        "precharge_power": power["Precharge energy"],
        "read_power": power["Read energy"],
        "write_power": power["Write energy"]
    }

    # Build flattened row (without cycle_time, PageSize, BankSize)
    flat = {
        "key": key,
        "nRFC": nRFC,
        "column": column,
        "density": density,
        "row": row
    }
    flat.update(timing_renamed)
    flat.update(power_renamed)
    records.append(flat)

# === Step 3: Create DataFrame ===
df = pd.DataFrame(records)

# Sort for consistency
df = df.sort_values(by=["row", "column"])

# === Step 4: Save as Pickle ===
df.to_pickle(output_pickle)
print(f"✅ Pickle file '{output_pickle}' written with shape {df.shape}.")
