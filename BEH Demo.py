import numpy as np
import matplotlib.pyplot as plt

# Define test functions
def ackley(x):
    a = 20
    b = 0.2
    c = 2 * np.pi
    n = len(x)
    sum1 = np.sum(x**2)
    sum2 = np.sum(np.cos(c * x))
    return -a * np.exp(-b * np.sqrt(sum1 / n)) - np.exp(sum2 / n) + a + np.exp(1)

def beale(x):
    x1, x2 = x
    return (1.5 - x1 + x1 * x2)**2 + (2.25 - x1 + x1 * x2**2)**2 + (2.625 - x1 + x1 * x2**3)**2

def booth(x):
    x1, x2 = x
    return (x1 + 2 * x2 - 7)**2 + (2 * x1 + x2 - 5)**2

def rastrigin(x):
    A = 10
    n = len(x)
    return A * n + np.sum(x**2 - A * np.cos(2 * np.pi * x))

# Bee-Eater Hunting Algorithm
def bee_eater_optimizer(cost_function, var_min, var_max, n_var, max_iter, n_pop, damage_rate=0.2, mutation_strength=0.1):
    # Initialize parameters
    n_beeeater = round(damage_rate * n_pop)
    n_new = n_pop - n_beeeater
    peak_power = 0.8
    adjust_power = 0.03 * (var_max - var_min)
    pyr = -0.2

    population = [{'Position': np.random.uniform(var_min, var_max, n_var), 'Cost': None} for _ in range(n_pop)]
    for bee in population:
        bee['Cost'] = cost_function(bee['Position'])

    population.sort(key=lambda bee: bee['Cost'])
    best_solution = population[0]
    best_costs = []

    for iteration in range(max_iter):
        # Generate new population
        new_population = []
        for bee in population[:n_beeeater]:
            new_bee = {'Position': np.copy(bee['Position']), 'Cost': None}
            for k in range(n_var):
                # Calculate movement
                movement = peak_power * (np.random.uniform(var_min, var_max) - bee['Position'][k])
                new_bee['Position'][k] += movement
                # Mutation
                if np.random.rand() < mutation_strength:
                    new_bee['Position'][k] += pyr + adjust_power * np.random.randn()

            # Apply bounds and evaluate cost
            new_bee['Position'] = np.clip(new_bee['Position'], var_min, var_max)
            new_bee['Cost'] = cost_function(new_bee['Position'])
            new_population.append(new_bee)

        # Merge and sort
        population = sorted(population[:n_beeeater] + new_population, key=lambda bee: bee['Cost'])[:n_pop]
        best_solution = population[0]
        best_costs.append(best_solution['Cost'])

        # Log progress
        print(f"Iteration {iteration + 1}, Best Cost: {best_solution['Cost']}")

    return best_costs

# Parameters
n_var = 20
var_min = -5
var_max = 5
max_iter = 500
n_pop = 10

# Run for all functions
functions = [ackley, beale, booth, rastrigin]
labels = ["Ackley", "Beale", "Booth", "Rastrigin"]
dimensions = [10, 2, 2, 10]
bounds = [(-5, 5), (-4.5, 4.5), (-10, 10), (-5.12, 5.12)]
results = []

for cost_function, label, dim, bound in zip(functions, labels, dimensions, bounds):
    print(f"Running BEH for {label}")
    var_min, var_max = bound
    costs = bee_eater_optimizer(cost_function, var_min, var_max, dim, max_iter, n_pop)
    results.append(costs)

# Plot results in a 2x2 grid
fig, axs = plt.subplots(2, 2, figsize=(12, 10))

for i, (costs, label) in enumerate(zip(results, labels)):
    ax = axs[i // 2, i % 2]
    ax.plot(costs)
    ax.set_title(label)
    ax.set_xlabel("Iteration")
    ax.set_ylabel("Cost")
    ax.grid()

plt.tight_layout()
plt.show()
