import random
from math import log2

def generate_st_ld_trace(filename,filename2, num_lines,gen_stall=False):
    address = 0
    with open(filename, 'w') as file,open(filename2,'w') as file2:
        for line in range(num_lines):
            # operation = random.choice(['ST', 'LD'])
            operation = 'LD'
            # generate marching pattern for it, increment the address
            num_of_channels = 4
            row_size = 2**16
            colmun_size = 2**11
            data_channel_size = 1024

            channel_tx_size = int(data_channel_size/8)
            column_partitions = int(colmun_size/channel_tx_size)
            # Generate the address base on these information
            # Ch row col word
            channel_bits = int(log2(num_of_channels))
            row_bits = int(log2(row_size))
            column_bits = int(log2(column_partitions))
            word_bits = int(log2(channel_tx_size))

            # Their concatentation
            # Randomly picks different channel

            gen_channel_num = random.randint(0, num_of_channels-1)
            gen_row_bits    = random.randint(0, row_size-1)
            gen_column_bits = random.randint(0, column_partitions-1)
            gen_byte_bits   = random.randint(0, channel_tx_size-1)

            # Generate the address
            address = (gen_channel_num << (row_bits + column_bits + word_bits)) | (gen_row_bits << (column_bits + word_bits)) | (gen_column_bits << word_bits) | gen_byte_bits
            # address = address + 1

            if(gen_stall==True):
                # stall_cycles = random.randint(0, 10)
                stall_cycles = 1
                file.write(f"{operation} {address} {stall_cycles}\n")
                # Write the value of channel,row,column,word
                file2.write("{0} {1} {2} {3}\n".format(gen_channel_num,gen_row_bits,gen_column_bits,gen_byte_bits))
            else:
                file.write(f"{operation} {address}\n")
                # Write the value of channel,row,column,word
                file2.write("{0} {1} {2} {3}\n".format(gen_channel_num,gen_row_bits,gen_column_bits,gen_byte_bits))

# Parameters
# I want to generate multiple traces files
# I want to generate multiple traces files
num_traces = 8
num_lines = 10000
trace_file_dir = "../traces/"
gen_stall = True

for i in range(num_traces):
    filename = f"{trace_file_dir}trace_{i}.txt"
    filename2 = f"{trace_file_dir}trace_{i}_address.txt"
    generate_st_ld_trace(filename,filename2,num_lines,gen_stall)
    print(f"Generated trace file: {filename}")
    print(f"Generated trace file: {filename2}")