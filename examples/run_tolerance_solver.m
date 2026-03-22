%% Example 1: Tolerance-Based Shooting Method Solver
% This example demonstrates the primary solver: finding the launch angle
% required to achieve a target apogee using the secant method with 
% relative tolerance convergence criteria.
%
% The example simulates a rocket launched from sea level with a target 
% apogee of 100 km using the flat Earth model for speed.
%
% Run: >> run_tolerance_solver

clear; close all; clc;

% ========================================================================
% SETUP
% ========================================================================
% Ensure source code is on the path
if ~isfolder('../src')
    error('Cannot find src directory. Run this script from the examples folder.');
end
addpath('../src');

fprintf('========================================\n');
fprintf('  TOLERANCE-BASED SHOOTING METHOD SOLVER\n');
fprintf('========================================\n\n');

% ========================================================================
% SIMULATION PARAMETERS
% ========================================================================

% Launch conditions
p0 = [0, 0];           % Initial position: [x, y] in meters (sea level origin)
v0 = 1200;             % Initial velocity in m/s
dt = 0.05;             % Time step for integration in seconds
Flat = 1;              % 1 = Flat Earth, 0 = Curved Earth

% Target apogee
target_apogee = 100e3; % 100 km in meters

% Shooting method options
theta_guess1 = 30;     % First angle guess in degrees
theta_guess2 = 45;     % Second angle guess in degrees
max_iterations = 20;   % Maximum secant method iterations
tolerance = 1e-6;      % Relative tolerance for convergence

fprintf('Launch Conditions:\n');
fprintf('  Initial Position: [%.2f, %.2f] m\n', p0(1), p0(2));
fprintf('  Initial Velocity: %.2f m/s\n', v0);
fprintf('  Time Step: %.4f s\n', dt);
fprintf('  Earth Model: %s\n\n', ifelse(Flat, 'Flat', 'Curved'));

fprintf('Target Apogee: %.2f km\n', target_apogee / 1e3);
fprintf('Initial Guesses: θ₁ = %.2f°, θ₂ = %.2f°\n', theta_guess1, theta_guess2);
fprintf('Convergence Tolerance: %.0e (relative)\n', tolerance);
fprintf('Max Iterations: %d\n\n', max_iterations);

% ========================================================================
% CREATE SOLVER FUNCTION HANDLE
% ========================================================================
% The shooting method requires a function that maps launch angle → apogee
% We wrap ivpSolver in a lambda to create this mapping

solver_func = @(theta) ivpSolver(p0, theta, v0, dt, Flat);

% ========================================================================
% RUN SHOOTING METHOD SOLVER
% ========================================================================
fprintf('Starting optimization...\n');
fprintf('Iteration |    θ (deg)   | Apogee (km) | Error (km)\n');
fprintf('----------|--------------|-------------|----------\n');

options = struct('MaxIterations', max_iterations, 'Tolerance', tolerance);
[theta_optimal, apogee_achieved, TOF, final_velocity, distance] = ...
    shootingMethod(solver_func, theta_guess1, theta_guess2, target_apogee, options);

% ========================================================================
% RESULTS SUMMARY
% ========================================================================
fprintf('\n');
fprintf('========================================\n');
fprintf('             RESULTS SUMMARY            \n');
fprintf('========================================\n');
fprintf('Optimal Launch Angle:    %.4f°\n', theta_optimal);
fprintf('Achieved Apogee:         %.2f km\n', apogee_achieved / 1e3);
fprintf('Target Apogee:           %.2f km\n', target_apogee / 1e3);
fprintf('Error:                   %.4f m (%.4f%%)\n', ...
    target_apogee - apogee_achieved, ...
    100 * abs(target_apogee - apogee_achieved) / target_apogee);
fprintf('\nTrajectory Metrics:\n');
fprintf('  Time of Flight:        %.2f s\n', TOF);
fprintf('  Final Velocity:        %.2f m/s\n', final_velocity);
fprintf('  Distance Travelled:    %.2f km\n', distance / 1e3);
fprintf('========================================\n\n');

% ========================================================================
% VISUALIZE FINAL TRAJECTORY
% ========================================================================
fprintf('Generating final trajectory plot...\n');
figure('Name', 'Optimal Rocket Trajectory (Tolerance Solver)', 'NumberTitle', 'off');
[~, ~, ~, ~, ~] = ivpSolver(p0, theta_optimal, v0, dt, Flat);
title(sprintf('Optimal Trajectory: θ = %.2f°, Apogee = %.2f km', ...
    theta_optimal, apogee_achieved / 1e3), 'FontSize', 12, 'FontWeight', 'bold');

fprintf('✓ Complete!\n\n');

%% Helper function
function result = ifelse(condition, trueval, falseval)
    if condition
        result = trueval;
    else
        result = falseval;
    end
end
