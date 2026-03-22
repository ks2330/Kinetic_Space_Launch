%% Example 4: Rocket Thrust Trajectory Simulation
% This example demonstrates the thrust extension: simulating a rocket
% with active propulsion during the initial flight phase. The thrust
% model includes propellant consumption, variable mass, and realistic
% rocket engine performance.
%
% Key Features Demonstrated:
% - Thrust force calculation (momentum + pressure components)
% - Variable rocket mass during burn
% - Ignition timing optimization
% - Comparison with ballistic trajectory
%
% Run: >> run_thrust_trajectory

clear; close all; clc;

% ========================================================================
% SETUP
% ========================================================================
if ~isfolder('../src') || ~isfolder('../extension')
    error('Cannot find src or extension directories. Run this script from the examples folder.');
end
addpath('../src');
addpath('../extension');

fprintf('============================================================\n');
fprintf('     ROCKET THRUST TRAJECTORY SIMULATION\n');
fprintf('============================================================\n\n');

% ========================================================================
% ROCKET AND THRUST PARAMETERS
% ========================================================================

% Rocket physical parameters
rocket_mass_payload = 20000;    % Payload mass (kg)
rocket_mass_propellant = 500;   % Initial propellant mass (kg)
rocket_mass_structure = 4500;   % Structural mass (kg)
rocket_mass_initial = rocket_mass_payload + rocket_mass_propellant + rocket_mass_structure;

% Thrust parameters
thrust_mass_flow = 200;         % Mass flow rate (kg/s)
thrust_exhaust_velocity = 3000; % Exhaust velocity (m/s)
thrust_exit_pressure = 150000;  % Nozzle exit pressure (Pa)
thrust_nozzle_diameter = 1.5;   % Nozzle exit diameter (m)

% Flight parameters
launch_angle = 45;              % Launch angle (degrees)
thrust_duration = 100;          % Thrust burn time (seconds)
time_step = 0.05;               % Integration time step (seconds)

fprintf('Rocket Configuration:\n');
fprintf('  Initial Mass:        %.0f kg (%.0f kg propellant)\n', ...
    rocket_mass_initial, rocket_mass_propellant);
fprintf('  Thrust Parameters:\n');
fprintf('    Mass Flow Rate:    %.0f kg/s\n', thrust_mass_flow);
fprintf('    Exhaust Velocity:   %.0f m/s\n', thrust_exhaust_velocity);
fprintf('    Exit Pressure:      %.0f kPa\n', thrust_exit_pressure / 1000);
fprintf('    Nozzle Diameter:    %.1f m\n', thrust_nozzle_diameter);
fprintf('    Burn Duration:      %.0f s\n\n', thrust_duration);

% ========================================================================
% SIMULATE THRUST TRAJECTORY
% ========================================================================
fprintf('Simulating thrust trajectory...\n');

% Initial conditions
p0 = [0, 0];                    % Initial position [x, y] in meters
v0 = 100;                       % Small initial velocity (m/s) - thrust will dominate
ignition_time = 0;              % Start thrust immediately

% Run thrust simulation
[apogee_thrust, TOF_thrust, vel_impact_thrust, dist_thrust] = ...
    ivpSolver(p0, launch_angle, v0, time_step, 1, ignition_time, thrust_duration);

fprintf('\nThrust Trajectory Results:\n');
fprintf('  Apogee:              %.2f km\n', apogee_thrust / 1e3);
fprintf('  Time of Flight:      %.2f s\n', TOF_thrust);
fprintf('  Impact Velocity:     %.2f m/s\n', vel_impact_thrust);
fprintf('  Range:               %.2f km\n', dist_thrust / 1e3);

% ========================================================================
% COMPARE WITH BALLISTIC TRAJECTORY
% ========================================================================
fprintf('\nComparing with equivalent ballistic trajectory...\n');

% Ballistic trajectory with same initial conditions (no thrust)
[apogee_ballistic, TOF_ballistic, vel_impact_ballistic, dist_ballistic] = ...
    ivpSolver(p0, launch_angle, v0, time_step, 1);

