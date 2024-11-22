def calculate_max_physical_address():
    # Define bit lengths
    column_bits = 10
    row_bits = 11
    bank_bits = 0

    # Total bits for addressing
    total_bits = column_bits + row_bits + bank_bits

    # Maximum addressable units
    max_units = 2 ** total_bits

    # Each unit is 16 bytes (128 bits)
    max_physical_address = max_units * 16

    return max_physical_address

# Calculate and print the maximum physical address
max_address = calculate_max_physical_address()
print(f"Maximum Physical Address: {max_address} bytes")