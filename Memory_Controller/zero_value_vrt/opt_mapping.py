from ultils_functions import *
import numpy as np
import matplotlib.pyplot as plt
import pygad

# main
# set random seed
np.random.seed(1234)
n = 2**20
mean = 0
std = 10
bits_for_repre = 8

generated_data = generate_random_dataset(n, mean, std)
plt.hist(generated_data, bins=100)
plt.show()
#%%
# Counts the number of each element in the dataset
unique, counts = np.unique(generated_data, return_counts=True)

# Converts each value of unique to a string representation
unique = [str(i) for i in unique]

# Create a dictionary of the counts
count_dict = dict(zip(unique, counts))

# Add a new element to each dictionary entry
for key in count_dict:
    count_dict[key] = [count_dict[key], 0] # [counts, new_value]

#%%
total_zeroes, total_ones = count_zero_one(count_dict, bits_for_repre, n)

#%%

# Choose the new representation of the values for each key in the dictionary
# store it in the new_value, the value must not repeat

# Sort the dictionary by the number of occurences
sorted_dict = dict(sorted(count_dict.items(), key=lambda item: item[1][0], reverse=True))

# Converts the key value back to integer and declare a new dataset as an array
new_dataset = np.zeros(n)

# (value, frequency , new_value) list
value_list = [[int(key), sorted_dict[key][0], sorted_dict[key][1]] for key in sorted_dict]

#%%
# Run genetic algorithm to find the best new values for each key
# Fitness function is the number of zeroes in the new dataset representation
ideal_outputs = n*8

# Define the function inputs as the number of each element in the dataset
function_inputs = [i[1] for i in value_list]

# Solution is an array of new values for each key
def fitness_func(ga_instance, solution, solution_idx):
    # Calculate the number of zeroes in the new dataset representation
    num_of_zeroes = 0

    # Since it is sorted, the solution is the new value for each key in sorted order
    for i in range(len(solution)):
        # number of zeroes of the element of solution
        binary = np.binary_repr(solution[i], width=bits_for_repre)
        num_of_zeroes += function_inputs[i] * np.sum([1 for j in binary if j == '0'])

    fitness = 1/np.abs(num_of_zeroes - ideal_outputs)
    return fitness

fitness_function = fitness_func
#%%

# Define the gene space to limit values between -128 and 127
gene_space = list(range(-128, 128))

# Define an initial population with unique values for each solution
def generate_initial_population(sol_per_pop, num_genes, gene_space):
    initial_population = []
    for _ in range(sol_per_pop):
        np.random.shuffle(gene_space)
        initial_population.append(gene_space[:num_genes])
    return np.array(initial_population)

sol_per_pop = 50  # Number of solutions in the population
num_genes = len(function_inputs)

initial_population = generate_initial_population(sol_per_pop, num_genes, gene_space)

# Define a custom mutation function to ensure unique values
def custom_mutation(offspring, ga_instance):
    # I want the mutation to be simply swapping values within a certain offspring
    for idx in range(len(offspring)):
        # A value between 0 and 1 to determine if mutation should occur
        swap_probability = np.random.rand()
        change_probability = np.random.rand()

        if swap_probability > ga_instance.mutation_probability:
            # Choose two random indices to swap
            idx1, idx2 = np.random.choice(range(len(offspring[idx])), 2, replace=False)
            # Swap the values
            offspring[idx][idx1], offspring[idx][idx2] = offspring[idx][idx2], offspring[idx][idx1]

        if change_probability > ga_instance.mutation_probability:
            # Choose a random index to change
            offspring_idx = np.random.choice(range(len(offspring[idx])))
            # Choose a new value for the index
            new_value = np.random.choice(ga_instance.gene_space)

            # Check if the new value is not in the offspring
            while new_value in offspring[idx]:
                new_value = np.random.choice(ga_instance.gene_space)

            offspring[idx][offspring_idx] = new_value

    return offspring

# Custom crossOver function, the value must not repeat
# For example [0,2,1,3] and [1,3,0,2] the crossover will only have unique values

# From the parents, the offspring will inherit the values from the parents
# First selects from the first parent, then the second parent
# Add the value to the offspring if it is not already in the offspring
# Add until the offspring is full

# Define a custom crossover function to ensure unique values
def custom_crossover(parents, offspring_size, ga_instance):
    offspring = np.zeros(offspring_size, dtype=int)
    for i in range(offspring_size[0]):
        parent1_idx = i % parents.shape[0]
        parent2_idx = (i + 1) % parents.shape[0]
        parent1 = parents[parent1_idx]
        parent2 = parents[parent2_idx]

        # The offspring will inherit the values from the parents
        # First selects from the first parent, then the second parent
        # Add the value to the offspring if it is not already in the offspring
        # Add until the offspring is full
        used_values = set()
        for j in range(len(parent1)):
            if parent1[j] not in used_values:
                offspring[i][j] = parent1[j]
                used_values.add(parent1[j])
            elif parent2[j] not in used_values:
                offspring[i][j] = parent2[j]
                used_values.add(parent2[j])
            else:
                # If both parents' genes are already used, find a unique value from gene_space
                for value in gene_space:
                    if value not in used_values:
                        offspring[i][j] = value
                        used_values.add(value)
                        break

    return offspring

#%%

sol_per_pop = 50 # Number of solutions in the population.
num_genes = len(function_inputs)

mutation_func = custom_mutation # Swap mutation

# Set up the GA instance
ga_instance = pygad.GA(
    num_generations=3000,
    num_parents_mating=10,
    fitness_func=fitness_func,
    sol_per_pop=50,
    num_genes=num_genes,
    gene_space=gene_space,
    mutation_type=mutation_func,
    initial_population=initial_population,
    crossover_type=custom_crossover,
    mutation_probability=0.2,
    parallel_processing=4,
    gene_type=int# Ensure genes are integers
)

#%%

# Running the GA to optimize the parameters of the function.
ga_instance.run()


#%%

# After the generations complete, some plots are showed that summarize the how the outputs/fitenss values evolve over generations.
ga_instance.plot_fitness()

# Returning the details of the best solution.
solution, solution_fitness, solution_idx = ga_instance.best_solution()
print(f"Parameters of the best solution : {solution}")
print(f"Fitness value of the best solution = {solution_fitness}")
print(f"Index of the best solution : {solution_idx}")

# Find the number of zeroes from the solution
num_of_zeroes = 0
for i in range(len(solution)):
    binary = np.binary_repr(solution[i], width=bits_for_repre)
    num_of_zeroes += function_inputs[i] * np.sum([1 for j in binary if j == '0'])

prediction = np.sum(num_of_zeroes)
print(f"Predicted output based on the best solution : {num_of_zeroes}")

if ga_instance.best_solution_generation != -1:
    print(f"Best fitness value reached after {ga_instance.best_solution_generation} generations.")

# Saving the GA instance.
filename = 'genetic' # The filename to which the instance is saved. The name is without extension.
ga_instance.save(filename=filename)

# Loading the saved GA instance.
loaded_ga_instance = pygad.load(filename=filename)
loaded_ga_instance.plot_fitness()


#%%
# Attach the solution to sorted_dict
for i in range(len(solution)):
    sorted_dict[str(value_list[i][0])][1] = solution[i]

# Find zeroes and ones in the sorted_dict
total_zeroes, total_ones = count_zero_one_mapped(sorted_dict, bits_for_repre, n)

# Print out total zeroes and ones
print(f"Total zeroes in the dataset: {total_zeroes}")
print(f"Total ones in the dataset: {total_ones}")

#%%
