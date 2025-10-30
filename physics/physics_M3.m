% Analyze Mission 3 physics
% Created 19 October 2025 by Liam Trzebunia

fprintf('Analyzing Mission %d feasibility for %s... \n', missionNumber, aircraftName)
%% 1. Static Stability (M3)
% if continue_mission_analysis.value
% 
%     fprintf('Analyzing Mission %d static stability for %s... \n', missionNumber, aircraftName)
% 
%     % use SI units when calling static stability analysis function (however angles are in degrees)
%     aircraft.missions.mission(3).physics.X_NP.units = 'm';
%     aircraft.missions.mission(3).physics.X_NP.type = "length";
%     aircraft.missions.mission(3).physics.X_NP.description = "X location of neutral point according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at x = LE of wing, y dividing the aircraft symmetrically in two, and z in line with the motor shaft axis.";
%     aircraft.missions.mission(3).CL_trim(1).units = '';
%     aircraft.missions.mission(3).CL_trim(1).type = "non";
% 
%     ii = length(assumptions) + 1;
%     assumptions(ii).name = "Total Lift Approximation";
%     assumptions(ii).description = "Assume that total trimmed lift coefficient for all lifting surfaces approximately equals total trimmed lift coefficient for entire aircraft";
%     assumptions(ii).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
%     assumptions(ii).responsible_engineer = "Liam Trzebunia";
% 
%     aircraft.missions.mission(3).CL_trim(1).description = "total trimmed lift coefficient of aircraft (from static stability analysis)";
%     aircraft.missions.mission(3).v_trim.units = 'm/s';
%     aircraft.missions.mission(3).v_trim.type = "vel";
%     aircraft.missions.mission(3).v_trim.description = "freestream velocity during trimmed flight (from static stability function)";
%     aircraft.missions.mission(3).alpha_trim.units = 'deg';
%     aircraft.missions.mission(3).alpha_trim.type = "ang";
%     aircraft.missions.mission(3).alpha_trim.description = "angle of attack (with respect to fuselage reference line) during trimmed flight";
%     aircraft.missions.mission(3).physics.stability.static.failure.units = '';
%     aircraft.missions.mission(3).physics.stability.static.failure.type = "non";
%     aircraft.missions.mission(3).physics.stability.static.failure.description = "discrete value indicating the presence and mode of static failure: 0 = statically stable, 1 = inadequate pitching moment coefficient gradient (bad Cm_alpha), and 2 = inadequate trimmed lift coefficient (bad CL_trim)";

    structNames = ["aircraft.unloaded.XYZ_CG";
        "aircraft.unloaded.weight";
        "aircraft.wing.S";
        "aircraft.wing.b";
        "aircraft.tail.d_tail";
        "aircraft.tail.horizontal.i_tail";
        "aircraft.tail.horizontal.c";
        "aircraft.tail.horizontal.b";
        "aircraft.wing.a_wb";
        "aircraft.tail.horizontal.a";
        "aircraft.wing.alpha_0L_wb";
        "aircraft.wing.Cm0";
        "aircraft.missions.mission(3).weather.air_density"];
    desiredUnits = ["m";
        "N";
        "m^2";
        "m";
        "m";
        "deg";
        "m";
        "m";
        "/deg";
        "/deg";
        "deg";
        "";
        "kg/m^3"];

    aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits, missionNumber);

    unitsAgree = [strcmp(string(aircraft.unloaded.XYZ_CG.units), "m");
        strcmp(string(aircraft.unloaded.weight.units), "N");
        strcmp(string(aircraft.wing.S.units), "m^2");
        strcmp(string(aircraft.wing.b.units), "m");
        strcmp(string(aircraft.tail.d_tail.units), "m");
        strcmp(string(aircraft.tail.horizontal.i_tail.units), "deg");
        strcmp(string(aircraft.tail.horizontal.c.units), "m");
        strcmp(string(aircraft.tail.horizontal.b.units), "m");
        strcmp(string(aircraft.wing.a_wb.units), "/deg");
        strcmp(string(aircraft.tail.horizontal.a.units), "/deg");
        strcmp(string(aircraft.wing.alpha_0L_wb.units), "deg");
        strcmp(string(aircraft.wing.Cm0.units), "");
        strcmp(string(aircraft.missions.mission(3).weather.air_density.units), "kg/m^3")];

    if all(unitsAgree)
        % Represent Static Stability Aircraft Variables as Vectors
        % the aircraft has a single wingspan for all missions considered, but in order to consider the missions in a vectorized manner (for runtime) that
        % wingspan must be presented as a nx1 vector (where n = number of missions)
        % rather than a scalar

        structNames = ["aircraft.missions.mission(3).weather.air_density",...
            "aircraft.unloaded.weight",...
            "aircraft.unloaded.XYZ_CG"];

        aircraft = vectorize_aircraft_params(aircraft, numMissionConfigs, structNames);

    %     % capture assumptions embedded in the static stability analysis function call
    %     ii = length(assumptions) + 1;
    %     assumptions(ii).name = "Wing-Body System Zero-Lift Pitching Moment Coefficient Approximation";
    %     assumptions(ii).description = "Assume that the Cm0 of the wing approximately equals the Cm0 of the wing-body system";
    %     assumptions(ii).rationale = "Zero-lifting pitching moment coefficient for fuselage seems laborious to model although it would be feasible to do so";
    %     assumptions(ii).responsible_engineer = "Liam Trzebunia";
    % 
    %     % call static stability analysis function
    %     [aircraft.missions.mission(3).physics.X_NP.value,...
    %         aircraft.missions.mission(3).CL_trim(1).value,...
    %         aircraft.missions.mission(3).v_trim.value,...
    %         aircraft.missions.mission(3).alpha_trim.value,...
    %         rejectedIndx, ...
    %         failure_messages] = StaticStab(aircraft.unloaded.XYZ_CG.value(:,1),... % m
    %         aircraft.unloaded.weight.value,... % N
    %         aircraft.wing.S.value,... % m^2
    %         aircraft.wing.b.value,... % m
    %         aircraft.tail.d_tail.value,... % m
    %         aircraft.tail.horizontal.i_tail.value,... % deg
    %         aircraft.tail.horizontal.c.value,... % m
    %         aircraft.tail.horizontal.c.value,... % m
    %         aircraft.tail.horizontal.b.value,... % m
    %         aircraft.wing.a_wb.value,... % /deg
    %         aircraft.tail.horizontal.a.value,... % /deg
    %         aircraft.wing.alpha_0L_wb.value,... % deg
    %         aircraft.wing.Cm0.value,... % non
    %         aircraft.missions.mission(3).weather.air_density.value,... % kg/m^3
    %         numMissionConfigs); 
    % else
    %     error('Unit mismatch: static stability analysis not possible. For convention, ensure static stability analysis functions are called with SI units (except for angles, which should use degrees rather than radians).')
    end

    % structNames_mission = [structNames_mission, ...
    %         "aircraft.missions.mission(3).weather.air_density",...
    %         % "aircraft.missions.mission(3).physics.X_NP",...
    %         "aircraft.missions.mission(3).CL_trim",...
    %         "aircraft.missions.mission(3).v_trim",...
    %         "aircraft.missions.mission(3).alpha_trim"]; % append additional variables to be updated as missions are eliminated
    % 
    % [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndx, failure_messages, structNames_mission, batteryIndex, missionNumber);
