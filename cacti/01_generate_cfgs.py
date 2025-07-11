import os
import itertools

def read_cfg(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return lines

def modify_cfg(lines, modifications, bank_size, uca_bank_count):
    modified_lines = []
    for line in lines:
        if line.startswith('#') or line.startswith('//') or not line.strip():
            modified_lines.append(line)
            continue

        for key, value in modifications.items():
            if line.startswith(key):
                line = f"{key} {value}\n"
                break
        modified_lines.append(line)

    # Append the calculated bank size and UCA bank count if not already overwritten
    modified_lines.append(f"-bank size (Mb) {bank_size}\n")
    modified_lines.append(f"-UCA bank count {uca_bank_count}\n")

    return modified_lines

def write_cfg(file_path, lines):
    with open(file_path, 'w') as file:
        file.writelines(lines)

def generate_multiple_cfgs(input_file, output_dir, base_modifications, variations):
    os.makedirs(output_dir, exist_ok=True)
    lines = read_cfg(input_file)

    for variation in variations:
        modifications = base_modifications.copy()
        modifications.update(variation)

        # Extract values from current variation
        io_width = modifications['-IO width']
        page_size = modifications['-page size (bits)']
        stacked_die_count = modifications['-stacked die count']
        size_gb = modifications['-size (Gb)']
        uca_bank_count = modifications['-UCA bank count']
        ndbl_value = int(modifications['-Ndbl'])

        # Compute bank size in Mb
        n_stack = int(stacked_die_count)
        n_banks_per_layer = int(uca_bank_count)
        bank_size = int((int(size_gb) / (n_stack * n_banks_per_layer)) * 1024)

        # Ndbl / 2 (if you need it later)
        ndbl_div_2 = ndbl_value // 2

        # Output file name
        output_file = os.path.join(
            output_dir,
            f"tsv_{io_width}_Page{page_size}_Stack{stacked_die_count}_Size{size_gb}_Bank{bank_size}_UCA{uca_bank_count}_Ndbl_{ndbl_value}.cfg"
        )

        modified_lines = modify_cfg(lines, modifications, bank_size, uca_bank_count)
        write_cfg(output_file, modified_lines)

# === Config ===
input_file = './scripts_design_space_exploration/3DDRAM_DDR4_1Gb_128.cfg'
output_dir = './scripts_design_space_exploration/3DDRAM_Design_Exploration/Configs'

base_modifications = {
    '-burst length': '1',
    '-internal prefetch width': '128',
    '-stacked die count': '4',
    '-UCA bank count': '1',
    '-IO width': '1024',
    '-page size (bits)': '8192',
    '-operating temperature (K)': '350',
}

# Sweep values
io_width_values = [1024]
page_size_values = [8192]
stacked_die_count_values = [4]
size_gb_values = [4]
uca_bank_count_values = [1]
ndbl_values = [2**i for i in range(5, 12)]  # 2 to 2048

# Create all combinations
variations = [
    {
        '-IO width': str(io_width),
        '-page size (bits)': str(page_size),
        '-stacked die count': str(stacked_die_count),
        '-size (Gb)': str(size_gb),
        '-UCA bank count': str(uca_bank_count),
        '-Ndbl': str(ndbl)
    }
    for io_width, page_size, stacked_die_count, size_gb, uca_bank_count, ndbl in
    itertools.product(io_width_values, page_size_values, stacked_die_count_values, size_gb_values, uca_bank_count_values, ndbl_values)
]

# Run generation
generate_multiple_cfgs(input_file, output_dir, base_modifications, variations)
