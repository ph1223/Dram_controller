import random

def generate_st_ld_trace(filename, num_lines):
    with open(filename, 'w') as file:
        for _ in range(num_lines):
            operation = random.choice(['ST', 'LD'])
            address = random.randint(0, 2**32 - 1)  # Random address in the range of 32-bit addresses
            file.write(f"{operation} {address}\n")

# Parameters
output_filename = 'ld_st_trace.trace'
number_of_lines = 20000  # Number of lines to generate

# Generate the ST/LD trace
generate_st_ld_trace(output_filename, number_of_lines)