function [znext] = stepRungeKuttaThrust(t,z,dt)
% stepEuler    Compute one step using the Euler method
% 
%     ZNEXT = stepRungeKutta(T,Z,DT) computes the state vector ZNEXT at the next
%     time step T+DT

% Calculate the next state vector from the previous one using Euler's
% update equation

% Calculate next solution value
A =  dt * stateDerivThrust( t, z);
B =  dt * stateDerivThrust( t + 0.5*dt , z + A/2);
C =  dt * stateDerivThrust( t + 0.5*dt , z + B/2);
D =  dt * stateDerivThrust( t + dt, z + C);
 

znext = z + (( A + 2*B + 2*C + D )/6);
