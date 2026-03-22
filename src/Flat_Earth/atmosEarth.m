function [rho,T,P] = atmosEarth(z)
%% AtmosDensityEarth  Atmospheric model for Earth 
%
% [RHO,T,P] = atmosEarth(Z) outputs vectors RHO, T, and P of modelled 
% values for atmospheric density, temperature, and pressure on Earth
% at the corresponding altitude values in the input vector Z. Input 
% altitudes must be specified in meters and outputs are given in units of
% kg/m^3, K, and Pa, respectively.
% 
% Density is modelled from empirical data and temperature is modelled
% assuming laps rate of 6.5 deg C per km until the troposphere (11km) and 
% constant thereafter.
%
% US Standard Atmosphere, NOAA, 1976
% https://www.ngdc.noaa.gov/stp/space-weather/online-publications/miscellaneous/us-standard-atmosphere-1976/us-standard-atmosphere_st76-1562_noaa.pdf
% https://ntrs.nasa.gov/api/citations/19770009539/downloads/19770009539.pdf
% 
% Pressure is modelled using the ideal gas equation.
% 
% Alan Hunter & Lonox Jianqiang Huang, University of Bath, Oct 2022.


%% Density

% Altitude samples
z0 = [...
    1e-6
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    15
    20
    25
    30
    40
    50
    60
    70
    80
    ] * 1e3; % m

% Density measurements
rho0 = [...
    1.225
    1.112
    1.007
    0.9093
    0.8194
    0.7364
    0.6601
    0.5900
    0.5258
    0.4671
    0.4135
    0.1948
    0.08891
    0.04008
    0.01841
    0.003996
    0.001027
    0.0003097
    0.00008283
    0.00011
]; % kg/m^3

% Interpolate data at requested altitude(s)
rho = interp1(z0,rho0,z,'linear',0);

% Assign infinite density for negative altitudes
rho(z<0) = Inf;


%% Temperature

T0 = 15 + 273.15; % Temperature at sea level, Kelvins
zt = 11e3; % Altitude of Troposphere, m

T = zeros(size(z));

% Within Troposphere
I = z <= zt;
T(I) = T0 - 6.5/1000 * z(I);

% Beyond Troposphere
T(~I) = T0 - 6.5*11; 


%% Pressure

R = 287.05; % Specific gas constant for air, J/K/mol
P = R * rho .* T; % Ideal gas equation
