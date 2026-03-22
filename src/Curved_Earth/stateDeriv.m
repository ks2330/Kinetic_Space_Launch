function [dz] = stateDeriv(t,z)
% Calculate the state derivative for a Rocket system
% 
%     DZ = stateDeriv(T,Z) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration.

Mp = 20000; % Mass of 2nd Stage Propellant   
Mi = 500; % Mass of Inert Mass
M3 = 4500; % Mass of 3rd Stage Payload and Fuel
MRocket = Mp + Mi + M3; % Total Mass


Me = 5.972 * 10^24; % Mass of Earth (Kg)
Re = 6378 * 10^3; % Radius of Earth (m)

G = 6.67 * 10^-11; % Gravitational Constant

Magnitude = (((z(1)).^2)+((z(3,:)).^2))^0.5; % Distance of Rocket From Centre of Earth
Altitude = Magnitude - Re; % Altitude of Rocket Perpendicular From Earth Surface

% Defining Area and Drag Coeffeciant for BEfore and After Parachute is
% Deployed
if Altitude <= 10000 && z(4,:) <= 0
    Cd = 1.2; %Drag Coefficeint Parachute
    Area = 24; % CSA  of Parachute (m^2)
else
    Cd = 0.1; % Drag Coefficeint Rocket
    D = 2; % Diameter (m)
    Area = (pi*D^2)/4; % CSA of Rocket (m^2)
end


[rho,~,~] = atmosEarth(Altitude); % Defining Rho interms Altitude

ThetaRocket = atan2d((z(4,:)),(z(2,:))); % Angle of Rocket Relative to Horizontal Plane

ThetaComponent = atan2d((z(1,:)),(z(3,:))); % Angle  of Rocket Between Vertical Line and Postion of Rocket 

U = ((z(2,:).^2)+(z(4,:).^2))^0.5;


Fg = -(Me*G)/((Magnitude).^2);%Force due to gravity
D = rho*Cd*Area*(U^2)*0.5; %Force due to drag

%Coupled ODE's
dz1 = z(2);
dz3 = z(4);
dz2 = Fg*sind(ThetaComponent) - (D/(MRocket))*cosd((ThetaRocket));
dz4 = Fg*cosd(ThetaComponent) - (D/(MRocket))*sind((ThetaRocket));

dz = [dz1; dz2; dz3; dz4];
