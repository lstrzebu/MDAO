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

ii = length(assumptions) + 1;
assumptions(ii).name = "Dihedral";
assumptions(ii).description = "Assume zero dihedral angle";
assumptions(ii).rationale = "First pass of MDAO, change later";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.wing.dihedral.value = 0;
aircraft.wing.dihedral.units = 'deg';
aircraft.wing.dihedral.type = "ang";
aircraft.wing.dihedral.description = "Dihedral angle of wing";

aircraft.wing.c.value = 11.586; % mean aerodynamic chord
aircraft.wing.c.units = 'in';
aircraft.wing.c.type = "length";
aircraft.wing.c.description = "Mean aerodynamic chord of the wing";

aircraft.wing.b.value = 60; % wingspan
aircraft.wing.b.units = 'in';
aircraft.wing.b.type = "length";
aircraft.wing.b.description = "Wing span";

assumptions(end+1).name = "Wing Planform Shape";
assumptions(end+1).description = "Assume rectangular wing shape";
assumptions(end+1).rationale = "Ease of manufacturing, lack of sweep benefits";
assumptions(end+1).responsible_engineer = "Eric Stout";

aircraft.wing.S.value = aircraft.wing.c.value.*aircraft.wing.b.value;
aircraft.wing.S.units = 'in^2';
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

% aircraft.wing.weight.value = 4;
% aircraft.wing.weight.units = 'N';
% aircraft.wing.weight.type = "force";
% aircraft.wing.weight.description = "weight of wings only";

aircraft.wing.resting_angle.value = 0;
aircraft.wing.resting_angle.units = 'deg';
aircraft.wing.resting_angle.type = "ang";
aircraft.wing.resting_angle.description = "wing resting angle of attack with respect to fuselage (positive pitched upwards)";

aircraft.wing.airfoil_name = 'MH 114';
aircraft.wing.airfoil_filename = sprintf('%s.dat', aircraft.wing.airfoil_name);
aircraft.tail.horizontal.airfoil_name = 'NACA 0012';
aircraft.tail.vertical.airfoil_name = 'NACA 0012'; % just to give a thickness

aircraft.wing.plies.number = 2;
aircraft.tail.horizontal.plies.number = 1;
aircraft.tail.vertical.plies.number = 1;

ii = length(assumptions) + 1;
assumptions(ii).name = "Tail Arm (Leading Edge)";
assumptions(ii).description = "Assume the leading edge (LE) of both horizontal and vertical tail share the same distance from the leading edge of the wing";
assumptions(ii).rationale = "First pass of MDAO, change later";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.tail.d_tail.value = 40.9;
aircraft.tail.d_tail.units = 'in';
aircraft.tail.d_tail.type = "length";
aircraft.tail.d_tail.description = "Distance from LE of wing to LE of both tails";

aircraft.tail.horizontal.i_tail.value = 5;
aircraft.tail.horizontal.i_tail.units = 'deg';
aircraft.tail.horizontal.i_tail.type = "ang";
aircraft.tail.horizontal.i_tail.description = "Tail incidence angle based on fuselage reference line";

aircraft.tail.horizontal.taper_ratio.value = 0;
aircraft.tail.horizontal.taper_ratio.units = '';
aircraft.tail.horizontal.taper_ratio.type = "non";
aircraft.tail.horizontal.taper_ratio.description = "taper ratio of horizontal tail";

ii = length(assumptions) + 1;
assumptions(ii).name = "Horizontal Tail Taper Ratio";
assumptions(ii).description = "Assume zero horizontal tail taper";
assumptions(ii).rationale = "First pass of MDAO, change later";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.tail.horizontal.resting_angle.value = -aircraft.tail.horizontal.i_tail.value;
aircraft.tail.horizontal.resting_angle.units = 'deg';
aircraft.tail.horizontal.resting_angle.type = "ang";
aircraft.tail.horizontal.resting_angle.description = "horizontal tail resting angle of attack with respect to fuselage (positive pitched upwards)";

