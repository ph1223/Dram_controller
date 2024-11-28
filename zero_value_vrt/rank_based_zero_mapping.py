import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt
from utility import *

# main
# set random seed
np.random.seed(0)
n = (2**20)
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

# Method1, according to rankings of the frequency of the values in the dataset
# From the dataset, count the frequency of each value
unique, counts = np.unique(dataset, return_counts=True)
frequency = dict(zip(unique, counts))

# sort the frequency by the number of occurences
sorted_frequency = dict(sorted(frequency.items(), key=lambda item: item[1], reverse=True))

# Now remap the values in the dataset to a new value, where the value with the highest frequency
# will be remapped to an int8 value with least bits, for example highest frequency maps to 00000000,
# second highest frequency maps to 00000001, and so on, until the value with the lowest frequency
# third highest maps to 00000010, and so on, until the value with the lowest frequency maps to 11111111
# and the value with the lowest frequency will be remapped to 11111111

#remap the dataset
remapped_dataset = np.zeros(n)

# Create a table to store the (value,bit count) pair for -128,128
available_values_table = np.zeros((256,2))
used_values = {}
mapping = {}

# Initialize the table from -128~128
for i in range(-128,128):
    available_values_table[i+128][0] = i
    # Calculate the number of bits required for i
    available_values_table[i+128][1] = np.sum([1 for j in np.binary_repr(i, width=8) if j == '1'])

# Selects the value with highest frequency from the sorted_frequency
for key in sorted_frequency:
    # Select the value from available_values_table with the least number of bits
    min_value = 0
    min_bits = 8

    for i in range(-128,128):
        if available_values_table[i+128][1] < min_bits and i not in used_values:
            min_value = i
            min_bits = available_values_table[i+128][1]

    # Remaps the value with the min_value
    if key not in mapping:
        mapping[key] = min_value
        # Mark the value as used
        used_values[min_value] = 1

#%%
# Remap the dataset
for i in range(n):
    remapped_dataset[i] = mapping[dataset[i]]


# print(remapped_dataset)
plt.hist(remapped_dataset, bins=100)
plt.show()

# Count the number of zeroes in the remapped dataset
remapped_zeros = count_zeros(remapped_dataset,8)
print("Number of zeros in the remapped dataset: ", remapped_zeros)

remapped_ones = count_ones(remapped_dataset,8)
print("Number of ones in the remapped dataset: ", remapped_ones)

# Calculate the percentage of 1
percentage_ones = remapped_ones / (remapped_ones + remapped_zeros) * 100

print("Percentage of ones in the remapped dataset: ", percentage_ones)
