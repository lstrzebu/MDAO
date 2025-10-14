% Generate aircraft design configuration for 2025-2026 AIAA DBF
% Created by Liam Trzebunia on 7 October 2025

fprintf('Generating aircraft configuration...\n')

assumptions(1).name = "Example assumption";
assumptions(1).description = "Describe assumption here";
assumptions(1).rationale = "Provide rationale here";
assumptions(1).responsible_engineer = "Liam Trzebunia";

aircraft.title.value = "Notional fixed-value test aircraft";
aircraft.title.units = '';
aircraft.title.type = "non";
aircraft.title.description = "Title of the current aircraft design";

aircraft.continue_design_analysis.value = true;
aircraft.continue_design_analysis.units = '';
aircraft.continue_design_analysis.type = "non";
aircraft.continue_design_analysis.description = "boolean used to skip suboptimal aircraft designs if flaw is found";

aircraft.wing.c.value = 1; % mean aerodynamic chord
aircraft.wing.c.units = 'ft';
aircraft.wing.c.type = "length";
aircraft.wing.c.description = "Mean aerodynamic chord of the wing";

aircraft.wing.b.value = 4; % wingspan
aircraft.wing.b.units = 'ft';
aircraft.wing.b.type = "length";
aircraft.wing.b.description = "Wing span";

assumptions(end+1).name = "Wing Planform Shape";
assumptions(end+1).description = "Assume rectangular wing shape";
assumptions(end+1).rationale = "Ease of manufacturing, lack of sweep benefits";
assumptions(end+1).responsible_engineer = "Eric Stout";

aircraft.wing.S.value = aircraft.wing.c.value.*aircraft.wing.b.value; 
aircraft.wing.S.units = 'ft^2';
aircraft.wing.S.type = "area";
aircraft.wing.S.description = "Planform area";

assumptions(end+1).name = "Wing Sweep";
assumptions(end+1).description = "Assume zero wing sweep angle";
assumptions(end+1).rationale = "Ease of manufacturing, lack of sweep benefits";
assumptions(end+1).responsible_engineer = "Eric Stout";

aircraft.wing.sweep_angle.value = 0;
aircraft.wing.sweep_angle.units = 'deg';
aircraft.wing.sweep_angle.type = "ang";
aircraft.wing.sweep_angle.description = "Angle of sweep for wing";

aircraft.fuselage.protrusion.value = 2;
aircraft.fuselage.protrusion.units = 'ft';
aircraft.fuselage.protrusion.type = "length";
aircraft.fuselage.protrusion.description = "Distance from nose to LE of wing root chord";

aircraft.wing.weight.value = 4;
aircraft.wing.weight.units = 'N';
aircraft.wing.weight.type = "force";
aircraft.wing.weight.description = "weight of wings only";

aircraft.wing.airfoil_name = 'NACA 2412';
aircraft.tail.horizontal.airfoil_name = 'NACA 0012';
aircraft.tail.vertical.airfoil_name = 'NACA 0012';

aircraft.tail.horizontal.d_tail.value = 4;
aircraft.tail.horizontal.d_tail.units = 'ft';
aircraft.tail.horizontal.d_tail.type = "length";
aircraft.tail.horizontal.d_tail.description = "Distance from LE of wing to LE of tail";

aircraft.tail.horizontal.i_tail.value = 0;
aircraft.tail.horizontal.i_tail.units = 'deg';
aircraft.tail.horizontal.i_tail.type = "ang";
aircraft.tail.horizontal.i_tail.description = "Tail incidence angle based on fuselage reference line";

aircraft.tail.horizontal.b.value = 2;
aircraft.tail.horizontal.b.units = 'ft';
aircraft.tail.horizontal.b.type = "length";
aircraft.tail.horizontal.b.description = "Span of horizontal tail";

aircraft.tail.horizontal.c.value = 0.5;
aircraft.tail.horizontal.c.units = 'ft';
aircraft.tail.horizontal.c.type = "length";
aircraft.tail.horizontal.c.description = "mean aerodynamic chord of horizontal tail";


assumptions(end+1).name = "Horizontal Tail Planform Shape";
assumptions(end+1).description = "Assume rectangular horizontal tail";
assumptions(end+1).rationale = "Ease of manufacturing, fewer design parameters (no need to variate sweep angle)";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.horizontal.S.value = aircraft.tail.horizontal.c.value.*aircraft.tail.horizontal.b.value; 
aircraft.tail.horizontal.S.units = 'ft^2';
aircraft.tail.horizontal.S.type = "area";
aircraft.tail.horizontal.S.description = "Planform area";