ii = length(assumptions) + 1;
assumptions(ii).name = "Lifting Surface Resting Angles of Attack";
assumptions(ii).description = "Assume zero resting angle of attack for wing and horizontal tail";
assumptions(ii).rationale = "First pass of MDAO, change later";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.tail.horizontal.b.value = 15;
aircraft.tail.horizontal.b.units = 'in';
aircraft.tail.horizontal.b.type = "length";
aircraft.tail.horizontal.b.description = "Span of horizontal tail";

aircraft.tail.horizontal.c.value = 4.8;
aircraft.tail.horizontal.c.units = 'in';
aircraft.tail.horizontal.c.type = "length";
aircraft.tail.horizontal.c.description = "mean aerodynamic chord of horizontal tail";

assumptions(end+1).name = "Horizontal Tail Planform Shape";
assumptions(end+1).description = "Assume rectangular horizontal tail";
assumptions(end+1).rationale = "Ease of manufacturing, fewer design parameters (no need to variate sweep angle)";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.horizontal.S.value = aircraft.tail.horizontal.c.value.*aircraft.tail.horizontal.b.value;
aircraft.tail.horizontal.S.units = 'in^2';
aircraft.tail.horizontal.S.type = "area";
aircraft.tail.horizontal.S.description = "Planform area";

% aircraft.tail.horizontal.weight.value = 4;
% aircraft.tail.horizontal.weight.units = 'N';
% aircraft.tail.horizontal.weight.type = "force";
% aircraft.tail.horizontal.weight.description = "weight of horizontal tail only";

aircraft.tail.vertical.S.value = 0.167;
aircraft.tail.vertical.S.units = 'ft^2';
aircraft.tail.vertical.S.type = "area";
aircraft.tail.vertical.S.description = "Planform area";

aircraft = conv_aircraft_units(aircraft, 0, "aircraft.tail.horizontal.c", "ft");

if strcmp(string(aircraft.tail.horizontal.c.units), "ft")
aircraft.tail.vertical.c.value = aircraft.tail.horizontal.c.value;
aircraft.tail.vertical.c.units = aircraft.tail.horizontal.c.units;
aircraft.tail.vertical.c.type = "length";
aircraft.tail.vertical.c.description = "mean aerodynamic chord of vertical tail";

aircraft.tail.vertical.b.value = aircraft.tail.vertical.S.value./aircraft.tail.vertical.c.value;
aircraft.tail.vertical.b.units = 'ft';
aircraft.tail.vertical.b.type = "length";
aircraft.tail.vertical.b.description = "Span of vertical tail";
else
    error('Unit mismatch: computation of vertical tail size not possible.')
end

% aircraft.tail.vertical.weight.value = 4;
% aircraft.tail.vertical.weight.units = 'N';
% aircraft.tail.vertical.weight.type = "force";
% aircraft.tail.vertical.weight.description = "weight of vertical tail only";

aircraft.tail.config.value = 'T-Shaped'; % Conventional, U-Shaped (Dual Fin), or T-Shaped (High Tail)
aircraft.tail.config.units = '';
aircraft.tail.config.type = "non";
aircraft.tail.config.description = "Whether the current design's tail is Conventional, U-Shaped (Dual Fin), or T-Shaped (High Tail)";

aircraft.tail.vertical.taper_ratio.value = 0;
aircraft.tail.vertical.taper_ratio.units = '';
aircraft.tail.vertical.taper_ratio.type = "non";
aircraft.tail.vertical.taper_ratio.description = "Taper ratio of vertical tail";

fuselageType = "large";
material = "Hexcel AS4C (3000 filaments)";
nPlies = 3;

