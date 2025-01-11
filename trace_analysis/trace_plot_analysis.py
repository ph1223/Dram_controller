# Please read in .txt files and plot the data in the files

import numpy as np
import matplotlib.pyplot as plt


# Read in the data from the .txt file

data = np.loadtxt('bandwidth_record_ideal.txt')
# data = np.loadtxt('bandwidth_record_worst_case.txt')

# Find the average of the data
average = np.mean(data)

# Takes only the first 1000 elements
data = data[150:400]

# Create the x-axis cycles
cycles = np.arange(0, len(data), 1)

# Help me find the maximum value in the data
max_value = np.max(data)

# Find the minimum value in the data
min_value = np.min(data)



# Plot the data
plt.plot(cycles, data, label='Bandwidth')

# Plot the average line
plt.axhline(y=average, color='r', linestyle='-', label='Average Bandwidth')

# Plot the maximum value

# plt.axhline(y=max_value, color='g', linestyle='-', label='Max Bandwidth')

# Plot the minimum value
# plt.axhline(y=min_value, color='b', linestyle='-', label='Min Bandwidth')

# Add a title
plt.title('Ideal Sequential Trace Bandwidth')
# plt.title('Worst Case Trace Bandwidth')

# x label
plt.xlabel('Each 500 Cycles')

# Plot the line connecting the points
# Bandwidth
plt.ylabel('Bandwidth (GB/s)')

plt.show()
