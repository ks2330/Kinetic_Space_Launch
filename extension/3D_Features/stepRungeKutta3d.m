function [znext] = stepRungeKutta3d(t,z,dt)
% stepEuler    Compute one step using the Euler method
% 
%     ZNEXT = stepRungeKutta(T,Z,DT) computes the state vector ZNEXT at the next
%     time step T+DT

% Calculate the next state vector from the previous one using Euler's
% update equation

% Calculate next solution value
A =  dt * stateDeriv3D( t, z);
B =  dt * stateDeriv3D( t + 0.5*dt , z + A/2);
C =  dt * stateDeriv3D( t + 0.5*dt , z + B/2);
D =  dt * stateDeriv3D( t + dt, z + C);
 

znext = z + (( A + 2*B + 2*C + D )/6);
