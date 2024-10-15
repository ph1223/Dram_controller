import re

def extract_components(log_file):
    with open(log_file, 'r') as file:
        content = file.read()

    # Extract Timing Components
    timing_pattern = re.compile(r'Timing Components:\n(.*?)\nPower Components:', re.DOTALL)
    timing_match = timing_pattern.search(content)
    timing_components = timing_match.group(1).strip() if timing_match else "Not found"

    # Extract Power Components
    power_pattern = re.compile(r'Power Components:\n(.*?)\nArea Components:', re.DOTALL)
    power_match = power_pattern.search(content)
    power_components = power_match.group(1).strip() if power_match else "Not found"

    # Extract Area Components
    area_pattern = re.compile(r'Area Components:\n(.*?)\nTSV Components:', re.DOTALL)
    area_match = area_pattern.search(content)
    area_components = area_match.group(1).strip() if area_match else "Not found"

    # Extract TSV Components
    tsv_pattern = re.compile(r'TSV Components:\n(.*?)\n', re.DOTALL)
    tsv_match = tsv_pattern.search(content)
    tsv_components = tsv_match.group(1).strip() if tsv_match else "Not found"

    return timing_components, power_components, area_components, tsv_components

# Usage
log_file = '3DDRAM_Samsung3D8Gb_extened_cfg.log'
timing, power, area, tsv = extract_components(log_file)

print("Timing Components:\n", timing)
print("\nPower Components:\n", power)
print("\nArea Components:\n", area)
print("\nTSV Components:\n", tsv)