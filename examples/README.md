# Examples Directory

This directory contains ready-to-run examples demonstrating the Kinetic Launch simulator. Each script showcases different aspects of the trajectory optimization framework.

## Quick Start

From MATLAB, navigate to the root project directory and run:

```matlab
% Option 1: Automatic setup (recommended)
>> setup

% Option 2: Manual setup
>> addpath('src');

% Then run examples from the examples folder
>> cd examples
>> run_tolerance_solver
```

---

## Examples

### 1. `run_tolerance_solver.m` 【Primary Solver】
**Purpose**: Demonstrates the main shooting method solver with relative tolerance convergence.

**What it does**:
- Finds the launch angle needed to hit a **100 km apogee** target
- Uses the flat Earth model for speed
- Stops when error is within 0.0001% of target
- Generates final optimized trajectory plot

**Learning outcomes**:
- How secant method converges iteratively
- Relationship between launch angle and apogee
- Accuracy of the numerical integrator

**Expected output**:
- Iteration table showing convergence
- Final launch angle (~45-48°)
- Achieved apogee ≈ 100 km
- Trajectory plot with annotations

**Run time**: ~30-60 seconds (depends on system)

---

### 2. `run_iterative_solver.m` 【Fixed Iteration】
**Purpose**: Shows the secant method with fixed iterations (no tolerance check).

**What it does**:
- Finds launch angle for **80 km apogee** target
- Runs exactly 10 secant iterations (no early stopping)
- Useful for understanding convergence behavior step-by-step
- Generates trajectory plot after fixed iterations

**Learning outcomes**:
- How many iterations are needed for convergence
- Rate of improvement per iteration
- Trade-off between computation cost and precision

**Expected output**:
- Iteration table for all 10 steps
- Final launch angle (~40-45°)
- Convergence analysis breakdown
- Trajectory plot with achieved apogee

**Run time**: ~20-40 seconds (fewer iterations)

---

### 3. `compare_flat_vs_curved.m` 【Physics Model Comparison】
**Purpose**: Compares simplified flat-Earth vs. accurate curved-Earth physics models.

**What it does**:
- Optimizes for **75 km apogee** using both Earth models
- Runs shooting method separately for each model
- Computes differences: angle, apogee, TOF, range, velocity
- Generates side-by-side trajectory plots

**Learning outcomes**:
- When Earth curvature matters (altitude effects)
- How gravity varies with distance from Earth center
- Tradeoff between model complexity and accuracy
- Physics insights into long-range ballistics

**Expected output**:
- Two iteration tables (flat and curved)
- Comparison table with:
  - Launch angle difference (typically ~0.1-0.5°)
  - Apogee difference (typically < 1% up to 100 km)
  - TOF and impact velocity differences
- Side-by-side trajectory plots
- Interpretation of results

**Run time**: ~60-120 seconds (2 optimizations)

---

## Customization

All examples use parameters defined at the top of the script. Edit these to explore:

**Launch Conditions**:
```matlab
p0 = [0, 0];           % Starting position [x, y]
v0 = 1200;             % Initial velocity (m/s)
dt = 0.05;             % Time step (smaller → more accurate, slower)
target_apogee = 100e3; % Target apogee (meters)
```

**Solver Settings**:
```matlab
theta_guess1 = 30;     % First angle guess (degrees)
theta_guess2 = 45;     % Second angle guess (degrees)
max_iterations = 20;   % Max secant iterations
tolerance = 1e-6;      % Relative error tolerance
```

**Try these scenarios**:
- Different initial velocities (500, 2000, 5000 m/s)
- Different target altitudes (10 km, 50 km, 200 km)
- Different time steps (0.01, 0.1, 0.5 seconds)
- Curved Earth model (change `Flat = 1` to `Flat = 0`)

---

## What Happens During Execution

1. **Setup**: Scripts verify paths and load functions
2. **Optimization**: Secant method iteratively refines launch angle
   - Each iteration calls the full IVP solver (trajectory integration)
   - Shooter checks if apogee matches target
   - Adjusts angle for next attempt
3. **Integration**: Runge-Kutta 4th-order integrator advances trajectory
   - Atmospheric drag, gravity, state derivatives computed at each step
   - Parachute deploys automatically at 10 km altitude (downward)
4. **Visualization**: MATLAB generates annotated trajectory plots
   - Blue curve: flight path
   - Red markers: key events (apogee, parachute, impact)
   - Text labels: metrics (max altitude, range, velocity)

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Cannot find src directory" | Ensure you run from the project root: `cd /path/to/Kinetic-Launch` first |
| Too many figures open | Run `close all` before rerunning a script |
| Script runs very slowly | Increase `dt` (time step) to 0.1 or 0.2 for faster, less-precise results |
| Convergence fails | Check that `theta_guess1` and `theta_guess2` bracket the solution (try wider angles) |
| Memory issues | For very long simulations, reduce integration time or increase dt |

---

## Advanced Usage

### Batch Processing
```matlab
setup;  % Configure once

% Run all three examples in sequence
run('examples/run_tolerance_solver.m');
run('examples/run_iterative_solver.m');
run('examples/compare_flat_vs_curved.m');
```

### Custom Scenarios
Create your own script by copying and modifying any example:
```matlab
% Copy template from one of the examples
% Edit the parameters section
% Run custom_scenario.m
```

### Unit Tests
Verify the solver accuracy with built-in tests:
```matlab
>> setup
>> results = runtests('tests');
```

---

## Physics Behind the Examples

**The Shooting Method**:
- We want to find: launch angle θ such that trajectory reaches target apogee H
- We can't solve this analytically (nonlinear trajectory equations)
- Solution: "shoot" trajectories with guessed angles and refine iteratively
- Secant Method = fast root-finding algorithm (binary search alternative: slower)

**Why Two Earth Models?**:
- **Flat Earth**: Constant gravity, simple math, works up to ~50 km
- **Curved Earth**: Variable gravity, spherical coordinates, accurate globally
- Real rockets: need curved Earth for high altitudes and high ranges

**Atmosphere Effects**:
- Density decreases exponentially with altitude
- Drag force ∝ ρ(y) × v²
- At 50+ km: atmosphere much thinner, drag minimal
- At parachute deployment (10 km): drag greatly increases deceleration

---

## Performance Notes

- **Most time spent in**: IVP solver (trajectory integration)
- **Typical runtimes** on modern laptop (i7, 16 GB RAM):
  - Single trajectory: 0.5 - 2 seconds
  - Full optimization (15 iterations): 10 - 30 seconds
  - Comparison (2 optimizations): 20 - 60 seconds
- **To speed up**: Increase `dt` or reduce `max_iterations`
- **To improve accuracy**: Decrease `dt` or increase `tolerance`

---

## Next Steps

1. **Run all three examples** to familiarize yourself with the framework
2. **Modify parameters** to see how physics changes (velocity, angle sensitivity)
3. **Explore the source code** in `src/` to understand the algorithms
4. **Read the README** for mathematical formulations and references
5. **Run unit tests** to verify correctness of atmospheric model

Happy simulating! 🚀
