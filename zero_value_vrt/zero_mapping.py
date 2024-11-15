import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as opt

# Generate a random dataset with a certain value representation, for example int8, from gaussian distribution
def generate_random_dataset(n, mean, std):
    dataset = np.random.normal(mean, std, n)
    dataset = np.round(dataset)
    dataset = np.clip(dataset, -127, 128)  # Clip values to be within -127 and 128
    dataset = dataset.astype(int)
    return dataset

# Turn all the values in dataset into binary representation, and count the number of zeros for the binary representation
# of the dataset, sum them up
def count_zeros(dataset):
    # convert dataset into integer
    dataset = dataset.astype(int)

    num_of_zeros = 0
    for i in range(len(dataset)):
        binary = np.binary_repr(dataset[i], width=8)
        num_of_zeros += np.sum([1 for j in binary if j == '0'])

    return num_of_zeros

# Count the number of ones in the binary representation of the dataset
def count_ones(dataset):
    # convert dataset into integer
    dataset = dataset.astype(int)
    num_of_ones = 0
    for i in range(len(dataset)):
        binary = np.binary_repr(dataset[i], width=8)
        num_of_ones += np.sum([1 for j in binary if j == '1'])

    return num_of_ones

# main
# set random seed
np.random.seed(0)
n = 100
mean = np.random.randint(-30,30)
std = 15

# Generate a random dataset
dataset = generate_random_dataset(n, mean, std)
# print(dataset)
plt.hist(dataset, bins=100)
plt.show()

# From the dataset, for every values, turn it into a binary representation, count the number of total
# 0s
zeros = count_zeros(dataset)
print("Number of zeros in the dataset: ", zeros)

ones = count_ones(dataset)
print("Number of ones in the dataset: ", ones)


# Method1, according to rankings of the frequency of the values in the dataset
# From the dataset, count the frequency of each value
unique, counts = np.unique(dataset, return_counts=True)
frequency = dict(zip(unique, counts))

# sort the frequency by the number of occurences
sorted_frequency = dict(sorted(frequency.items(), key=lambda item: item[1], reverse=True))

# Now remap the values in the dataset to a new value, where the value with the highest frequency will be remapped to 0
# second maps to 1, third maps to 2, and so on
# and the value with the lowest frequency will be remapped to 255

# remap the values in the dataset
remapped_dataset = np.zeros(n)
for i in range(n):
    remapped_dataset[i] = list(sorted_frequency.keys()).index(dataset[i])

# print(remapped_dataset)
plt.hist(remapped_dataset, bins=100)
plt.show()

# Count the number of zeroes in the remapped dataset
remapped_zeros = count_zeros(remapped_dataset)
print("Number of zeros in the remapped dataset: ", remapped_zeros)

remapped_ones = count_ones(remapped_dataset)
print("Number of ones in the remapped dataset: ", remapped_ones)

# Method 2, find the best mapping that minimizes the number of 1s in the binary representation of the dataset
# Goal is to find the best mapping, such that the number of 1s in the binary representation of the dataset is minimized
# The mapping is a vector of 256 values, where the index of the vector is the original value in the dataset, and the value
# the mapping has to be 1-1, and the values in the mapping has to be between 0 and 255

# Define objective function, I want to minimize the number of 1s in the binary representation of the dataset
def objective(x, dataset):
    # convert dataset into integer
    dataset = dataset.astype(int)

    # the x should also be type integer
    x = x.astype(int)

    num_of_ones = 0
    for i in range(len(dataset)):
        binary = np.binary_repr(x[dataset[i]], width=8)
        num_of_ones += np.sum([1 for j in binary if j == '1'])

    return num_of_ones

# Define the constraints, int8 values, so between -127 and 128, and the mapping has to be 1-1
def constraint(x):
    return x - 128

# initial guess
x0 = np.arange(256)


# optimize the mapping
result = opt.minimize(objective, x0, args=(dataset,), constraints={'type': 'ineq', 'fun': constraint})

# print the result
# print("Optimal mapping: ", result.x)

# remap the dataset
remapped_dataset = np.zeros(n)
for i in range(n):
    remapped_dataset[i] = result.x[dataset[i]]

# print(remapped_dataset)

plt.hist(remapped_dataset, bins=100)
plt.show()

# Count the number of zeroes in the remapped dataset
remapped_zeros = count_zeros(remapped_dataset)
print("Number of zeros in the remapped dataset: ", remapped_zeros)

remapped_ones = count_ones(remapped_dataset)
print("Number of ones in the remapped dataset: ", remapped_ones)
