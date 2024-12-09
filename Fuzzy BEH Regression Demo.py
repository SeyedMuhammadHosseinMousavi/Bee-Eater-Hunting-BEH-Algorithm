import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.metrics import mean_squared_error, r2_score

# Load Iris dataset
data = load_iris()
X = data.data[:, 1:]  # Using petal length, petal width, and sepal width as predictors
y = data.data[:, 0]   # Predicting sepal length
degree = 2            # Degree of polynomial regression

# Create polynomial features
def polynomial_features(X, degree):
    n_samples, n_features = X.shape
    features = [np.ones(n_samples)]  # Bias term
    for d in range(1, degree + 1):
        for i in range(n_features):
            features.append(X[:, i] ** d)
    return np.vstack(features).T

X_poly = polynomial_features(X, degree)

# Cost function for regression
def regression_cost(weights, X, y):
    predictions = X @ weights
    return np.mean((y - predictions) ** 2)

# Fuzzy BEH Regression Algorithm
def fuzzy_beh_regression(X, y, n_pop=10, max_iter=200, damage_rate=0.2, mutation_strength=0.1):
    n_features = X.shape[1]
    n_beeeater = round(damage_rate * n_pop)
    n_new = n_pop - n_beeeater
    peak_power = 0.8
    adjust_power = 0.03
    pyr = -0.2

    # Initialize population
    population = []
    for _ in range(n_pop):
        weights = np.random.uniform(-1, 1, n_features)
        cost = regression_cost(weights, X, y)
        population.append({'Weights': weights, 'Cost': cost})

    # Sort population
    population.sort(key=lambda bee: bee['Cost'])
    best_solution = population[0]
    best_costs = []

    for iteration in range(max_iter):
        # Generate new population
        new_population = []
        for bee in population[:n_beeeater]:
            new_bee = {'Weights': np.copy(bee['Weights']), 'Cost': None}
            for i in range(n_features):
                # Update weights
                movement = peak_power * (np.random.uniform(-1, 1) - bee['Weights'][i])
                new_bee['Weights'][i] += movement

                # Mutation
                if np.random.rand() < mutation_strength:
                    new_bee['Weights'][i] += pyr + adjust_power * np.random.randn()

            # Calculate cost
            new_bee['Cost'] = regression_cost(new_bee['Weights'], X, y)
            new_population.append(new_bee)

        # Merge and sort
        population = sorted(population[:n_beeeater] + new_population, key=lambda bee: bee['Cost'])[:n_pop]
        best_solution = population[0]
        best_costs.append(best_solution['Cost'])

        print(f"Iteration {iteration + 1}, Best Cost: {best_solution['Cost']}")

    return best_solution, best_costs

# Run Fuzzy BEH Regression
best_solution, best_costs = fuzzy_beh_regression(X_poly, y)

# Plot cost over iterations
plt.figure(figsize=(8, 6))
plt.plot(best_costs, label='Cost')
plt.xlabel('Iterations')
plt.ylabel('Cost')
plt.title('Fuzzy BEH Regression Optimization')
plt.grid()
plt.legend()
plt.show()

# Evaluate regression performance
final_weights = best_solution['Weights']
y_pred = X_poly @ final_weights
mse = mean_squared_error(y, y_pred)
r2 = r2_score(y, y_pred)

# Plot regression results
plt.figure(figsize=(8, 6))
plt.scatter(range(len(y)), y, label='Actual', alpha=0.7)
plt.scatter(range(len(y_pred)), y_pred, label='Predicted', alpha=0.7)
plt.xlabel('Sample Index')
plt.ylabel('Sepal Length')
plt.title('Fuzzy BEH Regression Results')
plt.legend()
plt.grid()
plt.show()

# Print metrics
print(f"Mean Squared Error (MSE): {mse:.4f}")
print(f"R² Score: {r2:.4f}")
