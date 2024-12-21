# use numba
from numba import njit
from numpy import array
import numpy as np

# Given a vector, set the first element of the vector as base, keep its value
# Subtract all the value from the base, and return the new vector
# @njit
def convert_to_diff_vector(vector):
    base = vector[0]
    # Except the first value, subtract all the other value from the base for the
    # current vector
    for i in range(1, len(vector)):
        vector[i] = vector[i] - base

# Given a 2D numpy array, for each row, perform xor operation with the current row+1
# and replace the current row with the result
@njit
def xor_bp_vector(vector):
    for i in range(1,len(vector)-1):
        vector[i] = vector[i] ^ vector[i+1]

# Given the vector, convert the vector back to the original vector using xor operation
@njit
def xor_decode_bp_vector(vector):
    for i in range(len(vector)-2, 0, -1):
        vector[i] = vector[i] ^ vector[i+1]

# Give me a function , given the bit width, converts the integer according to the bit width
# and return its two's complement binary representation
@njit
def convert_to_bit_width(bit_width, integer):
    # Instead of using built in bin function, make bit_width another vector, with
    # each slot storing 0 or 1
    # Use numpy array to store the binary representation
    binary = array([0] * bit_width).astype(np.int8)
    # Find the two's complement binary representation of the integer
    if integer < 0:
        integer = 2**bit_width + integer
    # Convert the integer to binary
    for i in range(bit_width):
        binary[bit_width-i-1] = integer % 2
        integer = integer // 2

    return binary

def convert_vector_to_bit_width(bit_width, vector):
    # Replace the element of the vector with the two's complement binary representation
    # Create a 2D array to store the new vector of type int8
    # new_vector = array([array([0] * bit_width) for i in range(len(vector))])
    new_vector = np.zeros((len(vector), bit_width), dtype=np.int8)

    for i in range(len(vector)):
        new_vector[i] = convert_to_bit_width(bit_width, vector[i])

    return new_vector

# Give me a function which counts the number of ones and number of zeroes in the vector
@njit
def count_ones_and_zeroes_2d(vector):
    ones = 0
    zeroes = 0
    for i in range(len(vector)):
        # Each element of vector is another 1D array
        for j in range(len(vector[i])):
            if vector[i][j] == 1:
                ones += 1
            else:
                zeroes += 1

    return ones, zeroes

@njit
def count_ones_and_zeroes_1D(vector):
    ones = 0
    zeroes = 0
    for i in range(len(vector)):
        if vector[i] == 1:
            ones += 1
        else:
            zeroes += 1

    return ones, zeroes

# Give me a function which generates a normal distribution of int8 given
# The number of samples and the mean and standard deviation
@njit
def generate_normal_distribution_int8(num_samples, mean, std,seed):
    np.random.seed(seed)
    # Generate the normal distribution
    normal_distribution = np.random.normal(mean, std, num_samples)
    # Round the normal distribution to the nearest integer
    normal_distribution = np.round(normal_distribution)
    # Convert the normal distribution to int8
    normal_distribution = normal_distribution.astype(np.int8)
    return normal_distribution

def float16_to_binary(fp16_value):
    # Convert the float16 value to bytes
    fp16_bytes = fp16_value.tobytes()

    # Convert the bytes into a 16-bit integer using np.frombuffer
    binary_value = np.frombuffer(fp16_bytes, dtype=np.uint16)[0]

    # Convert the integer to a 16-bit binary string
    binary_str = format(binary_value, '016b')

    # Convert the binary string to a numpy array of 0,1 of type int8
    binary_str = np.array([int(i) for i in binary_str], dtype=np.int8)

    return binary_str


# Convert the whole vectors to binary
def convert_fp16_vector_to_binary(vector):
    binary_vector = np.zeros((len(vector), 16), dtype=np.int8)

    for i in range(len(vector)):
        binary_vector[i] = float16_to_binary(vector[i])

    return binary_vector



# Give me a function which generates the float16 numbers from a gaussian
# random distribution with given mean and standard deviation with the needed samples
def generate_normal_distribution_fp16(num_samples, mean, std,seed):
    np.random.seed(seed)
    # Generate the normal distribution
    normal_distribution = np.random.normal(mean, std, num_samples)
    # Convert the normal distribution to float16
    normal_distribution = normal_distribution.astype(np.float16)

    return normal_distribution

# Give me a function which genreates uniform distribution of float16 numbers
def generate_uniform_distribution_fp16(num_samples, low, high,seed):
    np.random.seed(seed)
    # Generate the uniform distribution
    uniform_distribution = np.random.uniform(low, high, num_samples)
    # Convert the uniform distribution to float16
    uniform_distribution = uniform_distribution.astype(np.float16)

    return uniform_distribution
