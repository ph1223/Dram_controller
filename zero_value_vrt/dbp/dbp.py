from helperFucntions import *
#deep copy
from copy import deepcopy
# matplotlib
import matplotlib.pyplot as plt

# Give me a function which generates a normal distribution of int8 given
# The number of samples and the mean and standard deviation
@njit
def generate_normal_distribution_int8(num_samples, mean, std):
    # Generate the normal distribution
    normal_distribution = np.random.normal(mean, std, num_samples)
    # Round the normal distribution to the nearest integer
    normal_distribution = np.round(normal_distribution)
    # Convert the normal distribution to int8
    normal_distribution = normal_distribution.astype(np.int8)
    return normal_distribution

samples = 1000
mean = 0
std = 20

distribution = generate_normal_distribution_int8(samples, mean, std)

# Plot this dsitribution
plt.hist(distribution, bins=20)
plt.show()






#%%
example_vector = array([-4,8,9,10]).astype(np.int8)

convert_to_diff_vector(example_vector)
before_encode_vector = convert_vector_to_bit_width(8, example_vector)

vector_ones,vector_zeroes = count_ones_and_zeroes(before_encode_vector)

new_vector = deepcopy(before_encode_vector)

# Tranpose
new_vector = new_vector.T

xor_bp_vector(new_vector)
bp_ones,bp_zeroes = count_ones_and_zeroes(new_vector)