switch fuselageType
    case "small"
        aircraft.fuselage.diameter.value = mean([6, 6.5]); % horizontal, vertical diameter
    case "large"
        aircraft.fuselage.diameter.value = mean([7.5, 7.5]);
        aircraft.fuselage.length.value = 60.9;

        switch material
            case "Hexcel AS4C (3000 filaments)"

                switch nPlies
                    case 2
                        aircraft.fuselage.mass.value = 1.617;
                        aircraft.fuselage.XYZ_CG.value = [28.347, 0, 0.334];
                        I_xx = 20.417;
                        I_yy = 426.0;
                        I_zz = 427.497;
                    case 3
                        aircraft.fuselage.mass.value = 2.414;
                        aircraft.fuselage.XYZ_CG.value = [28.371, 0, 0.334];
                        I_xx = 30.402;
                        I_yy = 636.383;
                        I_zz = 638.569;
                end
            % case "E-glass fiber"
            %     switch nPlies
            %         case 2
            %             aircraft.fuselage.weight.value = 2.516;
            %             aircraft.fuselage.XYZ_CG.value = []
            %         case 3
            %             aircraft.fuselage.weight.value = 3.757;
            %     end
        end

    otherwise
        error('Material not recognized.')
end

aircraft.fuselage.diameter.units = 'in';
aircraft.fuselage.diameter.type = "length";
aircraft.fuselage.diameter.description = "Diameter of fuselage";

aircraft.fuselage.mass.units = 'lbm';
aircraft.fuselage.mass.type = "mass";
aircraft.fuselage.mass.description = "mass of fuselage only";

aircraft = conv_aircraft_units(aircraft, 0, "aircraft.fuselage.mass", "kg");

if strcmp(string(aircraft.fuselage.mass.units), "kg") && strcmp(string(constants.g.units), "m/s^2")
    aircraft.fuselage.weight.value = aircraft.fuselage.mass.value.*constants.g.value;
    aircraft.fuselage.weight.units = 'N';
    aircraft.fuselage.weight.type = "force";
else
    error('Unit mismatch: fuselage weight calculation not possible.')
end

aircraft.fuselage.length.units = 'in';
aircraft.fuselage.length.type = "length";
aircraft.fuselage.length.description = "Length of fuselage";

aircraft.fuselage.XYZ_CG.units = 'in';
aircraft.fuselage.XYZ_CG.type = "length";
aircraft.fuselage.XYZ_CG.description = "vector of X, Y, Z coordinates of fuselage CG";

aircraft = conv_aircraft_units(aircraft, 0, "aircraft.tail.horizontal.c", "in");
if strcmp(string(aircraft.fuselage.length.units), "in") && strcmp(string(aircraft.tail.horizontal.c.units), "in") && strcmp(string(aircraft.tail.d_tail.units), "in") && strcmp(string(aircraft.fuselage.XYZ_CG.units), "in")
aircraft.fuselage.protrusion.value = aircraft.fuselage.length.value - aircraft.tail.horizontal.c.value - aircraft.tail.d_tail.value;
aircraft.fuselage.protrusion.units = 'in';
aircraft.fuselage.protrusion.type = "length";
aircraft.fuselage.protrusion.description = "Distance from nose to LE of wing root chord";

aircraft.fuselage.XYZ_CG.value(1) = aircraft.fuselage.XYZ_CG.value(1) - aircraft.fuselage.protrusion.value; % correction of fuselage CG coordinate system
else
    error('Unit mismatch: calculation of wing location along fuselage length not possible.');
end

aircraft = conv_aircraft_units(aircraft, 0, "aircraft.fuselage.mass", "lbm");
if strcmp(string(aircraft.fuselage.mass.units), "lbm") && strcmp(string(aircraft.fuselage.protrusion.units), "in")
aircraft.fuselage.MOI.value = zeros(3);
aircraft.fuselage.MOI.value(1,1) = I_xx;
aircraft.fuselage.MOI.value(2,2) = I_yy + aircraft.fuselage.mass.value*aircraft.fuselage.protrusion.value.^2; % parallel axis theorem to convert from reference frame at nose to reference frame at aircraft CG
aircraft.fuselage.MOI.value(3,3) = I_zz + aircraft.fuselage.mass.value*aircraft.fuselage.protrusion.value.^2; % parallel axis theorem to convert from reference frame at nose to reference frame at aircraft CG
aircraft.fuselage.MOI.units = 'lbm*in^2';
aircraft.fuselage.MOI.type = "MOI";
aircraft.fuselage.MOI.description = "moment of inertia of fuselage hull (not including structural bulkheads)";
end
aircraft = conv_aircraft_units(aircraft, 0, "aircraft.fuselage.mass", "kg"); % convert back to kg

