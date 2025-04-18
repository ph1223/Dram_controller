import pandas as pd
import matplotlib.pyplot as plt

# Read the CSV file
csv_file_path = 'extracted_info.csv'
data = pd.read_csv(csv_file_path, delimiter='\t')

# Display the table
print(data.to_string(index=False))

# Visualize the table
fig, ax = plt.subplots()
ax.axis('tight')
ax.axis('off')
table = ax.table(cellText=data.values, colLabels=data.columns, cellLoc='center', loc='center')

plt.show()
