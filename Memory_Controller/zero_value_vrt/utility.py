import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt

# Try spanning through
# Generate a random dataset with a certain value representation, for example int8, from gaussian distribution
def generate_random_dataset(n, mean, std):
    dataset = np.random.normal(mean, std, n)
    # Use other distribution
    # dataset = np.random.laplace(mean, std, n)

    # Other distribution
    # dataset = np.random.uniform(mean, std, n)

    # Other distribution that support negative values
    # dataset = np.random.logistic(mean, std, n)

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


# Given a bit width, give me the upper bound and lower bound of the its integer representation
def get_bounds(bit_width):
    lower_bound = -2**(bit_width-1)
    upper_bound = 2**(bit_width-1) - 1
    return lower_bound, upper_bound

# Given a value, find the minimum number of bits required to represent the value
def get_num_bits(value):
    return len(np.binary_repr(value))
