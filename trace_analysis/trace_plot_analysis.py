# Please read in .txt files and plot the data in the files

import numpy as np
import matplotlib.pyplot as plt


# Read in the data from the .txt file

data = np.loadtxt('bandwidth_record_ideal.txt')
# data = np.loadtxt('bandwidth_record_worst_case.txt')

# For every 30 data points, take the average and make a new averaged data array
new_data = []
for i in range(0, len(data), 30):
    new_data.append(np.mean(data[i:i+30]))

data = new_data

# Create the x-axis cycles
cycles = np.arange(0, len(data), 1)

# Plot the data
plt.plot(cycles, data, label='Bandwidth')

# Add a title
plt.title('Ideal Sequential Trace Bandwidth')
# plt.title('Worst Case Trace Bandwidth')

# x label
plt.xlabel('Cycles*500')

# Plot the line connecting the points
# Bandwidth
plt.ylabel('Bandwidth (GB/s)')

plt.show()