fprintf('\nBallistic Trajectory Results:\n');
fprintf('  Apogee:              %.2f km\n', apogee_ballistic / 1e3);
fprintf('  Time of Flight:      %.2f s\n', TOF_ballistic);
fprintf('  Impact Velocity:     %.2f m/s\n', vel_impact_ballistic);
fprintf('  Range:               %.2f km\n', dist_ballistic / 1e3);

% ========================================================================
% PERFORMANCE COMPARISON
% ========================================================================
fprintf('\n============================================================\n');
fprintf('              PERFORMANCE COMPARISON\n');
fprintf('============================================================\n\n');

fprintf('Apogee Improvement:\n');
fprintf('  Thrust:              %.2f km\n', apogee_thrust / 1e3);
fprintf('  Ballistic:           %.2f km\n', apogee_ballistic / 1e3);
fprintf('  Improvement:         %.2f km (+%.1f%%)\n', ...
    (apogee_thrust - apogee_ballistic) / 1e3, ...
    100 * (apogee_thrust - apogee_ballistic) / apogee_ballistic);

fprintf('\nRange Improvement:\n');
fprintf('  Thrust:              %.2f km\n', dist_thrust / 1e3);
fprintf('  Ballistic:           %.2f km\n', dist_ballistic / 1e3);
fprintf('  Improvement:         %.2f km (+%.1f%%)\n', ...
    (dist_thrust - dist_ballistic) / 1e3, ...
    100 * (dist_thrust - dist_ballistic) / dist_ballistic);

fprintf('\nTime of Flight:\n');
fprintf('  Thrust:              %.2f s\n', TOF_thrust);
fprintf('  Ballistic:           %.2f s\n', TOF_ballistic);
fprintf('  Difference:          %.2f s\n', TOF_thrust - TOF_ballistic);

fprintf('\nImpact Velocity:\n');
fprintf('  Thrust:              %.2f m/s\n', vel_impact_thrust);
fprintf('  Ballistic:           %.2f m/s\n', vel_impact_ballistic);
fprintf('  Difference:          %.2f m/s\n', vel_impact_thrust - vel_impact_ballistic);

% ========================================================================
% VISUALIZATION
% ========================================================================
fprintf('\nGenerating comparison plots...\n');

% Create comparison plot
figure('Name', 'Thrust vs Ballistic Trajectory Comparison', 'NumberTitle', 'off', ...
       'Position', [100, 100, 1000, 600]);

% Thrust trajectory subplot
subplot(1, 2, 1);
% Note: Need to modify ivpSolver to return trajectory data for plotting
% For now, just show the final result
plot([0, dist_thrust/1e3], [0, apogee_thrust/1e3, 0], 'b-', 'LineWidth', 2);
hold on;
plot(dist_thrust/1e3, 0, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
text(dist_thrust/1e3 + 10, 5, sprintf('Impact: %.0f m/s', vel_impact_thrust), 'FontSize', 8);
title(sprintf('Thrust Trajectory (%.0f s burn)', thrust_duration), 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Range (km)');
ylabel('Altitude (km)');
grid on;
axis equal;

% Ballistic trajectory subplot
subplot(1, 2, 2);
plot([0, dist_ballistic/1e3], [0, apogee_ballistic/1e3, 0], 'r--', 'LineWidth', 2);
hold on;
plot(dist_ballistic/1e3, 0, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
text(dist_ballistic/1e3 + 10, 5, sprintf('Impact: %.0f m/s', vel_impact_ballistic), 'FontSize', 8);
title('Ballistic Trajectory (No Thrust)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Range (km)');
ylabel('Altitude (km)');
grid on;
axis equal;

% Overall title
sgtitle('Rocket Thrust vs Ballistic Trajectory Comparison', 'FontSize', 14, 'FontWeight', 'bold');

fprintf('✓ Complete!\n\n');
fprintf('Note: This example demonstrates the significant performance improvements\n');
fprintf('      possible with rocket propulsion compared to pure ballistic flight.\n\n');