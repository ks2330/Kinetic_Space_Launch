function [dz] = stateDerivThrust(t,z,TimeI)
% Calculate the state derivative for a mass-spring-damper system
% 
%     DZ = stateDeriv(T,Z) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration.

Mp = 20000;
Mi = 500;
M3 = 4500;

Me = 5.972 * 10^24; % Mass of Earth (Kg)
Re = 6378 * 10^3; % Radius of Earth (m)



G = 6.67 * 10^-11;

Magnitude = (((z(1)).^2)+((z(3,:)).^2))^0.5;
Altitude = Magnitude - Re;

[rho,~,P] = atmosEarth(Altitude);
% Describing Theta

ThetaRocket = atan2d((z(4,:)),(z(2,:)));

ThetaComponent = atan2d((z(1,:)),(z(3,:)));

U = ((z(2,:).^2)+(z(4,:).^2))^0.5;


ve = 3000;
d = 1.5;
pe = 150000;
dm = 200;

n = TimeI;

MRocket = Mp + Mi + M3 - dm*(t-n);

if MRocket <= 700
    MRocket = 700;
end

if t <= TimeI + 100
    F = thrust(dm,ve,pe,P,d);
% 
% elseif t >= n && Altitude >= MaxAlt
%     F = thrust(dm,ve,pe,P,d);
else
    F = 0;
end
Fg = -(Me*G)/((Magnitude).^2);
D = rho*Cd*Area*(U^2)*0.5;


dz1 = z(2);
dz3 = z(4);
dz2 = Fg*sind(ThetaComponent) - (D/(MRocket))*cosd((ThetaRocket)) + (F/MRocket)*cosd(ThetaRocket);
dz4 = Fg*cosd(ThetaComponent) - (D/(MRocket))*sind((ThetaRocket)) + (F/MRocket)*sind(ThetaRocket);

dz = [dz1; dz2; dz3; dz4];