%     % if all missions have failed
%     if numMissionConfigs == 0
%         continue_mission_analysis.value = false;
%     end
%     fprintf('Completed Mission %d static stability analysis for %s. \n', missionNumber, aircraftName)
% end

%% 2. Dynamic Stability (M3)
if continue_mission_analysis.value
    fprintf('Analyzing Mission %d dynamic stability for %s... \n', missionNumber, aircraftName)
    USETORUN_RunDymanicStab % run dynamic stability analysis
    rejectedIndex = failure_messages ~= "";
    [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndex, failure_messages, structNames_mission, batteryIndex, missionNumber);
    if numMissionConfigs == 0
        continue_mission_analysis.value = false;
    end
    fprintf('Completed Mission %d dynamic stability analysis for %s. \n', missionNumber, aircraftName)
end

%% 3. Structures (M3)
if continue_mission_analysis.value
    fprintf('Analyzing Mission %d structural integrity for %s... \n', missionNumber, aircraftName)

    structNames = ["aircraft.missions.mission(3).alpha_trim";
        "aircraft.wing.alpha_0L_wb";
        "aircraft.wing.c"];
    desiredUnits = ["rad";
        "rad";
        "m"];

    aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits, missionNumber);
    %aircraft = vectorize_aircraft_params(aircraft, numMissionConfigs, ["aircraft.wing.c", "aircraft.wing.a0"]);

    unitsAgree = [strcmp(string(aircraft.wing.b.units), "m");
        strcmp(string(aircraft.wing.c.units), "m");
        strcmp(string(aircraft.missions.mission(3).alpha_trim.units), "rad");
        strcmp(string(aircraft.wing.a0.units), "/rad");
        strcmp(string(aircraft.wing.alpha_0L_wb.units), "rad");
        strcmp(string(aircraft.missions.mission(3).v_trim.units), "m/s");
        strcmp(string(aircraft.unloaded.weight.units), "N");
        strcmp(string(aircraft.unloaded.weight.units), "N")];

    if all(unitsAgree)

        [aircraft.missions.mission(3).physics.G.max.value, ...
            aircraft.missions.mission(3).structures.num_fasteners.minimum.value, ...
            aircraft.missions.mission(3).physics.turn_radius.minimum.value, ...
            ~, ...
            rejectedIndx, ...
            failure_messages] = structures_MDAO(aircraft.wing.b.value, ...
            aircraft.wing.c.value, ...
            aircraft.missions.mission(3).alpha_trim.value, ...
            aircraft.wing.a0.value, ...
            aircraft.wing.alpha_0L_wb.value, ...
            aircraft.missions.mission(3).v_trim.value, ...
            aircraft.unloaded.weight.value, ...
            aircraft.unloaded.weight.value, ...
            numMissionConfigs, ...
            constants.wing.max_num_fasteners.value);

        aircraft.missions.mission(3).physics.G.max.units = 'G''s';
        aircraft.missions.mission(3).physics.G.max.type = "acc";
        aircraft.missions.mission(3).physics.G.max.description = "maximum number of G's the airframe can withstand (estimated) during the aircraft.missions.mission(3)";
        aircraft.missions.mission(3).structures.num_fasteners.minimum.units = '';
        aircraft.missions.mission(3).structures.num_fasteners.minimum.type = "non";
        aircraft.missions.mission(3).structures.num_fasteners.minimum.description = "minimum number of fasteners required to avoid wing pullout (conservative estimate)";
        aircraft.missions.mission(3).physics.turn_radius.minimum.units = 'm';
        aircraft.missions.mission(3).physics.turn_radius.minimum.type = "length";
        aircraft.missions.mission(3).physics.turn_radius.minimum.description = "minimum turn radius corresponding to maximum bank angle for the present aircraft.missions.mission(3)";
        aircraft.missions.mission(3).physics.bank_angle.maximum.units = "deg";
        aircraft.missions.mission(3).physics.bank_angle.maximum.type = "ang";
        aircraft.missions.mission(3).physics.bank_angle.maximum.description = "maximum bank angle corresponding to minimum turn radius for the present aircraft.missions.mission(3)";
        % aircraft.missions.mission(3).CL_trim(3).units = '';
        % aircraft.missions.mission(3).CL_trim(3).type = "non";
        % aircraft.missions.mission(3).CL_trim(3).description = "trimmed lift coefficient outputted from Lift_Distr function called in structural analysis";
    else
        error('Unit mismatch: structural integrity analysis not possible.')
    end

    fprintf('Completed Mission %d structural analysis for %s. \n', missionNumber, aircraftName)
    
    structNames_mission = [structNames_mission,...
            "aircraft.missions.mission(3).physics.G.max", ...
            "aircraft.missions.mission(3).structures.num_fasteners.minimum", ...
            "aircraft.missions.mission(3).physics.turn_radius.minimum"]; % append additional vectorized aircraft parameters to be updated
   [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndx, failure_messages, structNames_mission, batteryIndex, missionNumber);
