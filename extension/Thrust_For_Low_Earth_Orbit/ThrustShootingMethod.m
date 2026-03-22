
function ThrustShootingMethod = orbit(Guess1, Guess2, Target_Orbit, Target_Velocity)
[theta3,~] = ShootingMethod(1,89,190000,1);
[apogee,z] = ivpSolver([0,0],theta3,[2500],0.01,1);

e1 = apogee - Target_Orbit


% [H1] = ivpSolver([0;0],theta1,2500,0.1,a);
% [H2] = ivpSolver([0;0],theta2,2500,0.1,a);
% 
% 
% e1 = H1 - Target_Height;
% e2 = H2 - Target_Height;
% 
% M = ((e2 - e1)/(theta2 - theta1));
% C = e2 - (M)*theta2;
% 
% theta3 = -C/M;
% H3 = ivpSolver([0;0],theta3,2500,0.1,a);
% e3 = H3 - Target_Height;
% 
% while abs(e3) > Target_Height*0.0001/100
%     
%     H2 = ivpSolver([0;0],theta2,2500,0.1,a);
%     H3 = ivpSolver([0;0],theta3,2500,0.1,a);
% 
%     e2 = H2 - Target_Height;
%     e3 = H3 - Target_Height;
% 
%     M = ((e3 - e2)/(theta3 - theta2));
%     C = e3 - (M)*theta3; 
%     
%     theta2= theta3;
%     theta3 = -C/M;
%     disp(theta3)
%     Max_Height = ivpSolver([0;1],theta3,2500,0.1,a)/1000
% end