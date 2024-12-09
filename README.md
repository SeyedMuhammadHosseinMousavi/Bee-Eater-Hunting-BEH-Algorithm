Introducing Bee-Eater Hunting Strategy Algorithm for IoT-Based Green House Monitoring and Analysis
### Bee-Eater Hunting Algorithm (BEH)
### Link to the paper:
- https://ieeexplore.ieee.org/abstract/document/9953726
- DOI: 10.1109/SCIoT56583.2022.9953726
### Please cite below:
- Mousavi, Seyed Muhammad Hossein. "Introducing bee-eater hunting strategy algorithm for IoT-based green house monitoring and analysis." 2022 Sixth International Conference on Smart Cities, Internet of Things and Applications (SCIoT). IEEE, 2022.

# Fuzzy Bee-Eater Hunting Algorithm: A Novel Optimization Approach

## Overview

This repository contains the implementation of the **Fuzzy Bee-Eater Hunting Algorithm (Fuzzy BEH)**, as presented in the paper. The Fuzzy BEH algorithm is a novel optimization technique inspired by the hunting behavior of bee-eater birds. It integrates fuzzy logic into the core of the Bee-Eater Hunting Algorithm (BEH) for enhanced performance in clustering, regression, and general optimization tasks.

---

## Table of Contents
- [Introduction](#introduction)
- [Algorithm Overview](#algorithm-overview)
- [Applications](#applications)
  - [Clustering](#clustering)
  - [Regression](#regression)
- [Performance Metrics](#performance-metrics)
- [How to Use](#how-to-use)
- [Results](#results)
  - [Clustering Results](#clustering-results)
  - [Regression Results](#regression-results)

---

## Introduction

The **Fuzzy Bee-Eater Hunting Algorithm (Fuzzy BEH)** is an evolutionary optimization algorithm that combines:
1. The natural hunting strategy of bee-eater birds.
2. Fuzzy logic to handle uncertainties and improve decision-making during optimization.

The algorithm is capable of solving a wide range of optimization problems, including clustering, regression, and classification tasks, making it versatile for real-world applications.
![fuzzy beh](https://github.com/user-attachments/assets/b739c29f-9f27-4e2c-a4e2-62a42cf35d6a)

---

## Algorithm Overview

The core principles of the Bee-Eater Hunting Algorithm are:
- **Peak Power** (\( \zeta \)): Guides the movement of the solutions toward better regions of the search space.
- **Adjustment Power** (\( \eta \)): Fine-tunes the movement using pitch, yaw, and roll mechanisms.
- **Fuzzy Logic Integration**:
  - Adds membership functions for dynamic adjustment of algorithm parameters.
  - Handles the trade-off between exploration and exploitation more effectively.

The **Fuzzy BEH** algorithm is structured as:
1. **Initialization**:
   - Randomly generate a population of solutions.
   - Assign initial costs and memberships.
2. **Iterative Optimization**:
   - Evaluate and rank solutions.
   - Update positions based on peak power, adjustment power, and fuzzy rules.
   - Apply mutation for diversity.
3. **Convergence**:
   - Stop when the maximum number of iterations is reached or when the solution converges.
![functions](https://github.com/user-attachments/assets/0250caa5-d800-446e-851e-55475cd7631c)

---

## Applications

### Clustering
The Fuzzy BEH algorithm is applied for clustering tasks by:
- Optimizing cluster centers in a multi-dimensional space.
- Using fuzzy memberships to assign data points to clusters.

### Regression
The Fuzzy BEH algorithm is applied for regression tasks by:
- Optimizing polynomial coefficients for predictive models.
- Handling noisy and non-linear relationships between input features and target variables.

![res](https://github.com/user-attachments/assets/3c4c41fb-29f8-4363-b1c0-112d96864d9b)
## Performance Metrics

For evaluating the performance of Fuzzy BEH, the following metrics are used:
- **Clustering**:
  - Silhouette Score: Measures the quality of clustering results.
  - Intra-cluster Distance: Quantifies the compactness of clusters.
- **Regression**:
  - Mean Squared Error (MSE): Measures prediction error.
  - R² Score: Indicates the proportion of variance explained by the model.


![BEH Algorithm](https://user-images.githubusercontent.com/11339420/206549653-f72a869c-a906-4907-84c0-a6d76bbc40d2.jpg)

