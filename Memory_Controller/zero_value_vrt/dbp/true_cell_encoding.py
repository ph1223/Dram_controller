from helperFucntions import *

# Give me a vectors with int8 values
vector = np.array([-1,1,3,4]).astype(np.int8)

# Take difference vector
convert_to_diff_vector(vector)

# Convert whole vector into binary
binary_vector = convert_vector_to_bit_width(8, vector)

# Convert binary vector using true cell encoding with given bit width
def true_cell_encoding(bit_width,in_vector):
    # Rules for true cell encoding
    encoding_dict = {}

    numbers_to_encode = 0
    encoded_value = 0

    while numbers_to_encode < (2**bit_width):
        encoding_dict[encoded_value] = numbers_to_encode

        if encoded_value >= 0:
            encoded_value += 1
            encoded_value = -encoded_value
        else:
            encoded_value = -encoded_value

        numbers_to_encode += 1

    for element in in_vector:
        in_vector[element] = encoding_dict[element]

true_cell_encoding(4, vector)
