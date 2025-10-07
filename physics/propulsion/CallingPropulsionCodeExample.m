% Example Motor, Battery, and Prop Configuration Index
batteryIndex = 3; % Options of 1:8
motorIndex = 4; % Options of 1:12
propIndex = 4; % Options of 1:36

% Read Battery Spreadsheet
batteryTable = readmatrix('Battery Data.xlsx'); % Name might change
batteryWeight = batteryTable(batteryIndex,8) * (9.81/1000); % in N
batteryCapacity = batteryTable(batteryIndex, 7); % in Wh

% Read Motor Spreadsheet
motorTable = readmatrix('Motor Data 6S Only.xlsx'); % Name might change
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

% Run Function
[pUtilization, maxFlightTime, TW, RPM, FactorOfSafety, safetyCheck] = PropulsionCalc(weight, drag, batteryCapacity, vTrim, maxVoltage, kV, resistance, currentNoLoad, maxCurrent, maxPower, propData);