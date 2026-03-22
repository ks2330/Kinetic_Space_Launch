function [time3,n] = IgnitionTime1(time1,time2,Target_Height)
%[time3, Max_Height] = IgnitionTime1(0,190,2000000)
[theta3] = ShootingMethod(1,89,190000);
[H1,~] = ivpSolver([0;0],theta3,2500,0.1,1,time1);
[H2,~] = ivpSolver([0;0],theta3,2500,0.1,1,time2);


e1 = H1 - Target_Height;
e2 = H2 - Target_Height;

M = ((e2 - e1)/(time2 - time1));
C = e2 - (M)*time2;

time3 = -C/M;
[H3,~] = ivpSolver([0;0],theta3,2500,0.1,1,time3);
e3 = H3 - Target_Height;

while abs(e3) > Target_Height*0.1/100
    
    [H2,~] = ivpSolver([0;0],theta3,2500,0.1,1,time2);
    [H3,~] = ivpSolver([0;0],theta3,2500,0.1,1,time3);

    e2 = H2 - Target_Height;
    e3 = H3 - Target_Height;

    M = ((e3 - e2)/(time3 - time2));
    C = e3 - (M)*time3; 
    
    time2= time3;
    time3 = -C/M;
end