aircraft.tail.horizontal.weight.value = 4;
aircraft.tail.horizontal.weight.units = 'N';
aircraft.tail.horizontal.weight.type = "force";
aircraft.tail.horizontal.weight.description = "weight of horizontal tail only";

aircraft.tail.vertical.b.value = 2;
aircraft.tail.vertical.b.units = 'ft';
aircraft.tail.vertical.b.type = "length";
aircraft.tail.vertical.b.description = "Span of vertical tail";

aircraft.tail.vertical.c.value = 0.5;
aircraft.tail.vertical.c.units = 'ft';
aircraft.tail.vertical.c.type = "length";
aircraft.tail.vertical.c.description = "mean aerodynamic chord of vertical tail";

assumptions(end+1).name = "Temporary Vertical Tail Shape";
assumptions(end+1).description = "Assume rectangular vertical tail shape";
assumptions(end+1).rationale = "Temporary. This may model a triangular or trapezoidal vertical tail fairly well as far as lift is concerned. Of course we will have a smoother finish on the manufactured VT but that is not considered here. Replace this with a trapezoidal VT.";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.vertical.S.value = aircraft.tail.vertical.c.value.*aircraft.tail.vertical.b.value; 
aircraft.tail.vertical.S.units = 'ft^2';
aircraft.tail.vertical.S.type = "area";
aircraft.tail.vertical.S.description = "Planform area";

aircraft.tail.vertical.weight.value = 4;
aircraft.tail.vertical.weight.units = 'N';
aircraft.tail.vertical.weight.type = "force";
aircraft.tail.vertical.weight.description = "weight of vertical tail only";

aircraft.tail.config.value = 'Conventional'; % Conventional, U-Shaped (Dual Fin), or T-Shaped (High Tail)
aircraft.tail.config.units = '';
aircraft.tail.config.type = "non";
aircraft.tail.config.description = "Whether the current design's tail is Conventional, U-Shaped (Dual Fin), or T-Shaped (High Tail)";

assumptions(end+1).name = "Cylindrical Approximation of Fuselage";
assumptions(end+1).description = "Model fuselage as a perfect cylinder having a diameter equal to the true fuselage's height.";
assumptions(end+1).rationale = "It is not worth the effort to exactly model the fuselage for aerodynamic calculations. Using a diameter equal to the true fuselage's height (rather than width) results in a more conservative estimate as the true fuselage will have less drag this way.";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.fuselage.diameter.value = 1.5;
aircraft.fuselage.diameter.units = 'ft';
aircraft.fuselage.diameter.type = "length";
aircraft.fuselage.diameter.description = "Diameter of fuselage";

aircraft.fuselage.weight.value = 4;
aircraft.fuselage.weight.units = 'N';
aircraft.fuselage.weight.type = "force";
aircraft.fuselage.weight.description = "weight of fuselage only";

aircraft.fuselage.length.value = 7;
aircraft.fuselage.length.units = 'ft';
aircraft.fuselage.length.type = "length";
aircraft.fuselage.length.description = "Length of fuselage";

aircraft.fuselage.hull.thickness.value = 0.25;
aircraft.fuselage.hull.thickness.units = 'in';
aircraft.fuselage.hull.thickness.type = "length";
aircraft.fuselage.hull.thickness.description = "difference between inner and outer radius of fuselage hull";

aircraft.landing_gear.weight.value = 4;
aircraft.landing_gear.weight.units = 'N';
aircraft.landing_gear.weight.type = "force";
aircraft.landing_gear.weight.description = "weight of landing gear";

assumptions(end+1).name = "Landing Gear Weight";
assumptions(end+1).description = sprintf("assume landing gear weight of %.2f %s", aircraft.landing_gear.weight.value, aircraft.landing_gear.weight.units);
assumptions(end+1).rationale = "It is better to have an approximate value for landing gear than no value at all. MDAO aims to consider as many factors as possible, at a low resolution if necessary, so that there are fewer unknowns when manufacturing the selected design";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

%aircraft.weight.empty.value = 10;
%aircraft.weight.empty.units = 'lbf';

