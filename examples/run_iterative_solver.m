%% Example 2: Iterative Shooting Method Solver
% This example demonstrates an alternative approach: finding the launch 
% angle by running the secant method for a fixed number of iterations
% (rather than until convergence with a tolerance).
%
% This is useful for understanding the convergence behavior and the
% iterative refinement process step-by-step.
%
% Run: >> run_iterative_solver

clear; close all; clc;

% ========================================================================
% SETUP
% ========================================================================
if ~isfolder('../src')
    error('Cannot find src directory. Run this script from the examples folder.');
end
addpath('../src');

fprintf('========================================\n');
fprintf(' ITERATIVE SHOOTING METHOD SOLVER (Fixed Iterations)\n');
fprintf('========================================\n\n');

% ========================================================================
% SIMULATION PARAMETERS
% ========================================================================

% Launch conditions
p0 = [0, 0];           % Initial position: [x, y] in meters
v0 = 1000;             % Initial velocity in m/s (slightly lower than Example 1)
dt = 0.05;             % Time step for integration in seconds
Flat = 1;              % 1 = Flat Earth, 0 = Curved Earth

% Target apogee (different from Example 1 to show variation)
target_apogee = 80e3;  % 80 km in meters

% Shooting method parameters
theta_guess1 = 25;     % First angle guess in degrees
theta_guess2 = 50;     % Second angle guess in degrees
num_iterations = 10;   % Fixed number of iterations (no tolerance check)

fprintf('Launch Conditions:\n');
fprintf('  Initial Position: [%.2f, %.2f] m\n', p0(1), p0(2));
fprintf('  Initial Velocity: %.2f m/s\n', v0);
fprintf('  Time Step: %.4f s\n', dt);
fprintf('  Earth Model: %s\n\n', ifelse(Flat, 'Flat', 'Curved'));

fprintf('Target Apogee: %.2f km\n', target_apogee / 1e3);
fprintf('Initial Guesses: θ₁ = %.2f°, θ₂ = %.2f°\n', theta_guess1, theta_guess2);
fprintf('Iterations to Perform: %d (fixed, no early stopping)\n\n', num_iterations);

% ========================================================================
% CREATE SOLVER FUNCTION HANDLE
% ========================================================================
solver_func = @(theta) ivpSolver(p0, theta, v0, dt, Flat);

% ========================================================================
% RUN SHOOTING METHOD WITH FIXED ITERATIONS
% ========================================================================
fprintf('Starting optimization (fixed iterations)...\n');
fprintf('Iteration |    θ (deg)   | Apogee (km) | Error (km)\n');
fprintf('----------|--------------|-------------|----------\n');

% Use MaxIterations without Tolerance to force exact number of iterations
options = struct('MaxIterations', num_iterations, 'Tolerance', 0);
[theta_optimal, apogee_achieved, TOF, final_velocity, distance] = ...
    shootingMethod(solver_func, theta_guess1, theta_guess2, target_apogee, options);

% ========================================================================
% RESULTS & CONVERGENCE ANALYSIS
% ========================================================================
fprintf('\n');
fprintf('========================================\n');
fprintf('        CONVERGENCE ANALYSIS            \n');
fprintf('========================================\n');
fprintf('Optimal Launch Angle:    %.4f°\n', theta_optimal);
fprintf('Achieved Apogee:         %.2f km\n', apogee_achieved / 1e3);
fprintf('Target Apogee:           %.2f km\n', target_apogee / 1e3);

error_m = target_apogee - apogee_achieved;
error_pct = 100 * abs(error_m) / target_apogee;
fprintf('Absolute Error:          %.2f m\n', error_m);
fprintf('Relative Error:          %.4f%%\n', error_pct);

fprintf('\nTrajectory Metrics:\n');
fprintf('  Time of Flight:        %.2f s\n', TOF);
fprintf('  Final Velocity:        %.2f m/s\n', final_velocity);
fprintf('  Distance Travelled:    %.2f km\n', distance / 1e3);

fprintf('\n%s: %d iterations performed.\n', ...
    ifelse(error_pct < 0.1, '✓ Excellent convergence', ...
           ifelse(error_pct < 1.0, '✓ Good convergence', ...
                  'Note: Lower precision - increase iterations for better accuracy')), ...
    num_iterations);
fprintf('========================================\n\n');

% ========================================================================
% VISUALIZE FINAL TRAJECTORY
% ========================================================================
fprintf('Generating final trajectory plot...\n');
figure('Name', sprintf('Rocket Trajectory (after %d iterations)', num_iterations), ...
       'NumberTitle', 'off');
[~, ~, ~, ~, ~] = ivpSolver(p0, theta_optimal, v0, dt, Flat);
title(sprintf('Trajectory after %d Iterations: θ = %.2f°, Apogee = %.2f km', ...
    num_iterations, theta_optimal, apogee_achieved / 1e3), ...
    'FontSize', 12, 'FontWeight', 'bold');

fprintf('✓ Complete!\n\n');

%% Helper function
function result = ifelse(condition, trueval, falseval)
    if condition
        result = trueval;
    else
        result = falseval;
    end
end