aircraft.fuselage.thickness.value = (0.25*nPlies)*10^-3; % convert from mm to m
aircraft.fuselage.thickness.units = 'm';
aircraft.fuselage.thickness.type = "length";
aircraft.fuselage.thickness.description = "difference between inner and outer radius of fuselage hull";

aircraft.landing_gear.weight.value = 0;
aircraft.landing_gear.weight.units = 'N';
aircraft.landing_gear.weight.type = "force";
aircraft.landing_gear.weight.description = "weight of landing gear";

% banner
% aircraft.banner.area.value = 0;
% aircraft.banner.area.units = 'm^2';
% aircraft.banner.area.type = "area";
% aircraft.banner.area.description = "area of banner";
% aircraft.banner.AR.value = 0;
% aircraft.banner.AR.units = '';
% aircraft.banner.AR.type = "non";
% aircraft.banner.AR.description = "aspect ratio of banner";

assumptions(end+1).name = "Landing Gear Weight";
assumptions(end+1).description = sprintf("assume landing gear weight of %.2f %s", aircraft.landing_gear.weight.value, aircraft.landing_gear.weight.units);
assumptions(end+1).rationale = "It is better to have an approximate value for landing gear than no value at all. MDAO aims to consider as many factors as possible, at a low resolution if necessary, so that there are fewer unknowns when manufacturing the selected design";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

%aircraft.weight.empty.value = 10;
%aircraft.weight.empty.units = 'lbf';

numBatt = 4; % considering 4 batteries at first
opts = getBattCapOptions(numBatt);

% Example Motor, Battery, and Prop Configuration Index
batteryIndex = 4; % Options of 1:4
motorIndex = 5; % Options of 1:4
%propIndex = 4; % Options of 1:6

aircraft.propulsion.motor.index.value = 3;
aircraft.propulsion.motor.index.description = "Which number (from 1 to the number of motors being considered) is being utilized for the present design iteration";

aircraft.propulsion.battery.index.value = 4;
aircraft.propulsion.battery.index.description = "Which number (from 1 to the number of motors being considered) is being utilized for the present design iteration";

% Read Battery Spreadsheet
batteryTable = readmatrix('6S Battery Data Condensed.xlsx'); % Name might change
aircraft.propulsion.battery.weight.value = batteryTable(batteryIndex,8) * (9.81/1000); % in N
aircraft.propulsion.battery.weight.units = 'N';
aircraft.propulsion.battery.weight.type = "force";
aircraft.propulsion.battery.weight.description = "Weight of the battery utilized for the propulsion system";
aircraft.propulsion.battery.capacity.value = batteryTable(batteryIndex, 7); % in Wh
aircraft.propulsion.battery.capacity.units = 'Wh';
aircraft.propulsion.battery.capacity.description = "Total propulsion battery capacity";
aircraft.propulsion.battery.length.value = batteryTable(batteryIndex, 10);
aircraft.propulsion.battery.length.units = 'in';
aircraft.propulsion.battery.length.type = "length";
aircraft.propulsion.battery.length.description = "length of battery";
aircraft.propulsion.battery.width = aircraft.propulsion.battery.length;
aircraft.propulsion.battery.width.value = batteryTable(batteryIndex, 11);
aircraft.propulsion.battery.width.description = "width of battery";
aircraft.propulsion.battery.height = aircraft.propulsion.battery.length;
aircraft.propulsion.battery.height.value = batteryTable(batteryIndex, 12);
aircraft.propulsion.battery.height.description = "height of battery";

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
% unitsToCompare = [string(aircraft.fuselage.weight.units), ...
%     string(aircraft.wing.weight.units), ...
%     string(aircraft.landing_gear.weight.units), ...
%     string(aircraft.tail.horizontal.weight.units), ...
%     string(aircraft.tail.vertical.weight.units), ...
%     string(aircraft.avionics.servos.weight.units), ...
%     string(aircraft.propulsion.propeller.weight.units), ...
%     string(aircraft.propulsion.motor.weight.units), ...
%     string(aircraft.propulsion.ESC.weight.units), ...
%     string(aircraft.propulsion.battery.weight.units)];
% % Compare each string to the first one
% comparisonResults = strcmp(unitsToCompare, unitsToCompare(1));
% % Check if all comparisons are true
% equalUnits = all(comparisonResults);

