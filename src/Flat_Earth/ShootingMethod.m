function [final_theta, final_apogee, varargout] = shootingMethod(solver_func, theta_guess1, theta_guess2, target_apogee, options)
    %shootingMethod Finds the root of a solver function using the secant method.
    %   This is a unified, flexible implementation that can be configured for
    %   different stopping conditions (max iterations or tolerance) and can
    %   work with any solver function.
    %
    %   Inputs:
    %       solver_func     - Handle to a function that takes one input (theta)
    %                         and returns the apogee as its first output.
    %       theta_guess1    - First initial guess for the launch angle (degrees).
    %       theta_guess2    - Second initial guess for the launch angle (degrees).
    %       target_apogee   - The desired apogee (meters).
    %       options         - Name-value pairs for solver configuration:
    %                         'MaxIterations': Stop after this many steps.
    %                         'Tolerance': Relative error for convergence.
    
    arguments
        solver_func function_handle
        theta_guess1 (1,1) double
        theta_guess2 (1,1) double
        target_apogee (1,1) double
        % Solver Parameters
        options.MaxIterations (1,1) {mustBeInteger, mustBePositive} = 20
        options.Tolerance (1,1) double = 1e-6 % Relative tolerance for convergence
    end

    % Define the objective function whose root we want to find:
    % f(theta) = achieved_apogee(theta) - target_apogee
    objective_func = @(theta) solver_func(theta) - target_apogee;

    % Initial guesses
    th1 = theta_guess1;
    f1 = objective_func(th1);

    th2 = theta_guess2;
    f2 = objective_func(th2);

    fprintf('Iter  |  Theta (deg)   |  Apogee (km)   |  Error (km)\n');
    fprintf('--------------------------------------------------------\n');
    fprintf('%-5d | %-14.6f | %-14.3f | %-12.3f\n', 0, th1, (f1 + target_apogee)/1000, f1/1000);
    fprintf('%-5d | %-14.6f | %-14.3f | %-12.3f\n', 1, th2, (f2 + target_apogee)/1000, f2/1000);

    % Secant method iteration
    for i = 2:options.MaxIterations
        if abs(f2 - f1) < eps
            fprintf('Error: Function has zero gradient. Cannot continue.\n');
            th3 = th2; break;
        end

        % Secant formula to find the next theta guess
        th3 = th2 - f2 * (th2 - th1) / (f2 - f1);
        f3 = objective_func(th3);

        fprintf('%-5d | %-14.6f | %-14.3f | %-12.3f\n', i, th3, (f3 + target_apogee)/1000, f3/1000);

        if abs(f3) < abs(target_apogee * options.Tolerance)
            fprintf('Convergence reached within tolerance.\n');
            break;
        end

        % Update points for the next iteration
        th1 = th2; f1 = f2;
        th2 = th3; f2 = f3;
    end

    % Run the final simulation to get all output arguments
    [final_apogee, varargout{1:nargout-2}] = solver_func(th3);
    final_theta = th3;
end
