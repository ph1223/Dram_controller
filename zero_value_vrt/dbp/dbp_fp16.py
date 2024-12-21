from helperFucntions import *
import struct

example_vector = array([-3.2,4.1,5.5]).astype(np.float16)

import numpy as np

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

# Test with both positive and negative values
positive_value = np.float16(3.14)
negative_value = np.float16(-3.14)

# Convert to binary
positive_binary = float16_to_binary(positive_value)
negative_binary = float16_to_binary(negative_value)

print(f"Positive value binary: {positive_binary}")
print(f"Negative value binary: {negative_binary}")