numBatt = 4; % considering 4 batteries at first
opts = getBattCapOptions(numBatt);

% Example Motor, Battery, and Prop Configuration Index
batteryIndex = 3; % Options of 1:4
motorIndex = 4; % Options of 1:4
propIndex = 4; % Options of 1:6

aircraft.propulsion.motor.index.value = 3;
aircraft.propulsion.motor.index.description = "Which number (from 1 to the number of motors being considered) is being utilized for the present design iteration";

aircraft.propulsion.battery.index.value = 4;
aircraft.propulsion.battery.index.description = "Which number (from 1 to the number of motors being considered) is being utilized for the present design iteration";

aircraft.propulsion.propeller.index.value = 4;
aircraft.propulsion.propeller.index.description = "Which number (from 1 to the number of propellers being considered) is being utilized for the present design iteration";

% Read Battery Spreadsheet
batteryTable = readmatrix('6S Battery Data Condensed.xlsx'); % Name might change
aircraft.propulsion.battery.weight.value = batteryTable(batteryIndex,8) * (9.81/1000); % in N
aircraft.propulsion.battery.weight.units = 'N';
aircraft.propulsion.battery.weight.type = "force";
aircraft.propulsion.battery.weight.description = "Weight of the battery utilized for the propulsion system";
aircraft.propulsion.battery.capacity.value = batteryTable(batteryIndex, 7); % in Wh
aircraft.propulsion.battery.capacity.units = 'Wh';
aircraft.propulsion.battery.capacity.description = "Total propulsion battery capacity";

% Read Motor Spreadsheet
motorTable = readmatrix('Motor Data Condensed.xlsx'); % Name might change
aircraft.propulsion.motor.weight.value = motorTable(motorIndex, 13) * (9.81/1000); % in N
aircraft.propulsion.motor.weight.units = 'N';
aircraft.propulsion.motor.weight.type = "force";
aircraft.propulsion.motor.weight.description = "Weight of motor";
aircraft.propulsion.motor.kV.value = motorTable(motorIndex, 3)';
aircraft.propulsion.motor.kV.units = 'RPM/V';
aircraft.propulsion.motor.kV.description = "Battery voltage * kV = motor RPM";
aircraft.propulsion.motor.resistance.value = motorTable(motorIndex, 12); % in Ohms
aircraft.propulsion.motor.resistance.units = 'ohm';
aircraft.propulsion.motor.resistance.description = "electrical resistance (likely under zero load?) of the motor";
aircraft.propulsion.motor.current.no_load.value = motorTable(motorIndex, 11); % in Amps
aircraft.propulsion.motor.current.no_load.units = 'A';
aircraft.propulsion.motor.current.no_load.description = "current drawn by the motor under no added mechanical load";
aircraft.propulsion.motor.current.max.value = motorTable(motorIndex, 9); % in Amps
aircraft.propulsion.motor.current.max.units = 'A';
aircraft.propulsion.motor.current.max.description = "maximum current the motor is rated for";
aircraft.propulsion.motor.power.max.value = motorTable(motorIndex, 8); % in Watts
aircraft.propulsion.motor.power.max.units = 'W';
aircraft.propulsion.motor.power.max.description = "maximum power the motor is rated for";
aircraft.propulsion.motor.voltage.max.value = motorTable(motorIndex, 5); % in Volts
aircraft.propulsion.motor.voltage.max.units = 'V';
aircraft.propulsion.motor.voltage.max.description = "maximum voltage the motor is rated for";
aircraft.propulsion.motor.length.value = motorTable(motorIndex, 17)*10^(-3); % in m
aircraft.propulsion.motor.length.units = 'm';
aircraft.propulsion.motor.length.type = "length";
aircraft.propulsion.motor.length.description = "length of motor";
aircraft.propulsion.motor.diameter_outer.value = motorTable(motorIndex, 18)*10^(-3); % in m
aircraft.propulsion.motor.diameter_outer.units = 'm';
aircraft.propulsion.motor.diameter_outer.type = "length";
aircraft.propulsion.motor.diameter_outer.description = "outer diameter of motor";

