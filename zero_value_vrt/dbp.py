#%%
# use numba
from numba import njit
from numpy import array

# import copy function
from copy import deepcopy

# example_vector = [-4,8,9,10]
example_vector = array([-4,8,9,10])

# Give me a function , given the bit width, converts the integer according to the bit width
# and return its two's complement binary representation
def convert_to_bit_width(bit_width, integer):
    # Instead of using built in bin function, make bit_width another vector, with
    # each slot storing 0 or 1
    # Use numpy array to store the binary representation
    binary = array([0] * bit_width)
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
    # Create a 2D array to store the new vector
    new_vector = array([array([0] * bit_width) for i in range(len(vector))])

    for i in range(len(vector)):
        new_vector[i] = convert_to_bit_width(bit_width, vector[i])

    return new_vector

# Given a vector, set the first element of the vector as base, keep its value
# Subtract all the value from the base, and return the new vector
def convert_to_diff_vector(vector):
    base = vector[0]
    # Except the first value, subtract all the other value from the base for the
    # current vector
    for i in range(1, len(vector)):
        vector[i] = vector[i] - base

# Given a 2D numpy array, for each row, perform xor operation with the current row+1
# and replace the current row with the result
def xor_bp_vector(vector):
    new_vector = deepcopy(vector)
    for i in range(len(vector)-1):
        new_vector[i] = new_vector[i] ^ new_vector[i+1]

    return new_vector

# Given the vector, convert the vector back to the original vector using xor operation
def xor_decode_bp_vector(vector):
    new_vector = deepcopy(vector)
    for i in range(len(vector)-2, -1, -1):
        new_vector[i] = new_vector[i] ^ new_vector[i+1]

    return new_vector

convert_to_diff_vector(example_vector)
new_vector = convert_vector_to_bit_width(8, example_vector)

# Tranpose
new_vector = new_vector.T

#%%
xor_result_vector = xor_bp_vector(new_vector)

xor_back_result_vector = xor_decode_bp_vector(xor_result_vector)
