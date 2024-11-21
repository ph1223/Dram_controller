import numpy as np
import matplotlib.pyplot as plt

# Generate a random dataset with a certain value representation, for example int8, from gaussian distribution
def generate_random_dataset(n, mean, std):
    # Create a wider gaussian distribution ranging from -128 to 128
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

def find_optimal(sorted_frequency):
    # Now remap the values in the dataset to a new value, where the value with the highest frequency
    # will be remapped to an int8 value with least bits, for example highest frequency maps to 00000000,
    # second highest frequency maps to 00000001, and so on, until the value with the lowest frequency
    # third highest maps to 00000010, and so on, until the value with the lowest frequency maps to 11111111
    # and the value with the lowest frequency will be remapped to 11111111
    zero_percentage_list = []
    one_percentage_list = []
    remapped_values_counts_list = []


    for counts in range (0,256,2):
        #remap the dataset
        remapped_dataset = np.zeros(n)
        remapped_values_counts = 0

        # Create a table to store the (value,bit count) pair for -128,128
        available_values_table = np.zeros((256,2))
        used_values = {}
        mapping = {}

        # Initialize the table from -128~128
        for i in range(-128,128):
            available_values_table[i+128][0] = i
            # Calculate the number of bits required for i
            available_values_table[i+128][1] = np.sum([1 for j in np.binary_repr(i, width=8) if j == '1'])

        num_of_values_remapped = counts
        values_used_to_remap = []
        values_gets_mapped = []

        # Selects the value with highest frequency from the sorted_frequency
        for key in sorted_frequency:
            # Select the value from available_values_table with the least number of bits
            min_value = 0
            min_bits = 8

            if num_of_values_remapped != 0 :
                # Find the values with the least number of bits
                for i in range(-128,128):
                    if available_values_table[i+128][1] < min_bits and i not in used_values:
                        min_value = i
                        min_bits = available_values_table[i+128][1]

                # Remaps the value with the min_value
                if key not in mapping:
                    mapping[key] = min_value
                    # Mark the value as used
                    used_values[min_value] = 1

                values_used_to_remap.append(key)
                values_gets_mapped.append(key)
                num_of_values_remapped -= 1
                remapped_values_counts += 1
            else:
                # Remap the rest of the values to the same value
                if key not in mapping and key not in values_used_to_remap:
                    mapping[key] = key

        # Check if mapping key exist

        for values in values_used_to_remap: # Those values that got used
            # Check if values is already mapped
            if values not in values_gets_mapped:
                # Find the value that is not mapped
                for i in range(-128,128):
                    if i not in used_values:
                        mapping[values] = i
                        used_values[i] = 1
                        break
            remapped_values_counts += 1

        # Remap the dataset
        for i in range(n):
            remapped_dataset[i] = mapping[dataset[i]]

        # Display the mapping
        # print(mapping)

        # print(remapped_dataset)
        # plt.hist(remapped_dataset, bins=100)
        # plt.show()

        # print("Top ",counts," values are remapped")
        # Count the number of zeroes in the remapped dataset
        remapped_zeros = count_zeros(remapped_dataset,8)
        # print("Number of zeros in the remapped dataset: ", remapped_zeros)

        remapped_ones = count_ones(remapped_dataset,8)
        # print("Number of ones in the remapped dataset: ", remapped_ones)

        # Calculate the percentage of 1
        percentage_ones = remapped_ones / (remapped_ones + remapped_zeros) * 100
        # percentage of zeroes
        percentage_zeroes = remapped_zeros / (remapped_ones + remapped_zeros) * 100

        # print("Percentage of ones in the remapped dataset: ", percentage_ones)
        # print("Percentage of zeroes in the remapped dataset: ", percentage_zeroes)

        zero_percentage_list.append(percentage_zeroes)
        one_percentage_list.append(percentage_ones)
        remapped_values_counts_list.append(remapped_values_counts)

    return zero_percentage_list, one_percentage_list, remapped_values_counts_list

#%%
zero_percentage_list, one_percentage_list, remapped_values_counts_list = find_optimal(sorted_frequency=sorted_frequency)

#%%
desired_ones_percentage = 22

# Find the minimum number of remapped values counts that is lower than the desired_ones_percentage
index = 0
for i in range(len(one_percentage_list)):
    if one_percentage_list[i] < desired_ones_percentage:
        index = i
        break

# Plot the remapped values counts vs percentage of zeroes
plt.plot(remapped_values_counts_list, one_percentage_list)
plt.xlabel('Remapped values counts')
plt.ylabel('Percentage of zeroes')
plt.title('Remapped values counts vs Percentage of ones')

# Pin point the desired_ones_percentage and this index
plt.scatter(remapped_values_counts_list[index], one_percentage_list[index], color='red')
# Display the coordinates
plt.text(remapped_values_counts_list[index], one_percentage_list[index], f'({remapped_values_counts_list[index]},{one_percentage_list[index]})')

# Display the line of the desired_ones_percentage
plt.axhline(y=desired_ones_percentage, color='r', linestyle='--')

plt.show()

#%%
# Plot the cost v.s. remapped values counts
bits_width = 128

# Calculate the cost in bytes for each remapped values counts
cost_byte = [(i*(bits_width/8))/1024 for i in remapped_values_counts_list]

# Make the plot discrete
remapped_values_counts_list = [i for i in remapped_values_counts_list]
cost_byte = [i for i in cost_byte]

# Plot the cost v.s. remapped values counts
plt.plot(remapped_values_counts_list, cost_byte)

# pin point this index
plt.scatter(remapped_values_counts_list[index], cost_byte[index], color='red')
# Display the coordinates
plt.text(remapped_values_counts_list[index], cost_byte[index], f'({remapped_values_counts_list[index]},{cost_byte[index]})')

plt.xlabel('Remapped values counts')
plt.ylabel('Cost in Kilo bytes')
plt.title('Remapped values counts vs Cost in bytes')

plt.show()

#%%
