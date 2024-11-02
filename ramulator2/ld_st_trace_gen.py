import random

def generate_st_ld_trace(filename, num_lines):
    address = 0
    with open(filename, 'w') as file:
        for _ in range(num_lines):
            operation = random.choice(['ST', 'LD'])
            # generate marching pattern for it, increment the address
            address += 1
            file.write(f"{operation} {address}\n")

# Parameters
output_filename = 'ld_st_trace.trace'
number_of_lines = 2000  # Number of lines to generate

# Generate the ST/LD trace
generate_st_ld_trace(output_filename, number_of_lines)