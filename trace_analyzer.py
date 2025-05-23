# Generates a scripts that reads in the trace then plots the access data and address cycle by cycle
# and the stall cycles
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Trace file has the following format
# ST 0 0
# LD 0 0
# ST 128 0
# LD 128 0
# <LD/ ST> <address> <stall_cycles>
# The address is the byte address of DRAM

Column_size = 128 #bytes

# Read in the trace file
trace_file = "llm_core_trace.txt"

# Plot the trace with y-axis as address and x-axis as cycle, if the operation is LD then the color is blue, if it is ST then the color is red

def plot_trace(trace_file):
    # Read in the trace file
    with open(trace_file, "r") as f:
        lines = f.readlines()

    # Create a list to store the data
    data = []
    for line in lines:
        # Split the line into its components
        parts = line.split()
        operation = parts[0]
        # Divide the address by the column size to get the address in terms of columns
        address = int(parts[1]) // int(Column_size)
        stall_cycles = int(parts[2])
        data.append((operation, address, stall_cycles))

    # Create a DataFrame from the data
    df = pd.DataFrame(data, columns=["Operation", "Address", "Stall Cycles"])

    # Create a new column for the cycle number
    df["Cycle"] = df.index

    # Create a new column for the color based on the operation
    df["Color"] = np.where(df["Operation"] == "LD", "blue", "red")

    # Plot the data
    plt.figure(figsize=(10, 6))
    plt.scatter(df["Cycle"], df["Address"], c=df["Color"], alpha=0.5)
    plt.xlabel("Cycle")
    plt.ylabel("Address")
    plt.title("Trace Plot")
    plt.grid()
    plt.show()

# Plot the trace
plot_trace(trace_file)
