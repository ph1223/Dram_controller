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

def count_zero_one(dataset,bit_width,size_of_dataset):
    # dataset is a dictionary
    # Find the total number of zeros in the dataset of count_dict
    total_zeroes = 0
    total_ones   = 0

    # Converts the key value back to integer, then to binary, and counts the number of zeroes
    for key in dataset:
        value = int(key)
        binary = np.binary_repr(value, width=bit_width)
        total_zeroes += dataset[key][0] * np.sum([1 for j in binary if j == '0'])
        total_ones += dataset[key][0] * np.sum([1 for j in binary if j == '1'])

    assert total_zeroes + total_ones == size_of_dataset*8

    total_bits = size_of_dataset*8
    percentage_ones = total_ones / total_bits * 100
    percentage_zeroes = total_zeroes / total_bits * 100
    print("Percentage of ones in the dataset: ", percentage_ones)
    print("Percentage of zeroes in the dataset: ", percentage_zeroes)

    return total_zeroes, total_ones


def count_zero_one_mapped(dataset,bit_width,size_of_dataset):
    # dataset is a dictionary
    # Find the total number of zeros in the dataset of count_dict
    total_zeroes = 0
    total_ones   = 0

    # Converts the key value back to integer, then to binary, and counts the number of zeroes
    for key in dataset:
        value = dataset[key][1] # mapped new value
        binary = np.binary_repr(value, width=bit_width)
        total_zeroes += dataset[key][0] * np.sum([1 for j in binary if j == '0'])
        total_ones += dataset[key][0] * np.sum([1 for j in binary if j == '1'])

    assert total_zeroes + total_ones == size_of_dataset*8

    total_bits = size_of_dataset*8
    percentage_ones = total_ones / total_bits * 100
    percentage_zeroes = total_zeroes / total_bits * 100
    print("Percentage of ones in the dataset: ", percentage_ones)
    print("Percentage of zeroes in the dataset: ", percentage_zeroes)

    return total_zeroes, total_ones