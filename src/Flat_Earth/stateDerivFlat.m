function [dz] = stateDerivFlat(t,z)
% Calculate the state derivative for a mass-spring-damper system
% 
%     DZ = stateDeriv(T,Z) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration.

Mp = 20000;
Mi = 500;
M3 = 4500;
MRocket = Mp + Mi + M3;


Me = 5.972 * 10^24; % Mass of Earth (Kg)
Re = 6378 * 10^3; % Radius of Earth (m)

G = 6.67 * 10^-11; %Gravitational constant






if z(3,:) <= 10000 && z(4,:) < 0
    Cd = 1.2; % Drag Coefficeint Rocket
    Area = 24; % CSA (m^2)
else
    Cd = 0.1; % Drag Coefficeint Rocket
    D = 2; % Diameter (m)
    Area = (pi*D^2)/4; % CSA (m^2)    
end


[rho,~,~] = atmosEarth(z(3,:));

ThetaRocket = atand((z(4,:))/(z(2,:)));%angle in terms of velocity components



U = ((z(2,:).^2)+(z(4,:).^2))^0.5; %resultant velocity


Fg = -(Me*G)/((Re + z(3,:)).^2); %force due to gravity
D = rho*Cd*Area*(U^2)*0.5; %force due to drag

%coupled ODE's
dz1 = z(2);
dz3 = z(4);
dz2 = - (D/(MRocket))*cosd((ThetaRocket));
dz4 = Fg - (D/(MRocket))*sind((ThetaRocket));

dz = [dz1; dz2; dz3; dz4];
