% Generate aircraft design configuration for 2025-2026 AIAA DBF
% Created by Liam Trzebunia on 7 October 2025

fprintf('Getting aircraft configuration...')

aircraft.wing.c.value = 2; % mean aerodynamic chord
aircraft.wing.c.units = 'ft';
aircraft.wing.c.description = "Mean aerodynamic chord of the wing";

aircraft.wing.b.value = 4; % wingspan
aircraft.wing.b.units = 'ft';
aircraft.wing.b.description = "Wing span";

assumptions.wing.shape = "assume rectangular wing shape";
aircraft.wing.S.value = aircraft.wing.c.value.*aircraft.wing.b.value; 
aircraft.wing.S.units = 'ft^2';
aircraft.wing.S.description = "Planform area";

assumptions.wing.sweep = "assume zero sweep";
aircraft.wing.sweep_angle = 0;
aircraft.wing.sweep_angle = 'deg';
aircraft.wing.sweep_angle = "Angle of sweep for wing";

aircraft.wing.airfoil_name = 'NACA 2412';
aircraft.tail.airfoil_name = 'NACA 0000';

aircraft.tail.d_tail.value = 3.5;
aircraft.tail.d_tail.units = 'ft';
aircraft.tail.d_tail.description = "Distance from LE of wing to LE of tail";

aircraft.tail.i_tail.value = 0;
aircraft.tail.i_tail.units = 'deg';
aircraft.tail.i_tail.description = "Tail incidence angle based on fuselage reference line";

aircraft.tail.horizontal.b.value = 1;
aircraft.tail.horizontal.b.units = 'ft';
aircraft.tail.horizontal.b.description = "Span of horizontal tail";

aircraft.tail.horizontal.c.value = 1;
aircraft.tail.horizontal.c.units = 'ft';
aircraft.tail.horizontal.c.description = "mean aerodynamic chord of horizontal tail";

assumptions.tail.horizontal.shape = "assume rectangular horizontal tail shape";
aircraft.tail.horizontal.S.value = aircraft.tail.horizontal.c.value.*aircraft.tail.horizontal.b.value; 
aircraft.tail.horizontal.S.units = 'ft^2';
aircraft.tail.horizontal.S.description = "Planform area";

assumptions.fuselage.shape = "assume cylindrical fuselage shape";
aircraft.fuselage.diameter.value = 1.5;
aircraft.fuselage.diameter.units = 'ft';
aircraft.fuselage.diameter.description = "Diameter of fuselage";

aircraft.weight.empty.value = 10;
aircraft.weight.empty.units = 'lbf';
aircraft.weight.empty.description = "Empty (unloaded) weight of aircraft structures with no motor, ESC, batteries, payload, or propeller (neglect electronics system)";

numBatt = 4; % considering 4 batteries at first
opts = getBattCapOptions(numBatt);

% Example Motor, Battery, and Prop Configuration Index
% batteryIndex = 3; % Options of 1:4
motorIndex = 4; % Options of 1:4
propIndex = 4; % Options of 1:6

% Read Battery Spreadsheet
batteryTable = readmatrix('6S Battery Data Condensed.xlsx'); % Name might change
aircraft.propulsion.battery.weight.value = batteryTable(batteryIndex,8) * (9.81/1000); % in N
aircraft.propulsion.battery.weight.units = 'N';
aircraft.propulsion.battery.weight.description = "Weight of the battery utilized for the propulsion system";
aircraft.propulsion.battery.capacity.value = batteryTable(batteryIndex, 7); % in Wh
aircraft.propulsion.battery.capacity.units = 'Wh';
aircraft.propulsion.battery.capacity.description = "Total propulsion battery capacity";

% Read Motor Spreadsheet
motorTable = readmatrix('Motor Data Condensed.xlsx'); % Name might change
motorWeight = motorTable(motorIndex, 13) * (9.81/1000); % in N
kV = motorTable(motorIndex, 3)';
resistance = motorTable(motorIndex, 12); % in Ohms
currentNoLoad = motorTable(motorIndex, 11); % in Amps
maxCurrent = motorTable(motorIndex, 9); % in Amps
maxPower = motorTable(motorIndex, 8); % in Watts
maxVoltage = motorTable(motorIndex, 5); % in Volts

% Read Big Prop Spreadsheet
propTable = readtable('Prop Data.xlsx'); % Name might change
propWeight = (propTable{propIndex, 2} * 28.3495) * (9.81/1000); % converted to N
propName = propTable{propIndex, 1};

% Reading specific prop spreadsheet
propFileName = strcat('PER3_', propName{1}, '.xlsx');
propData = readmatrix(propFileName);

% Provide drag, weight, and vTrim data in N and m/s
weight = 40 + batteryWeight + propWeight + motorWeight;
drag = 40;
vTrim = 20;


aircraft.propulsion.motor.

aircraft.propulsion.battery.

aircraft.propulsion.propeller.


fprintf('done \n')