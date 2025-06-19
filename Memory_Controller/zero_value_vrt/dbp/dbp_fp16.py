from helperFucntions import *
import struct
import matplotlib.pyplot as plt

example_vector = array([-3.2,4.1,5.5]).astype(np.float16)

samples = 2**20
seed = 123
std = 0.5

# dis = generate_normal_distribution_fp16(samples, 0, std, seed=seed)

dis = generate_uniform_distribution_fp16(samples,0,1,seed=seed)

# Take out a group of data
num_of_elements_in_groups = 64

# plot it
plt.hist(dis, bins=1000)
plt.show()

# 1. Takes difference vector from each group Base Delta Immediate
for i in range(0,len(dis),num_of_elements_in_groups):
    group = dis[i:i+num_of_elements_in_groups]

    # Take the difference vector for each group
    # convert_to_diff_vector(group)

    # Store it back to the original dataset
    dis[i:i+num_of_elements_in_groups] = group

# Convert the dis to binary representation
dis_binary = convert_fp16_vector_to_binary(dis)

total_ones_before = 0
total_zeroes_before = 0

for i in range(len(dis)):
    vector_ones, vector_zeroes = count_ones_and_zeroes_1D(dis_binary[i])
    total_ones_before += vector_ones
    total_zeroes_before += vector_zeroes

total_ones_after = 0
total_zeroes_after = 0
for i in range(0, len(dis), num_of_elements_in_groups):
    group = dis_binary[i:i+num_of_elements_in_groups]

    # Bit plane tranpose
    # Tranpose the vector
    # group.T

    # Take the [1:5] binary out from each vector in the group
    # XOR the vectors
    xor_bp_vector(group)

    # Count the number of ones and zeroes in the group
    bp_ones, bp_zeroes = count_ones_and_zeroes_2d(group)

    total_ones_after += bp_ones
    total_zeroes_after += bp_zeroes

# The percentage of ones in the dataset before encoding
percentage_ones_before = total_ones_before / (total_ones_before + total_zeroes_before) * 100

# The percentage of ones in the dataset after encoding
percentage_ones_after = total_ones_after / (total_ones_after + total_zeroes_after) * 100

# Percentage of zeroes
percentage_zeroes_before = total_zeroes_before / (total_ones_before + total_zeroes_before) * 100

percentage_zeroes_after = total_zeroes_after / (total_ones_after + total_zeroes_after) * 100