end

%% 4. Aerodynamics (M3)
if continue_mission_analysis.value
    fprintf('Analyzing Mission %d aerodynamics for %s... \n', missionNumber, aircraftName)

    structNames = ["aircraft.wing.c";
        "aircraft.fuselage.length";
        "aircraft.fuselage.diameter";
        "aircraft.wing.alpha_stall";
        "aircraft.tail.horizontal.alpha_0L_t";
        "aircraft.missions.mission(3).alpha_trim";
        "aircraft.wing.alpha_0L_wb"];
    desiredUnits = ["m";
        "m";
        "m";
        "deg";
        "deg";
        "deg";
        "deg"];

    aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits, missionNumber);

    unitsAgree = [strcmp(string(aircraft.unloaded.weight.units), "N");
        strcmp(string(aircraft.missions.mission(3).v_trim.units), "m/s");
        strcmp(string(aircraft.wing.b.units), "m");
        strcmp(string(aircraft.wing.c.units), "m");
        strcmp(string(aircraft.tail.horizontal.b.units), "m");
        strcmp(string(aircraft.tail.horizontal.c.units), "m");
        strcmp(string(aircraft.fuselage.length.units), "m");
        strcmp(string(aircraft.fuselage.diameter.units), "m");
        % strcmp(string(aircraft.banner.area.units), "m^2");
        strcmp(string(aircraft.missions.mission(3).alpha_trim.units), "deg");
        strcmp(string(aircraft.wing.alpha_stall.units), "deg");
        strcmp(string(aircraft.wing.a_wb.units), "/deg");
        strcmp(string(aircraft.wing.resting_angle.units), "deg");
        strcmp(string(aircraft.wing.alpha_0L_wb.units), "deg");
        strcmp(string(aircraft.tail.horizontal.resting_angle.units), "deg");
        strcmp(string(aircraft.tail.horizontal.a.units), "/deg");
        strcmp(string(aircraft.tail.horizontal.alpha_0L_t.units), "deg")];

    if all(unitsAgree)

        [aircraft.missions.mission(3).physics.L(1).value, ...
            aircraft.missions.mission(3).physics.L(2).value, ...
            aircraft.missions.mission(3).physics.D.value, ...
            aircraft.missions.mission(3).physics.CD_trim.value, ...
            ~, ...
            aircraft.missions.mission(3).physics.v_stall.value, ...
            rejectedIndx, ...
            failure_messages] = AeroCode_2(aircraft.unloaded.weight.value, ...
            aircraft.missions.mission(3).v_trim.value, ...
            aircraft.missions.mission(3).CL_trim(1).value, ...
            aircraft.wing.b.value, ...
            aircraft.wing.c.value, ...
            aircraft.tail.horizontal.b.value, ...
            aircraft.tail.horizontal.c.value, ...
            aircraft.fuselage.length.value, ...
            aircraft.fuselage.diameter.value, ...
            aircraft.missions.mission(3).alpha_trim.value, ...
            aircraft.wing.alpha_stall.value, ...
            aircraft.wing.a_wb.value, ...
            aircraft.wing.resting_angle.value, ...
            aircraft.wing.alpha_0L_wb.value, ...
            aircraft.tail.horizontal.a.value, ...
            aircraft.tail.horizontal.resting_angle.value, ...
            aircraft.tail.horizontal.alpha_0L_t.value, ...
            numMissionConfigs, ...
            missionNumber);

        aircraft.missions.mission(3).physics.L(1).units = 'N';
        aircraft.missions.mission(3).physics.L(1).type = "force";
        aircraft.missions.mission(3).physics.L(1).description = "trimmed lift";

        aircraft.missions.mission(3).physics.L(2).units = 'N';
        aircraft.missions.mission(3).physics.L(2).type = "force";
        aircraft.missions.mission(3).physics.L(2).description = "trimmed lift (alternate method)";

        aircraft.missions.mission(3).physics.D.units = 'N';
        aircraft.missions.mission(3).physics.D.type = "force";
        aircraft.missions.mission(3).physics.D.description = "drag force during trimmed flight";

        aircraft.missions.mission(3).physics.CD_trim.units = '';
        aircraft.missions.mission(3).physics.CD_trim.type = "non";
        aircraft.missions.mission(3).physics.CD_trim.description = "drag coefficient during trimmed flight";

        % aircraft.missions.mission(3).CL_trim(2).units = '';
        % aircraft.missions.mission(3).CL_trim(2).type = "non";
        % aircraft.missions.mission(3).CL_trim(2).description = "trimmed lift coefficient (from aerodynamics analysis)";

        aircraft.missions.mission(3).physics.v_stall.units = 'm/s';
        aircraft.missions.mission(3).physics.v_stall.type = "vel";
        aircraft.missions.mission(3).physics.v_stall.description = "stall speed of 3D aircraft";
    else
        error('Unit mismatch: aerodynamic analysis not possible.')
    end

    fprintf('Completed Mission %d aerodynamics analysis for %s... \n', missionNumber, aircraftName)

    structNames_mission = [structNames_mission, ...
        "aircraft.missions.mission(3).physics.L(1)", ...
            "aircraft.missions.mission(3).physics.L(2)", ...
            "aircraft.missions.mission(3).physics.D", ...
            "aircraft.missions.mission(3).physics.CD_trim", ...
            "aircraft.missions.mission(3).CL_trim", ...
            "aircraft.missions.mission(3).physics.v_stall"];
   [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndx, failure_messages, structNames_mission, batteryIndex, missionNumber);
