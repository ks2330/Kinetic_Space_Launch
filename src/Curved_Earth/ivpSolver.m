function [apogee,TOF,Final_Velocity,Distance_Travelled] = ivpSolver(p0,theta0,v0,dt,Flat)
% ivpSolver    Solve an initial value problem (IVP) and plot the result
% 
%     [T,Z] = ivpSolver(p0,Theta0,v0,dt,Flat) computes the IVP solution using a step 
%     size dt, beginning at time t = 0, initial state p0 and Geometric Condition Flat.
%     The solution is output as the apogee, Time Of Flight, Final Velocity
%     and The Total Distace Travelled.
%     For a Flat Earth Flat = 1
%     For a Curved Earth Flat = 0
Re = 6378 * 10^3;

% Set initial conditions
t(1) = 0;
z(1,1) = p0(1);
% Changing Condition for Curved Earth and Flat Earth
if Flat == 1
    z(3,1) = p0(2);
else
    z(3,1) = Re + p0(2);    %Curved Earth has Centre (0,0) at the Centre of the Earth
end

z(2,1) = v0*cosd(theta0);
z(4,1) = v0*sind(theta0);

% Continue stepping until the end time is exceeded
n=1;

Altitude = 0;

if Flat == 0
    while Altitude >= 0
        % Increment the time vector by one time step
        t(n+1) = t(n) + dt;
                            
        % Apply Euler's method for one time step
        [z(:,n+1)] = stepRungeKutta(t(n), z(:,n), dt);
                        
        Magnitude = ((((z(1,n+1))^2)+((z(3,n+1))^2))^0.5);
        Altitude = Magnitude - Re;
        n = n + 1;
    end
elseif Flat == 1
    while z(3,:) >= 0
        % Increment the time vector by one time step
        t(n+1) = t(n) + dt;
                            
        % Apply Euler's method for one time step
        [z(:,n+1)] = stepRungeKuttaFlat(t(n), z(:,n), dt);
        n = n + 1;
    end    
end

% Drawing a Line for the Arc of the Curved Earth it will be Travelling Over
r = Re;
x = 0;
y = 0;

if Flat == 0
    thetafinal = atan(z(1,end-1)/z(3,end-1));
    th = 0:thetafinal/360:thetafinal;
    xunit = r * sin(th) + x;
    yunit = r * cos(th) + y;
end

Magnitude = sqrt(((z(1,:)).^2)+((z(3,:)).^2));
Altitude = Magnitude - Re;
% Finding the Maximum Distance Travelled for 
if Flat == 0 
    [apogee,~] = max(Altitude);
    Distance_Travelled = r * thetafinal ; % Curved Earth using s = r * Theta
elseif Flat == 1
    [apogee,~] = max(z(3,:));
    Distance_Travelled = max(z(1,:)); % Flat Earth with the Final X Value
end

TOF = max(t); % Time of Flight For Both
Final_Velocity = sqrt(((z(2,end-1))^2)+((z(4,end-1))^2)); % Final (Impact) Velocity for Both

% Finding the Point where the Parachute Goes Off
if Flat == 1
    below10k = find(z(3,:) <= 10000);
    parachuteOpenPoints = find(z(4,below10k) < 0);
    parachuteOpenPosition = below10k(parachuteOpenPoints(1));
elseif Flat == 0
    below10k = find(Altitude <= 10000);
    parachuteOpenPoints = find(z(4,below10k) < 0);
    parachuteOpenPosition = below10k(parachuteOpenPoints(1));  
end
% Plot the result
figure(1)
% PLot X against Y Displacements
plot(z(1,:),z(3,:),'b')
hold on
% Plot Line of Earth
if Flat == 0
    plot(xunit, yunit)
end

if Flat == 1
    [~,I] = max(z(3,:));
elseif Flat == 0
    [~,I] = max(Altitude);
end

% Label Axis
xlabel('horizontal displacement (m)')
ylabel('vertical displacement (m)')
hold on
% Finding Key Points on the Graph
if  Flat == 1
    plot(z(1,I),z(3,I),'rx','MarkerSize',9)
    text(z(1,I),z(3,I),'Apogee')
    plot(z(1,parachuteOpenPosition),z(3,parachuteOpenPosition),'mo','MarkerSize',9)
    text(z(1,parachuteOpenPosition)*0.8,z(3,parachuteOpenPosition)*2,'Parachute Release')
    plot(z(1,end),(z(3,end)),'rp','MarkerSize',9)
    text(z(1,end)*0.85,5*10^3,'Impact')
    text(1*10^5,0.2*10^5,['Apogee = ', num2str(apogee)])
    text(1*10^5,0.4*10^5,['Time of Flight = ', num2str(TOF)])
    text(1*10^5,0.6*10^5,['Impact velocity = ', num2str(Final_Velocity)])
    text(1*10^5,0.8*10^5,['total distance travelled = ', num2str(Distance_Travelled)])
elseif Flat == 0
    plot(z(1,I),z(3,I),'rx','MarkerSize',9)
    text(z(1,I),z(3,I),'\leftarrow Apogee')
    plot(z(1,parachuteOpenPosition),z(3,parachuteOpenPosition),'mo','MarkerSize',9)
    text(z(1,parachuteOpenPosition)-2*10^5,z(3,parachuteOpenPosition),'Parachute Release \rightarrow')
    plot(z(1,end),(z(3,end)),'rp','MarkerSize',9)
    text(z(1,end)-1*10^5,z(3,end),'Impact \rightarrow')
    text(1*10^5,0.2*10^5 + Re,['Apogee = ', num2str(apogee)])
    text(1*10^5,0.4*10^5 + Re,['Time of Flight = ', num2str(TOF)])
    text(1*10^5,0.6*10^5 + Re,['Impact velocity = ', num2str(Final_Velocity)])
    text(1*10^5,0.8*10^5 + Re,['total distance travelled = ', num2str(Distance_Travelled)])
end 
% Labels Trajectory Line
legend('Projectile Trajectory') 

% Label for Earth Line
if Flat == 0
    legend('Trajectory', 'Earth')
elseif Flat == 1
    legend('Trajectory')
end  

hold off



