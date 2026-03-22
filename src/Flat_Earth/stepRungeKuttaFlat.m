function [znext] = stepRungeKuttaFlat(t,z,dt)
% StepRungeKutta    Compute one step using the Runge Kutta method
%     Flat Earth
%     ZNEXT = stepRungeKutta(T,Z,DT) computes the state vector ZNEXT at the next
%     time step T+DT

% Calculate the next state vector from the previous one using Euler's
% update equation

% Calculate next solution value
A =  dt * stateDerivFlat( t, z);
B =  dt * stateDerivFlat( t + 0.5*dt , z + A/2);
C =  dt * stateDerivFlat( t + 0.5*dt , z + B/2);
D =  dt * stateDerivFlat( t + dt, z + C);
 

znext = z + (( A + 2*B + 2*C + D )/6);