end

%% 5. Propulsion (M3)
if continue_mission_analysis.value
    fprintf('Analyzing Mission %d propulsion system for %s... \n', missionNumber, aircraftName)

    structNames = ["aircraft.wing.c";
        "aircraft.fuselage.length";
        "aircraft.fuselage.diameter";
        "aircraft.wing.alpha_stall";
        "aircraft.tail.horizontal.alpha_0L_t"];
    desiredUnits = ["m";
        "m";
        "m";
        "deg";
        "deg"];

    aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits, missionNumber);

    unitsAgree = [strcmp(string(aircraft.unloaded.weight.units), "N");
        strcmp(string(aircraft.missions.mission(3).physics.D.units), "N");
        strcmp(string(aircraft.propulsion.battery.capacity.units), "Wh");
        strcmp(string(aircraft.missions.mission(3).v_trim.units), "m/s");
        strcmp(string(aircraft.propulsion.motor.voltage.max.units), "V");
        strcmp(string(aircraft.propulsion.motor.kV.units), "RPM/V");
        strcmp(string(aircraft.propulsion.motor.resistance.units), "ohm");
        strcmp(string(aircraft.propulsion.motor.current.no_load.units), "A");
        strcmp(string(aircraft.propulsion.motor.current.max.units), "A");
        strcmp(string(aircraft.propulsion.motor.power.max.units), "W")];
    % no need to programatically check units of propeller data
    % (aircraft.propulsion.propeller.data), they were checked manually against
    % the spreadsheet

    if all(unitsAgree)

        [aircraft.physics.P_trim.value, ...
            aircraft.physics.max_flight_time.value, ...
            aircraft.missions.mission(3).physics.TW_ratio.value, ...
            aircraft.missions.mission(3).physics.RPM.value, ...
            aircraft.missions.mission(3).physics.propulsion.FOS.value, ...
            rejectedIndx, ...
            failure_messages] = PropulsionCalc(aircraft.unloaded.weight.value, ...
            aircraft.missions.mission(3).physics.D.value, ...
            aircraft.propulsion.battery.capacity.value, ...
            aircraft.missions.mission(3).v_trim.value, ...
            aircraft.propulsion.motor.voltage.max.value, ...
            aircraft.propulsion.motor.kV.value, ...
            aircraft.propulsion.motor.resistance.value, ...
            aircraft.propulsion.motor.current.no_load.value, ...
            aircraft.propulsion.motor.current.max.value, ...
            aircraft.propulsion.motor.power.max.value, ...
            aircraft.propulsion.propeller.data.value, ...
            numMissionConfigs);

        aircraft.physics.P_trim.units = 'W';
        aircraft.physics.P_trim.type = "pow";
        aircraft.physics.P_trim.description = "power utilized during cruise";
        aircraft.physics.max_flight_time.units = 's';
        aircraft.physics.max_flight_time.type = "time";
        aircraft.physics.max_flight_time.description = "maximum cruising flight time according to propulsion analysis";
        aircraft.missions.mission(3).physics.TW_ratio.units = '';
        aircraft.missions.mission(3).physics.TW_ratio.type = "non";
        aircraft.missions.mission(3).physics.TW_ratio.description = "thrust-to-weight ratio of aircraft for the current aircraft.missions.mission(3) being considered. Note that this will change from aircraft.missions.mission(3) to aircraft.missions.mission(3)";
        aircraft.missions.mission(3).physics.RPM.units = "RPM";
        aircraft.missions.mission(3).physics.RPM.type = "angvel"; % angular velocity dimensional type
        aircraft.missions.mission(3).physics.RPM.description = "RPM of motor in cruise for the aircraft.missions.mission(3) being considered";
        aircraft.missions.mission(3).physics.propulsion.FOS.units = '';
        aircraft.missions.mission(3).physics.propulsion.FOS.type = "non";
        aircraft.missions.mission(3).physics.propulsion.FOS.description = "factors of safety of the Voltage, Current, and Power for the propulsion system";
    else
        error('Unit mismatch: propulsion analysis not possible.')
    end

    structNames_mission = [structNames_mission, ...
        "aircraft.physics.P_trim", ...
        "aircraft.physics.max_flight_time", ...
        "aircraft.missions.mission(3).physics.TW_ratio", ...
        "aircraft.missions.mission(3).physics.RPM", ...
        "aircraft.missions.mission(3).physics.propulsion.FOS"];

    [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndx, failure_messages, structNames_mission, batteryIndex, missionNumber);
    if numMissionConfigs == 0
        continue_mission_analysis.value = false;
    end
    fprintf('Completed Mission %d propulsion analysis for %s... \n', missionNumber, aircraftName)
