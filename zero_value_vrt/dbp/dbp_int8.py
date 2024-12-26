from helperFucntions import *
#deep copy
from copy import deepcopy
# matplotlib
import matplotlib.pyplot as plt

samples = 2**20
mean = 0
std = 10
seed = 1234

distribution = generate_normal_distribution_int8(samples, mean, std, seed)
# unfiorm
# distribution = generate_uniform_distribution_int8(samples, -128, 127, seed)

# Plot this dsitribution
plt.hist(distribution, bins=100)
plt.show()

# Take the distribution, encode the distribution by groups
# Each groups contains 128 elements, take the difference vector for each group
# and encode the difference vector using 8 bits
# XOR the difference vector

total_ones_before = 0
total_zeroes_before = 0

# Instantiate new distribution in int8, each elemnt is a vector of 0 and 1,
# as a 2D array
new_distribution           = np.zeros((len(distribution), 8), dtype=np.int8)
# distribution_converted     = np.zeros((len(distribution), 8), dtype=np.int8)

# Transpose the vector for each group, XOR the vector
total_ones_after = 0
total_zeroes_after = 0

num_of_elements_in_groups = 128

# Convert the distribution to int8 binary representation
for i in range(len(distribution)):
    binary_repre = convert_to_bit_width(8, distribution[i])

    # count the number of ones and zeroes in the vector
    vector_ones,vector_zeroes = count_ones_and_zeroes_1D(binary_repre)

    total_ones_before   += vector_ones
    total_zeroes_before += vector_zeroes


for i in range(0, len(distribution), num_of_elements_in_groups):
    group = distribution[i:i+num_of_elements_in_groups]

    # 1. Take the difference
    # convert_to_diff_vector(group)

    # 2. Perform true cell encoding
    true_cell_encoding(8, group)

    bit_width = 8
    before_encode_vector = convert_vector_to_bit_width(bit_width, group)

    # BP encoding
    # 3. Transpose the vector
    before_encode_vector.T

    # XOR the vector
    xor_bp_vector(before_encode_vector)

    # Count the number of ones and zeroes in the vector
    bp_ones,bp_zeroes = count_ones_and_zeroes_2d(before_encode_vector)

    total_ones_after += bp_ones
    total_zeroes_after += bp_zeroes

    # Store the vector in the new distribution
    new_distribution[i:i+num_of_elements_in_groups] = before_encode_vector

# Calculate percentages of ones and zeroes before and after
total_elements = samples * 8
total_ones_before_percentage = total_ones_before / total_elements

total_zeroes_before_percentage = total_zeroes_before / total_elements

total_ones_after_percentage = total_ones_after / total_elements

total_zeroes_after_percentage = total_zeroes_after / total_elements

#%%
# example_vector = array([-4,8,9,10]).astype(np.int8)

# convert_to_diff_vector(example_vector)
# before_encode_vector = convert_vector_to_bit_width(8, example_vector)

# vector_ones,vector_zeroes = count_ones_and_zeroes(before_encode_vector)

# new_vector = deepcopy(before_encode_vector)

# # Tranpose
# new_vector = new_vector.T

# xor_bp_vector(new_vector)
# bp_ones,bp_zeroes = count_ones_and_zeroes(new_vector)
