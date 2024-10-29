import os
import itertools

def read_cfg(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return lines

def modify_cfg(lines, modifications, bank_size):
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

    # Append the calculated bank size
    modified_lines.append(f"-bank size (Mb) {bank_size}\n")

    return modified_lines

def write_cfg(file_path, lines):
    with open(file_path, 'w') as file:
        file.writelines(lines)

def generate_multiple_cfgs(input_file, output_dir, base_modifications, variations):
    os.makedirs(output_dir, exist_ok=True)
    lines = read_cfg(input_file)

    for i, variation in enumerate(variations):
        modifications = base_modifications.copy()
        modifications.update(variation)

        # Create a descriptive filename
        io_width = modifications['-IO width']
        page_size = modifications['-page size (bits)']
        stacked_die_count = modifications['-stacked die count']
        size_gb = modifications['-size (Gb)']

        # Calculate bank size
        n_stack = int(modifications['-stacked die count'])
        bank_size = int((int(size_gb) / n_stack) * 1024)

        modified_lines = modify_cfg(lines, modifications, bank_size)

        output_file = os.path.join(output_dir, f"tsv_{io_width}_Page{page_size}_Stack{stacked_die_count}_Size{size_gb}_Bank{bank_size}_Mb.cfg")

        write_cfg(output_file, modified_lines)

# Example usage
input_file = '3DDRAM_DDR4_1Gb_128.cfg'  # Replace with your .cfg file path
output_dir = '3DDRAM_Design_Exploration/Configs'
base_modifications = {
    '-burst length': '2',
    '-internal prefetch width': '128',
    '-stacked die count': '4',
    '-UCA bank count': '1',
    '-IO width': '128',
    '-page size (bits)': '8192',
    '-operating temperature (K)': '350',
    # Add other base modifications here
}

# Define the different values for sweeping
io_width_values = [64, 128, 256, 512, 1024]
page_size_values = [8192, 16384, 32768]
stacked_die_count_values = [4, 8]
size_gb_values = [1, 2, 4]

# Generate all combinations of the sweeping parameters
variations = [
    {'-IO width': str(io_width), '-page size (bits)': str(page_size), '-stacked die count': str(stacked_die_count), '-size (Gb)': str(size_gb)}
    for io_width, page_size, stacked_die_count, size_gb in itertools.product(io_width_values, page_size_values, stacked_die_count_values, size_gb_values)
]

generate_multiple_cfgs(input_file, output_dir, base_modifications, variations)