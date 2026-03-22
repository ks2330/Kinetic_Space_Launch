function [znext,hEarth] = stepEuler3D(t,z,dt)
% stepEuler    Compute one step using the Euler method
% 
%     ZNEXT = stepEuler(T,Z,DT) computes the state vector ZNEXT at the next
%     time step T+DT

% Calculate the state derivative from the current state
[dz,hEarth] = stateDeriv3D(t,z);

% Calculate the next state vector from the previous one using Euler's
% update equation
znext = z + dt * dz;