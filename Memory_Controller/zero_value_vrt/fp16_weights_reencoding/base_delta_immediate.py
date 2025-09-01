import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt
from utility import *

# main
# set random seed
np.random.seed(0)
n = (2**10)
mean = 0
std = 10

# Generate a random dataset
dataset = generate_random_dataset(n, mean, std)

# I want to display only discerete
plt.hist(dataset, bins=100)
plt.show()

# From the dataset, for every values, turn it into a binary representation, count the number of total
# 0s
zeros = count_zeros(dataset,8)
print("Number of zeros in the dataset: ", zeros)

ones = count_ones(dataset,8)
print("Number of ones in the dataset: ", ones)

# Calculate the percentage of 1
percentage_ones = ones / (ones + zeros) * 100
print("Percentage of ones in the dataset: ", percentage_ones)

# Do the base delta immediate, for 128 bits, do base delta immediate conversion on a granularity of 1KB
# For 512 values, they are going to use the same k bits to represent the deltas
k = 4
base_size = 8

# Number of values to compress
num_values = 256

# From the dataset, extract 512 values
row_to_compress = dataset[:num_values]
new_data_set = []
k_seq = []

# For each 16 values, do the base delta immediate conversion
for i in range(0,num_values,16):
    compressed_line = np.array([0,0]) # (k as size of deltas,B*,7 deltas)
    # Find min and max of row_to_compress
    max_val = np.max(row_to_compress[i:i+16])
    min_val = np.min(row_to_compress[i:i+16])

    # Traverse through the row_to_compress, and find the deltas
    row_to_compress_deltas = row_to_compress[i:i+16] - row_to_compress[i]

    # Try using min or max as the base
    max_val_compressed = np.max(row_to_compress_deltas)
    min_val_compressed = np.min(row_to_compress_deltas)

    # If cannot find any compression method, quit compressing, use the original representation
    bits_required_max = get_num_bits(max_val_compressed)
    bits_required_min = get_num_bits(min_val_compressed)

    if bits_required_max >= 8 or bits_required_min >= 8:
        break

    compressed_line[0] = max(bits_required_max,bits_required_min)
    compressed_line[1] = row_to_compress[i]
    # Add the deltas to the compressed_line
    compressed_line = np.append(compressed_line,row_to_compress_deltas)

    # Record the k value
    k_seq.append(compressed_line[0])

    new_data_set.append(compressed_line)

max_k = max(k_seq)
# Output the maximum k value
print("Maximum k value: ", max(k_seq))

# Replace all k values with the maximum k value
for i in range(len(new_data_set)):
    new_data_set[i][0] = max(k_seq)

# Calculate the cost of the compressed data
cost = 0

for i in range(len(new_data_set)):
    cost += get_num_bits(max_k) + max_k * 16

# print cost
print("Cost of the compressed data: ", cost)

# Saved bits
saved_bits = num_values * 8 - cost

print("Saved bits: ", saved_bits)

#%%
# Find min and max of row_to_compress
max_val = np.max(row_to_compress)
min_val = np.min(row_to_compress)

# Traverse through the row_to_compress, and find the deltas
row_to_compress_deltas = row_to_compress - row_to_compress[0]

# Try using min or max as the base
max_val_compressed = np.max(row_to_compress_deltas)
min_val_compressed = np.min(row_to_compress_deltas)

# If cannot find any compression method, quit compressing, use the original representation
bits_required_max = get_num_bits(max_val_compressed)
bits_required_min = get_num_bits(min_val_compressed)

print("Minimum Bits required to represent the delta value: ", max(bits_required_max,bits_required_min))

compressed_line[0] = max(bits_required_max,bits_required_min)
compressed_line[1] = row_to_compress[0]
# Add the deltas to the compressed_line
compressed_line = np.append(compressed_line,row_to_compress_deltas)

# Number of bits required to represent this value
bits_needed_for_representation = base_size + compressed_line[0] * 8 + get_num_bits(compressed_line[0])

# Saved bits
saved_bits = 16 * 8 - bits_needed_for_representation

print("Saved bits: ", saved_bits)

# This works for the common case