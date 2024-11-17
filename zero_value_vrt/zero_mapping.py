import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt

# Generate a random dataset with a certain value representation, for example int8, from gaussian distribution
def generate_random_dataset(n, mean, std):
    dataset = np.random.normal(mean, std, n)
    dataset = np.round(dataset)
    dataset = np.clip(dataset, -128, 128)  # Clip values to be within -128 and 128
    dataset = dataset.astype(int)
    return dataset

# Turn all the values in dataset into binary representation, and count the number of zeros for the binary representation
# of the dataset, sum them up
def count_zeros(dataset,bit_width):
    # convert dataset to int
    dataset = dataset.astype(int)

    num_of_zeros = 0
    for i in range(len(dataset)):
        binary = np.binary_repr(dataset[i], width=bit_width)
        num_of_zeros += np.sum([1 for j in binary if j == '0'])

    return num_of_zeros

# Count the number of ones in the binary representation of the dataset
def count_ones(dataset,bit_width):
    # convert dataset to int
    dataset = dataset.astype(int)

    num_of_ones = 0
    for i in range(len(dataset)):
        binary = np.binary_repr(dataset[i], width=bit_width)
        num_of_ones += np.sum([1 for j in binary if j == '1'])

    return num_of_ones

# main
# set random seed
np.random.seed(1234)
n = 2**20
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


# Display the mapping
print(mapping)


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
# percentage of zeroes
percentage_zeroes = remapped_zeros / (remapped_ones + remapped_zeros) * 100

print("Percentage of ones in the remapped dataset: ", percentage_ones)
print("Percentage of zeroes in the remapped dataset: ", percentage_zeroes)


# Further extends the remapping
# Now from the data set, since each value is a int8 values, group the values into 16 groups, forming a 128bits value
# creating a 128 bits granularity dataset, group 16 values together

# group the values in the dataset into 16 groups
# grouped_dataset = np.zeros(n//16)

# # The grouped dataset will be the concatenation of the 16 values in the dataset
# for i in range(n//16):
#     grouped_dataset[i] = int(''.join([np.binary_repr(dataset[i*16+j], width=8) for j in range(16)]), 2)

# # print(grouped_dataset)
# plt.hist(grouped_dataset, bins=100)
# plt.show()

# # Sort the grouped dataset according to the frequency of the values
# unique, counts = np.unique(grouped_dataset, return_counts=True)
# frequency = dict(zip(unique, counts))

# # sort the frequency by the number of occurences
# sorted_frequency = dict(sorted(frequency.items(), key=lambda item: item[1], reverse=True))

# # Count the number of zeroes in the remapped dataset
# grouped_zeros = count_zeros(grouped_dataset,128)

# print("Number of zeros in the grouped dataset: ", grouped_zeros)

# grouped_ones = count_ones(grouped_dataset,128)

# print("Number of ones in the grouped dataset: ", grouped_ones)

# # Calculate the percentage of 1
# percentage_ones = grouped_ones / (grouped_ones + grouped_zeros) * 100

# print("Percentage of ones in the grouped dataset: ", percentage_ones)
