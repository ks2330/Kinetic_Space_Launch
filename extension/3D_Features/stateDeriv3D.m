function [dz,hEarth] = stateDeriv3D(t,z)
% Calculate the state derivative
% 
%     DZ = stateDeriv(T,Z) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration.

M1 = 25000;
ME = 5.972*10^24;
RE = 6378*10^3;
G = 6.674*10^(-11);
Fw = 2000;

%find height relative to curvature of earth
x = (z(1)*RE)/(sqrt((z(1))^2 + (z(3) + RE)^2 + (z(5))^2));
y = ((z(3) + RE)/(z(1)))*x - RE;
w = ((z(5))/(z(1)))*x;
hEarth = sqrt((z(1) - x)^2 + (z(3) - y)^2 + (z(5) - w)^2)*((z(3) - y)/abs(z(3) - y));

%gravity force
FG = (-G*ME)/((RE + hEarth)^2);
thetaV = atan((z(3) + RE)/(sqrt((z(1))^2 + (z(5))^2)));
thetaH = atan((z(5))/(z(1)));

a = atmosEarth(hEarth);

if z(4) < 0 && hEarth <= 10000
    CD = 1.2;
    A = 24;
else
    CD = 0.1;
    D = 2;
    A = (pi/4)*D^2;
end

dz1 = z(2);
dz2 = (-1/(2*M1))*CD*A*z(2)*a(1)*sqrt((z(2))^2 + (z(4))^2 + (z(6))^2) + FG*(cos(thetaV))*(cos(thetaH));
dz3 = z(4);
dz4 = (-1/(2*M1))*CD*A*z(4)*a(1)*sqrt((z(2))^2 + (z(4))^2 + (z(6))^2) + FG*(sin(thetaV));
dz5 = z(6);
dz6 = (-1/(2*M1))*CD*A*z(6)*a(1)*sqrt((z(2))^2 + (z(4))^2 + (z(6))^2) - Fw/M1 + FG*(cos(thetaV))*(sin(thetaH));

dz = [dz1; dz2; dz3; dz4; dz5; dz6];