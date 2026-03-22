%% Example 3: Compare Flat Earth vs. Curved Earth Models
% This example demonstrates the differences between the simplified flat-Earth
% model and the more accurate curved-Earth model. The same launch conditions
% are used for both models, allowing direct comparison of how Earth curvature
% affects trajectory dynamics.
%
% Key Insights:
% - For low altitudes and short ranges: flat Earth ≈ curved Earth
% - For high altitudes and long ranges: differences become significant
% - Curved Earth accounts for variable gravity and spherical coordinates
%
% Run: >> compare_flat_vs_curved

clear; close all; clc;

% ========================================================================
% SETUP
% ========================================================================
if ~isfolder('../src')
    error('Cannot find src directory. Run this script from the examples folder.');
end
addpath('../src');

fprintf('============================================================\n');
fprintf('     COMPARISON: FLAT EARTH vs. CURVED EARTH MODELS\n');
fprintf('============================================================\n\n');

% ========================================================================
% SHARED SIMULATION PARAMETERS
% ========================================================================

p0 = [0, 0];           % Initial position in meters
v0 = 1100;             % Initial velocity in m/s
dt = 0.05;             % Time step for integration in seconds
target_apogee = 75e3;  % 75 km target apogee

% Shooting method parameters (same for both models)
theta_guess1 = 30;
theta_guess2 = 50;
max_iterations = 15;
tolerance = 1e-6;

fprintf('Simulation Parameters (identical for both models):\n');
fprintf('  Initial Velocity:      %.2f m/s\n', v0);
fprintf('  Target Apogee:         %.2f km\n', target_apogee / 1e3);
fprintf('  Time Step:             %.4f s\n', dt);
fprintf('  Convergence Tolerance: %.0e (relative)\n', tolerance);
fprintf('\n');

% ========================================================================
% RUN FLAT EARTH SOLVER
% ========================================================================
fprintf('------- FLAT EARTH MODEL -------\n');
fprintf('Iteration |    θ (deg)   | Apogee (km) | Error (km)\n');
fprintf('----------|--------------|-------------|----------\n');

Flat = 1;  % Flat Earth flag
solver_flat = @(theta) ivpSolver(p0, theta, v0, dt, Flat);
options = struct('MaxIterations', max_iterations, 'Tolerance', tolerance);

[theta_flat, apogee_flat, TOF_flat, vel_flat, dist_flat] = ...
    shootingMethod(solver_flat, theta_guess1, theta_guess2, target_apogee, options);

fprintf('\n');

% ========================================================================
% RUN CURVED EARTH SOLVER
% ========================================================================
fprintf('------- CURVED EARTH MODEL -------\n');
fprintf('Iteration |    θ (deg)   | Apogee (km) | Error (km)\n');
fprintf('----------|--------------|-------------|----------\n');

Flat = 0;  % Curved Earth flag
solver_curved = @(theta) ivpSolver(p0, theta, v0, dt, Flat);

[theta_curved, apogee_curved, TOF_curved, vel_curved, dist_curved] = ...
    shootingMethod(solver_curved, theta_guess1, theta_guess2, target_apogee, options);

fprintf('\n');

% ========================================================================
% COMPARISON TABLE
% ========================================================================
fprintf('============================================================\n');
fprintf('                  COMPARISON RESULTS\n');
fprintf('============================================================\n\n');

fprintf('Launch Angle:\n');
fprintf('  Flat Earth:            %.4f°\n', theta_flat);
fprintf('  Curved Earth:          %.4f°\n', theta_curved);
fprintf('  Difference:            %.4f° (%.2f%%)\n', ...
    theta_curved - theta_flat, ...
    100 * abs(theta_curved - theta_flat) / theta_flat);

fprintf('\nAchieved Apogee:\n');
fprintf('  Flat Earth:            %.2f km\n', apogee_flat / 1e3);
fprintf('  Curved Earth:          %.2f km\n', apogee_curved / 1e3);
fprintf('  Target:                %.2f km\n', target_apogee / 1e3);
fprintf('  Apogee Difference:     %.2f m (%.2f%%)\n', ...
    abs(apogee_curved - apogee_flat), ...
    100 * abs(apogee_curved - apogee_flat) / target_apogee);

fprintf('\nTime of Flight:\n');
fprintf('  Flat Earth:            %.2f s\n', TOF_flat);
fprintf('  Curved Earth:          %.2f s\n', TOF_curved);
fprintf('  Difference:            %.2f s (%.2f%%)\n', ...
    abs(TOF_curved - TOF_flat), ...
    100 * abs(TOF_curved - TOF_flat) / TOF_flat);

fprintf('\nFinal Velocity (at impact):\n');
fprintf('  Flat Earth:            %.2f m/s\n', vel_flat);
fprintf('  Curved Earth:          %.2f m/s\n', vel_curved);
fprintf('  Difference:            %.2f m/s (%.2f%%)\n', ...
    abs(vel_curved - vel_flat), ...
    100 * abs(vel_curved - vel_flat) / vel_flat);

fprintf('\nDistance Travelled:\n');
fprintf('  Flat Earth:            %.2f km\n', dist_flat / 1e3);
fprintf('  Curved Earth:          %.2f km (arc length on sphere)\n', dist_curved / 1e3);
fprintf('  Difference:            %.2f km\n', ...
    abs(dist_curved - dist_flat) / 1e3);

fprintf('============================================================\n\n');

% ========================================================================
% INTERPRETATION
% ========================================================================
fprintf('INTERPRETATION:\n');
fprintf('At this altitude (%.1f km), the curvature effects are:\n', target_apogee / 1e3);
apogee_diff_pct = 100 * abs(apogee_curved - apogee_flat) / target_apogee;
if apogee_diff_pct < 0.5
    fprintf('  → Negligible (< 0.5%%) - flat Earth is a good approximation\n');
elseif apogee_diff_pct < 2.0
    fprintf('  → Small but measurable (0.5%% - 2%%) - consider Earth curvature for precision\n');
else
    fprintf('  → Significant (> 2%%) - curved Earth model is essential for accuracy\n');
end
fprintf('\n');

% ========================================================================
% VISUALIZATION
% ========================================================================
fprintf('Generating comparison trajectory plots...\n\n');

% Create side-by-side comparison plot
figure('Name', 'Flat vs Curved Earth Comparison', 'NumberTitle', 'off', ...
       'Position', [100, 100, 1200, 500]);

% Flat Earth subplot
subplot(1, 2, 1);
ivpSolver(p0, theta_flat, v0, dt, 1);
title(sprintf('Flat Earth: θ = %.2f°, Apogee = %.2f km', ...
    theta_flat, apogee_flat / 1e3), 'FontSize', 11, 'FontWeight', 'bold');

% Curved Earth subplot
subplot(1, 2, 2);
ivpSolver(p0, theta_curved, v0, dt, 0);
title(sprintf('Curved Earth: θ = %.2f°, Apogee = %.2f km', ...
    theta_curved, apogee_curved / 1e3), 'FontSize', 11, 'FontWeight', 'bold');

fprintf('✓ Complete!\n\n');
fprintf('Note: Rerun this script multiple times with different target apogees\n');
fprintf('      (e.g., 50 km, 100 km, 150 km) to observe how curvature effects grow\n');
fprintf('      with increasing altitude and range.\n\n');