% if equalUnits
% aircraft.weight.empty.value = aircraft.fuselage.weight.value + aircraft.wing.weight.value + aircraft.landing_gear.weight.value + aircraft.tail.horizontal.weight.value + aircraft.tail.vertical.weight.value + aircraft.avionics.servos.weight.value + aircraft.propulsion.propeller.weight.value + aircraft.propulsion.motor.weight.value + aircraft.propulsion.ESC.weight.value + aircraft.propulsion.battery.weight.value;
% aircraft.weight.empty.units = char(unitsToCompare(1));
% aircraft.weight.empty.description = "Weight of aircraft in flight configuration with zero payload";
% else
%     error('Unit mismatch: empty weight could not be computed. Ensure the weights of aircraft components share the same units.')
% end

displayAircraft

% calculate aerodynamic and static stability variables in preparation for
% mission physics analyses
ii = length(assumptions) + 1;
assumptions(ii).name = "Wing-Body System Lift-Curve Slope Approximation";
assumptions(ii).description = "Assume that lift-curve slope of the wing approximately equals the lift-curve slope of the wing-body system";
assumptions(ii).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.wing.a_wb.units = '/rad';
aircraft.wing.a_wb.type = "recang"; % reciprocal angle unit type
aircraft.wing.a_wb.description = "3D lift-curve slope of wing";
aircraft.wing.Cm0.units = '';
aircraft.wing.Cm0.type = "non"; % nondimensional unit type
aircraft.wing.Cm0.description = "pitching moment coefficient at zero lift for wing";
aircraft.wing.alpha_0L_wb.units = 'rad';
aircraft.wing.alpha_0L_wb.type = "ang";
aircraft.wing.alpha_0L_wb.description = "zero-lift angle for wing";

ii = length(assumptions) + 1;
assumptions(ii).name = "Wing-Body System Zero-Lift Angle Approximation";
assumptions(ii).description = "Assume that zero-lift angle of the wing approximately equals the lift-curve slope of the wing-body system";
assumptions(ii).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
assumptions(ii).responsible_engineer = "Liam Trzebunia";

aircraft.wing.alpha_stall.units = 'rad';
aircraft.wing.alpha_stall.type = "ang";
[aircraft.wing.a_wb.value,...
    aircraft.wing.Cm0.value,...
    aircraft.wing.alpha_0L_wb.value,...
    aircraft.wing.a0.value,...
    ~,...
    aircraft.wing.alpha_stall.value] = CL_alphaV3(aircraft.wing.b.value,...
    aircraft.wing.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.wing.airfoil_name);

aircraft.wing.a0.units = '/rad';
aircraft.wing.a0.type = "recang";
aircraft.wing.a0.description = "2D lift curve slope";

aircraft.tail.horizontal.a.units = '/rad';
aircraft.tail.horizontal.a.type = "recang";
aircraft.tail.horizontal.a.description = "3D lift-curve slope of horizontal tail";

aircraft.tail.horizontal.alpha_0L_t.units = 'rad';
aircraft.tail.horizontal.alpha_0L_t.type = "ang";
aircraft.tail.horizontal.alpha_0L_t.description = "zero-lift angle for horizontal tail";
[aircraft.tail.horizontal.a.value,...
    ~,...
    aircraft.tail.horizontal.alpha_0L_t.value,...
    ~,...
    ~,...
    ~] = CL_alphaV3(aircraft.tail.horizontal.b.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.tail.horizontal.airfoil_name);

fprintf('Done generating aircraft configuration.\n')