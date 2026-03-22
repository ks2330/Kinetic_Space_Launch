function [t,z,h,th,d] = ivpSolver3D(t0,x0,y0,w0,theta,thetaW,dt,method,plotgraph)
% ivpSolver    Solve an initial value problem (IVP) and plot the result
% 
%     [T,Z] = ivpSolver(T0,Z0,DT,TE) computes the IVP solution using a step 
%     size DT, beginning at time T0 and initial state Z0 and ending at time 
%     TEND. The solution is output as a time vector T and a matrix of state 
%     vectors Z.
% Set initial conditions
v0 = 2500;
t(1) = t0;
z(:,1) = [x0; v0*(cos(theta*(pi/180)))*(cos(thetaW*(pi/180))); y0; v0*(sin(theta*(pi/180)))*(cos(thetaW*(pi/180))); w0; v0*(sin(thetaW*(pi/180)))];
% Continue stepping until h < 0
%z(3,:) >= 0
%ivpSolver(0,1,1,1,30,2,1,1,1);
n=1;
hEarth = 10;
while hEarth(1,:) >= 0
    % Increment the time vector by one time step
    t(n+1) = t(n) + dt;
    
    if method == 1
        [z(:,n+1),hEarth(n+1)] = stepEuler3D(t(n),z(:,n),dt);
        'Hi'
    else 
        z(:,n+1) = stepRungeKutta3d(t(n),z(:,n),dt);
    end
    
    n = n+1;
end

h = max(hEarth);
tposition = hEarth == h;
th = t(tposition);
d = z(5,tposition);

if plotgraph == 1
    plot3(z(1,:),z(5,:),z(3,:),'Color','r','MarkerSize',10)
    xlabel('horizontal displacement (rocket direction) (m)')
    ylabel('horizontal displacement (wind direction) (m)')
    zlabel('vertical displacement (m)')
    hold on
    grid on
    plot3(z(1,tposition),z(5,tposition),z(3,tposition),'rx','MarkerSize',10)
    text(z(1,tposition)*0.95,z(5,tposition)*0.95,z(3,tposition)*0.95,'Apogee')

    below10k = find(hEarth <= 10000);
    parachuteOpenPoints = find(z(4,below10k) < 0);
    parachuteOpenPosition = below10k(parachuteOpenPoints(1));
    plot3(z(1,parachuteOpenPosition),z(5,parachuteOpenPosition),z(3,parachuteOpenPosition),'mo','MarkerSize',10)
    text(z(1,parachuteOpenPosition)*0.9,z(5,parachuteOpenPosition)*1.05,z(3,parachuteOpenPosition)*-1,'Parachute Release')

    plot3(z(1,end),z(5,end),z(3,end),'rp','MarkerSize',10)
    text(z(1,end)*1.05,z(5,end)*1.05,z(5,end)*0.25,'Impact')
    
    RE = 6378*10^3;
    x = -10^5:50000:8*10^5;
    y = -10^4:1000:10^4;
    [X,Y] = meshgrid(x,y);
    F = real(sqrt(RE^2 - X.^2 - Y.^2)) - RE;
    surf(X,Y,F)
    colormap([0 1 1])
end