end
fprintf('Completed Mission %d feasibility analysis for %s. \n', missionNumber, aircraftName)

%% Flight Time Checks
linear_length = 304.8; % 1000ft converted to m (from rules)
if strcmp(string(aircraft.missions.mission(3).physics.turn_radius.minimum.units), "m")
    radius = aircraft.missions.mission(3).physics.turn_radius.minimum.value;
end
nLaps = missions(:,3);
flight_distance = nLaps.*(linear_length*2 + 2.*(pi.*radius.^2)); % [m], accounts for cruising distance + two full turns per lap at maximum bank angle
if strcmp(string(aircraft.missions.mission(3).v_trim.units), "m/s")
    v_trim = aircraft.missions.mission(3).v_trim.value;
    flight_time = flight_distance./v_trim;
end
if strcmp(string(aircraft.physics.max_flight_time.units), "s")
max_flight_time_batteryPower = aircraft.physics.max_flight_time.value;
end
max_flight_time_DBFrules = 5*60; % 5 minute duration for mission 2

rejectedIndx_batteryPower = flight_time > max_flight_time_batteryPower & flight_time <= max_flight_time_DBFrules;
rejectedIndx_DBFrules = flight_time > max_flight_time_DBFrules & flight_time <= max_flight_time_batteryPower;
rejectedIndx_both = flight_time > max_flight_time_DBFrules & flight_time > max_flight_time_batteryPower; 

failure_messages = strings([numMissionConfigs, 1]);
if all(sum([rejectedIndx_batteryPower, rejectedIndx_DBFrules, rejectedIndx_both], 2) <= 1) % make sure no row is being set to true for multiple arrays
    failure_messages(rejectedIndx_batteryPower) = sprintf("Mission 2 flight time exceeds maximum allowable flight time (by battery)."); 
    failure_messages(rejectedIndx_DBFrules) = "Mission 2 flight time exceeds maximum allowable flight time (by competition rules).";
    failure_messages(rejectedIndx_both) = "Mission 2 flight time exceeds maximum allowable flight time both by battery and by competition rules.";
    rejectedIndex = any([rejectedIndx_both, rejectedIndx_batteryPower, rejectedIndx_DBFrules], 2);
else
    error('An error in conditional logic has been made. Check the failure logic for Mission 2 maximum flight time. Multiple mutually exclusive failure modes are being triggered simultaneously.')
end

[aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndx, failure_messages, structNames_mission, batteryIndex, missionNumber);

if numMissionConfigs == 0
    continue_mission_analysis.value = false;
end