% Read Big Prop Spreadsheet
propTable = readtable('Prop Data.xlsx'); % Name might change
aircraft.propulsion.propeller.weight.value = (propTable{propIndex, 2} * 28.3495) * (9.81/1000); % converted to N
aircraft.propulsion.propeller.weight.units = 'N';
aircraft.propulsion.propeller.weight.type = "force";
aircraft.propulsion.propeller.weight.description = "weight of propeller";
aircraft.propulsion.propeller.name = propTable{propIndex, 1};

% Reading specific prop spreadsheet
aircraft.propulsion.propeller.filename = strcat('PER3_', aircraft.propulsion.propeller.name{1}, '.xlsx');
aircraft.propulsion.propeller.data.value = readmatrix(aircraft.propulsion.propeller.filename);
aircraft.propulsion.propeller.data.description = "prop data parameters that Bruno's propulsion function takes as an input";

% Provide drag, weight, and vTrim data in N and m/s
% weight = 40 + batteryWeight + propWeight + motorWeight;
% drag = 40;
% vTrim = 20;

aircraft.avionics.servos.number.value = 8;
aircraft.avionics.servos.number.units = '';
aircraft.avionics.servos.number.description = "number of servos used on the aircraft";
aircraft.avionics.servos.weight.value = 10;
aircraft.avionics.servos.weight.units = 'N';
aircraft.avionics.servos.weight.description = "combined weight of all servo motors on the aircraft";

assumptions(end+1).name = "ESC Mass";
assumptions(end+1).description = "assume constant ESC mass of 126 grams";
assumptions(end+1).rationale = "This was an ESC already available for Faux Fly";
assumptions(end+1).responsible_engineer = "Bruno Rosa";

aircraft.propulsion.ESC.mass.value = 126;
aircraft.propulsion.ESC.mass.units = 'grams';
aircraft.propulsion.ESC.mass.description = "mass of electronic speed controller (ESC)";

% convert to kg
aircraft.propulsion.ESC.mass.value = aircraft.propulsion.ESC.mass.value*10^(-3);
aircraft.propulsion.ESC.mass.units = 'kg';

aircraft.propulsion.ESC.weight.description = "weight (force) of electronic speed controller (ESC)";
if strcmp(string(constants.g.units), "m/s^2")
    aircraft.propulsion.ESC.weight.value = aircraft.propulsion.ESC.mass.value.*constants.g.value;
    aircraft.propulsion.ESC.weight.units = 'N';
    aircraft.propulsion.ESC.weight.type = "force";
elseif strcmp(string(constants.g.units), "ft/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
    aircraft.propulsion.ESC.weight.value = aircraft.propulsion.ESC.mass.value.*constants.g.value;
    aircraft.propulsion.ESC.weight.units = 'N';
    aircraft.propulsion.ESC.weight.type = "force";
else
    error('Unit mismatch: calculation of ESC weight not possible. Failed to recognize units of gravitational acceleration constant.');
end

% check if units are equal
unitsToCompare = [string(aircraft.fuselage.weight.units), ...
    string(aircraft.wing.weight.units), ...
    string(aircraft.landing_gear.weight.units), ...
    string(aircraft.tail.horizontal.weight.units), ...
    string(aircraft.tail.vertical.weight.units), ...
    string(aircraft.avionics.servos.weight.units), ...
    string(aircraft.propulsion.propeller.weight.units), ...
    string(aircraft.propulsion.motor.weight.units), ...
    string(aircraft.propulsion.ESC.weight.units), ...
    string(aircraft.propulsion.battery.weight.units)];
% Compare each string to the first one
comparisonResults = strcmp(unitsToCompare, unitsToCompare(1));
% Check if all comparisons are true
equalUnits = all(comparisonResults);

if equalUnits
aircraft.weight.empty.value = aircraft.fuselage.weight.value + aircraft.wing.weight.value + aircraft.landing_gear.weight.value + aircraft.tail.horizontal.weight.value + aircraft.tail.vertical.weight.value + aircraft.avionics.servos.weight.value + aircraft.propulsion.propeller.weight.value + aircraft.propulsion.motor.weight.value + aircraft.propulsion.ESC.weight.value + aircraft.propulsion.battery.weight.value; 
aircraft.weight.empty.units = char(unitsToCompare(1));
aircraft.weight.empty.description = "Weight of aircraft in flight configuration with zero payload";
else
    error('Unit mismatch: empty weight could not be computed. Ensure the weights of aircraft components share the same units.')
end

displayAircraft

fprintf('Done generating aircraft configuration.\n')