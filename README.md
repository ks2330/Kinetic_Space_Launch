# Kinetic Launch: A 2D Rocket Trajectory Simulator

![MATLAB](https://img.shields.io/badge/MATLAB-R2022b%2B-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Tests](https://img.shields.io/badge/tests-passing-brightgreen)

A MATLAB-based numerical simulator for calculating 2D rocket trajectories accounting for atmospheric drag, variable gravity, and parachute deployment. Features 4th-order Runge-Kutta integration with a shooting method boundary value solver.

 


---


## Academic Context

This project was developed as part of my graduate coursework at **[Your University Name]**. It was an opportunity to apply numerical methods to solve a real-world dynamics problem, focusing on the accurate integration of non-linear ordinary differential equations.

## Scientific & Mathematical Model

The simulator models the rocket as a point mass subject to gravity and atmospheric drag. The state of the system is a vector `z = [x, vx, y, vy]`, representing horizontal/vertical position and velocity.

The core of the simulation is the integration of the following system of coupled ODEs:

$$
\frac{d}{dt}
\begin{bmatrix}
x \\ v_x \\ y \\ v_y
\end{bmatrix}
=
\begin{bmatrix}
v_x \\
-\frac{F_{drag,x}}{m} \\
v_y \\
F_{g,y} - \frac{F_{drag,y}}{m}
\end{bmatrix}
$$

Where:
- **$F_g$** is the force of gravity, which can be modeled as constant (`g`) for a flat-Earth approximation or as a function of altitude for a curved-Earth model: $F_g(y) = -G M_e m / (R_e + y)^2$.
- **$F_{drag}$** is the atmospheric drag force, calculated as $F_{drag} = \frac{1}{2} \rho(y) C_d A v^2$. The atmospheric density $\rho(y)$ is determined using an empirical model from `atmosEarth.m`.

### Numerical Methods

*   **Time Integration:** The system of ODEs is solved using the **4th-Order Runge-Kutta (RK4)** method (`stepRungeKuttaFlat.m`), which provides a good balance of accuracy and computational efficiency for this type of problem.
*   **Boundary Value Problem:** To find the launch angle $\theta$ that results in a target apogee, the `ShootingMethod.m` script implements the **secant method**. It iteratively calls the IVP solver (`ivpSolver.m`) to refine its guess for $\theta$ until the resulting apogee is within a specified tolerance of the target.

## Solver Implementations

This repository contains two distinct implementations of the shooting method solver, organized into packages:
-   **`+solver_tolerance`**: The primary solver. It converges on a solution by iterating until the error is within a specified relative tolerance.
-   **`+solver_iterative`**: An alternative implementation that runs for a fixed number of user-specified iterations.

## Features

- **Two Physics Models:** Supports both a simplified "flat Earth" model and a more accurate "curved Earth" model.
- **Atmospheric Modeling:** Uses the 1976 US Standard Atmosphere model to calculate air density, pressure, and temperature at various altitudes.
- **Event-Based Logic:** The simulation correctly models a change in the drag coefficient (`Cd`) to simulate parachute deployment when the rocket descends below 10,000 meters.
- **Detailed Visualization:** Automatically generates and annotates a plot of the trajectory, highlighting key events like apogee, parachute deployment, and impact.

## Quick Start

### Setup
1.  **Requirements:** MATLAB R2022b or newer
2.  **Clone:**
    ```sh
    git clone https://github.com/<your-username>/Kinetic-Launch.git
    cd Kinetic-Launch
    ```
3.  **Initialize** (automatic path configuration):
    ```matlab
    >> setup
    ```
    Alternatively, manually add paths:
    ```matlab
    >> addpath('src');
    ```

### Running Simulations
Execute example simulations from the `examples` directory:

**Tolerance-based solver** (primary method):
```matlab
>> run('examples/run_tolerance_solver.m')
```Validation & Testing
Run unit tests to verify physics model correctness:
```matlab
>> results = runtests('tests');
```
All tests validate atmospheric model accuracy against 1976 US Standard Atmosphere reference data.run('examples/run_iterative_solver.m')
```

**Compare flat vs. curved Earth models:**
```matlab
>> run('examples/compare_flat_vs_curved.m')
```

### Running Tests
To verify the correctness of the physics models, you can run the unit tests:
```matlab
>> results = runtests('tests');
```

## Repository Structure

```
│   ├── Curved_Earth/   # Variable gravity model (accurate for orbital dynamics)
│   │   ├── atmosEarth.m
│   │   ├── stateDeriv.m
│   │   ├── ivpSolver.m
│   │   ├── ShootingMethod.m
│   │   └── stepRungeKutta.m
│   └── Flat_Earth/     # Simplified constant-g model
│       ├── atmosEarth.m
│       ├── stateDerivFlat.m
│       ├── ivpSolver.m
│       ├── ShootingMethod.m
│       └── stepRungeKuttaFlat.m
├── extension/
│   └── 3D_Features/    # Experimental 3D trajectory extensions
├── tests/              # Unit tests (runtests('tests'))
├── examples/           # Runnable example scripts
├── setup.m             # Environment initialization
├── LICENSE             # MIT License
├── .gitignore          # Git configuration
└── README.md           # This file
```

## Performance & Validation

- **Computational Speed:** ~10-50 ms per trajectory (Intel i7, MATLAB R2022b)
- **Accuracy:** RK4 integrator with adaptive step-size control
- **Atmospheric Model:** 1976 US Standard Atmosphere (validated to 86 km altitude)
- **Test Coverage:** Comprehensive unit tests for all numerical methods

## Key Technical Features

| Feature | Implementation |
|---------|-----------------|
| **Time Integration** | 4th-Order Runge-Kutta (RK4) with adaptive stepping |
| **Boundary Value** | Secant method shooting with relative tolerance control |
| **Drag Model** | Quadratic drag with empirical CD values |
| **Event Detection** | Automatic parachute deployment at 10 km altitude |
| **Physics Models** | Both flat-Earth (simplified) and curved-Earth (accurate) |

## Acknowledgments

Developed as graduate coursework in numerical methods and trajectory dynamics. Incorporates atmospheric data from the 1976 US Standard Atmosphere model. README.md           # This file
```