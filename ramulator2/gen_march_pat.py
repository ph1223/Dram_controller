import random
import os

def generate_sequential_access_pattern(start_address, num_lines, max_sequential,max_address_range, output_file):
    current_address = start_address
    i = 0
    with open(output_file, 'w') as f:
        while i < num_lines:
            # Determine the number of sequential accesses
            sequential_count = random.randint(1, max_sequential)
            for _ in range(sequential_count):
                if i >= num_lines:
                    break
                access_type = 'S' if i % 2 == 0 else 'L'
                num_inst = random.randint(0, 2)
                f.write(f"0 0 {num_inst} {access_type} {current_address}\n")

                current_address += 1
                current_address = current_address % max_address_range

                i += 1

            # Jump to a new random address
            if i < num_lines:
                current_address = random.randint(0, max_address_range)

# Parameters
start_address = 0
num_lines = 3000000
max_sequential = 2048  # Maximum number of sequential accesses before a jump
max_address_range = 134217728  # Range for random jump addresses

# Output directory and file
output_dir = './traces'
output_file = os.path.join(output_dir, 'marching_pattern_1Gb.trace')

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)

# Generate the pattern and write to the file
generate_sequential_access_pattern(start_address, num_lines, max_sequential, max_address_range, output_file)