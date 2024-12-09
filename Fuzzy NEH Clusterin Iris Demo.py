import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.metrics import silhouette_score
from sklearn.decomposition import PCA

# Load the Iris dataset
data = load_iris()
X = data.data
n_clusters = 3  # Number of clusters

# Fuzzy BEH Clustering Algorithm
def fuzzy_beh_clustering(data, n_clusters, n_pop=10, max_iter=200, damage_rate=0.2, mutation_strength=0.1):
    n_samples, n_features = data.shape
    n_beeeater = round(damage_rate * n_pop)
    n_new = n_pop - n_beeeater
    peak_power = 0.8
    adjust_power = 0.03
    pyr = -0.2

    # Initialize population
    population = []
    for _ in range(n_pop):
        centers = np.random.uniform(data.min(axis=0), data.max(axis=0), (n_clusters, n_features))
        membership = np.random.dirichlet(np.ones(n_clusters), n_samples)
        cost = fuzzy_cluster_cost(data, centers, membership)
        population.append({'Centers': centers, 'Membership': membership, 'Cost': cost})

    # Sort population
    population.sort(key=lambda bee: bee['Cost'])
    best_solution = population[0]
    best_costs = []

    for iteration in range(max_iter):
        # Generate new population
        new_population = []
        for bee in population[:n_beeeater]:
            new_bee = {
                'Centers': np.copy(bee['Centers']),
                'Membership': np.copy(bee['Membership']),
                'Cost': None
            }
            for k in range(n_clusters):
                # Update cluster centers
                movement = peak_power * (np.random.uniform(data.min(axis=0), data.max(axis=0)) - bee['Centers'][k])
                new_bee['Centers'][k] += movement

                # Mutation
                if np.random.rand() < mutation_strength:
                    new_bee['Centers'][k] += pyr + adjust_power * np.random.randn(n_features)

            # Update membership
            new_bee['Membership'] = update_membership(data, new_bee['Centers'])

            # Calculate cost
            new_bee['Cost'] = fuzzy_cluster_cost(data, new_bee['Centers'], new_bee['Membership'])
            new_population.append(new_bee)

        # Merge and sort
        population = sorted(population[:n_beeeater] + new_population, key=lambda bee: bee['Cost'])[:n_pop]
        best_solution = population[0]
        best_costs.append(best_solution['Cost'])

        print(f"Iteration {iteration + 1}, Best Cost: {best_solution['Cost']}")

    return best_solution, best_costs

# Cost function for fuzzy clustering
def fuzzy_cluster_cost(data, centers, membership):
    cost = 0
    for i, x in enumerate(data):
        for j, center in enumerate(centers):
            cost += (membership[i, j] ** 2) * np.linalg.norm(x - center) ** 2
    return cost

# Update membership matrix
def update_membership(data, centers):
    n_samples, n_features = data.shape
    n_clusters = centers.shape[0]
    membership = np.zeros((n_samples, n_clusters))

    for i, x in enumerate(data):
        distances = np.linalg.norm(x - centers, axis=1)
        for j in range(n_clusters):
            membership[i, j] = 1 / np.sum((distances[j] / distances) ** 2)

    return membership

# Run Fuzzy BEH Clustering on Iris data
best_solution, best_costs = fuzzy_beh_clustering(X, n_clusters)

# Plot cost over iterations
plt.figure(figsize=(8, 6))
plt.plot(best_costs, label='Cost')
plt.xlabel('Iterations')
plt.ylabel('Cost')
plt.title('Fuzzy BEH Clustering Optimization')
plt.grid()
plt.legend()
plt.show()

# Project data to 2D using PCA for visualization
pca = PCA(n_components=2)
X_2D = pca.fit_transform(X)
final_membership = best_solution['Membership']
cluster_labels = np.argmax(final_membership, axis=1)

# Project cluster centers to the PCA space
centers_2D = pca.transform(best_solution['Centers'])

# Plot the clustering results
plt.figure(figsize=(8, 6))
for i in range(n_clusters):
    cluster_points = X_2D[cluster_labels == i]
    plt.scatter(cluster_points[:, 0], cluster_points[:, 1], label=f'Cluster {i + 1}')

plt.scatter(centers_2D[:, 0], centers_2D[:, 1], 
            color='black', marker='x', s=100, label='Cluster Centers')
plt.title('Fuzzy BEH Clustering Results on Iris Dataset')
plt.xlabel('PCA Component 1')
plt.ylabel('PCA Component 2')
plt.legend()
plt.grid()
plt.show()


# Evaluate clustering performance using silhouette score
sil_score = silhouette_score(X, cluster_labels)
print(f'Silhouette Score: {sil_score}')
