% Analyze mission(2) 2 physics
% Created 18 October 2025 by Liam Trzebunia

fprintf('Verifying Mission 2 feasibility for %s... \n', iterName)
%% 1. Static Stability (M2)

if continue_mission_analysis.value

    fprintf('Analyzing Mission 2 static stability for %s... \n', iterName)

    % use SI units when calling static stability analysis function (however angles are in degrees)
    mission(2).physics.X_NP.units = 'm';
    mission(2).physics.X_NP.type = "length";
    mission(2).physics.X_NP.description = "X location of neutral point according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at x = LE of wing, y dividing the aircraft symmetrically in two, and z in line with the motor shaft axis.";
    mission(2).physics.CL_trim(1).units = '';
    mission(2).physics.CL_trim(1).type = "non";

    ii = length(assumptions) + 1;
    assumptions(ii).name = "Total Lift Approximation";
    assumptions(ii).description = "Assume that total trimmed lift coefficient for all lifting surfaces approximately equals total trimmed lift coefficient for entire aircraft";
    assumptions(ii).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
    assumptions(ii).responsible_engineer = "Liam Trzebunia";

    mission(2).physics.CL_trim(1).description = "total trimmed lift coefficient of aircraft (from static stability analysis)";
    mission(2).physics.v_trim.units = 'm/s';
    mission(2).physics.v_trim.type = "vel";
    mission(2).physics.v_trim.description = "freestream velocity during trimmed flight (from static stability function)";
    mission(2).physics.alpha_trim.units = 'deg';
    mission(2).physics.alpha_trim.type = "ang";
    mission(2).physics.alpha_trim.description = "angle of attack (with respect to fuselage reference line) during trimmed flight";
    mission(2).physics.stability.static.failure.units = '';
    mission(2).physics.stability.static.failure.type = "non";
    mission(2).physics.stability.static.failure.description = "discrete value indicating the presence and mode of static failure: 0 = statically stable, 1 = inadequate pitching moment coefficient gradient (bad Cm_alpha), and 2 = inadequate trimmed lift coefficient (bad CL_trim)";

    structNames = ["aircraft.loaded.XYZ_CG";
        "aircraft.loaded.weight";
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
        "mission(2).weather.air_density"];
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

    [aircraft, mission] = conv_aircraft_units(aircraft, mission, structNames, desiredUnits);

    unitsAgree = [strcmp(string(aircraft.loaded.XYZ_CG.units), "m");
        strcmp(string(aircraft.loaded.weight.units), "N");
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
        strcmp(string(mission(2).weather.air_density.units), "kg/m^3")];

    if all(unitsAgree)
        % capture assumptions embedded in the static stability analysis function call
        ii = length(assumptions) + 1;
        assumptions(ii).name = "Wing-Body System Zero-Lift Pitching Moment Coefficient Approximation";
        assumptions(ii).description = "Assume that the Cm0 of the wing approximately equals the Cm0 of the wing-body system";
        assumptions(ii).rationale = "Zero-lifting pitching moment coefficient for fuselage seems laborious to model although it would be feasible to do so";
        assumptions(ii).responsible_engineer = "Liam Trzebunia";

        % call static stability analysis function
        [mission(2).physics.X_NP.value,...
            mission(2).physics.CL_trim(1).value,...
            mission(2).physics.v_trim.value,...
            mission(2).physics.alpha_trim.value,...
            mission(2).physics.stability.static.failure.value,...
            failure_message] = StaticStab(aircraft.loaded.XYZ_CG.value(1),... % m
            aircraft.loaded.weight.value,... % N
            aircraft.wing.S.value,... % m^2
            aircraft.wing.b.value,... % m
            aircraft.tail.d_tail.value,... % m
            aircraft.tail.horizontal.i_tail.value,... % deg
            aircraft.tail.horizontal.c.value,... % m
            aircraft.tail.horizontal.c.value,... % m
            aircraft.tail.horizontal.b.value,... % m
            aircraft.wing.a_wb.value,... % /deg
            aircraft.tail.horizontal.a.value,... % /deg
            aircraft.wing.alpha_0L_wb.value,... % deg
            aircraft.wing.Cm0.value,... % non
            mission(2).weather.air_density.value); % kg/m^3
    else
        error('Unit mismatch: static stability analysis not possible. For convention, ensure static stability analysis functions are called with SI units (except for angles, which should use degrees rather than radians).')
    end

    fprintf('Completed Mission 2 static stability analysis for %s\n', iterName)

    % move on to another design if needed (and explain why)
    if mission(2).physics.stability.static.failure.value ~= 0
        continue_mission_analysis.value = false;
        % failure message already assigned by static stability function, just
        % need to print it out
        fprintf('%s\nRejecting Aircraft-Mission Combination %d.%d.\n', failure_message, aircraftIteration, missionIteration)
    else
        clear failure_message
    end

end

% for TESTING ONLY, DELETE later: run other analyses even if the design
% failed
continue_mission_analysis.value = true;

%% 2. Dynamic Stability (M2)
if continue_mission_analysis.value
    fprintf('Analyzing Mission 2 dynamic stability for %s...\n', iterName);
    USETORUN_RunDymanicStab % run dynamic stability analysis

    fprintf('Completed Mission 2 dynamic stability analysis for %s\n', iterName)

    % interpret dynamic stability results
    if Static_failure ~= 0 || Trim_failure ~= 0 || dynamic_failure_mode ~= 0
        continue_mission_analysis.value = false;
        if Static_failure ~=0
            failure_message = "Static Stability Failed! The CG is behind the NP";
        elseif Trim_failure ~= 0
            failure_message = "Static Stability Failed! The aircraft is statically stable but trims at a negative lift";
        elseif dynamic_failure_mode ~= 0
            switch dynamic_failure_mode
                case eigen_key
                    failure_message = "Dynamic Stability Failed! AVL eigenvalue output does not show the expected 5 Dynamic modes. Double-check that your mass and inertia values make sense. Possible Fix - Increase your I_yy and/or I_zz values and ensure they are reflecting the wing/tail placements\.";
                case phugoid_key
                    failure_message = "Dynamic Stability Failed! Phugoid mode is undamped. Possible Fix - Move your NP closer to your CG. An overly statically stable aircraft is often dynamically unstable.";
                case dutch_roll_key
                    failure_message = "Dynamic Stability Failed! Dutch Roll mode is undamped. Possible Fix - Decrease Wing Sweep and/or dihedral.";
                case SPO_key
                    failure_message = "Dynamic Stability Failed! SPO mode is underdamped. Possible Fix - Move lifting surfaces farther from CG.";
                case spiral_key
                    failure_message = "Dynamic Stability Failed! Spiral mode is undamped. Possible Fix - Decrease Tail Fin Size and/or Increase Dihedral. Spiral is caused by strong directional stability and weak lateral stability.";
                case roll_key
                    failure_message = "Dynamic Stability Failed! Rolling mode is underdamped\n. Possible Fix - Increase Wing Dihedral.";
            end
        end
        fprintf('%s\nRejecting Aircraft-Mission Combination %d.%d.\n', failure_message, aircraftIteration, missionIteration);
    end
end

%% 3. Structures (M2)
if continue_mission_analysis.value
    fprintf('Analyzing Mission 2 structural integrity for %s...\n', iterName)

    structNames = ["mission(2).physics.alpha_trim";
        "aircraft.wing.alpha_0L_wb"];
    desiredUnits = ["rad";
        "rad"];

    [aircraft, mission] = conv_aircraft_units(aircraft, mission, structNames, desiredUnits);

    unitsAgree = [strcmp(string(aircraft.wing.b.units), "m");
        strcmp(string(aircraft.wing.c.units), "m");
        strcmp(string(mission(2).physics.alpha_trim.units), "rad");
        strcmp(string(aircraft.wing.a0.units), "/rad");
        strcmp(string(aircraft.wing.alpha_0L_wb.units), "rad");
        strcmp(string(mission(2).physics.v_trim.units), "m/s");
        strcmp(string(aircraft.unloaded.weight.units), "N");
        strcmp(string(aircraft.loaded.weight.units), "N")];
    % no need to programatically check units of propeller data
    % (aircraft.propulsion.propeller.data), they were checked manually against
    % the spreadsheet

    % W_loaded
    % W_ref, b_w, c_w, b_t, c_t, l_fuse, t_ref, d_fuse, A_banner, AR_banner

    if all(unitsAgree)

        [mission(2).physics.G.max.value, ...
            ~, ...
            ~, ...
            mission(2).structures.num_fasteners.minimum.value, ...
            mission(2).physics.turn_radius.minimum.value, ...
            mission(2).physics.bank_angle.maximum.value, ...
            mission(2).physics.CL_trim(3).value] = structures_MDAO(aircraft.wing.b.value, ...
            aircraft.wing.c.value, ...
            mission(2).physics.alpha_trim.value, ...
            aircraft.wing.a0.value, ...
            aircraft.wing.alpha_0L_wb.value, ...
            mission(2).physics.v_trim.value, ...
            aircraft.unloaded.weight.value, ...
            aircraft.loaded.weight.value);

        mission(2).physics.G.max.units = 'G''s';
        mission(2).physics.G.max.type = "acc";
        mission(2).physics.G.max.description = "maximum number of G's the airframe can withstand (estimated) during the mission(2)";
        mission(2).structures.num_fasteners.minimum.units = '';
        mission(2).structures.num_fasteners.minimum.type = "non";
        mission(2).structures.num_fasteners.minimum.description = "minimum number of fasteners required to avoid wing pullout (conservative estimate)";
        mission(2).physics.turn_radius.minimum.units = 'm';
        mission(2).physics.turn_radius.minimum.type = "length";
        mission(2).physics.turn_radius.minimum.description = "minimum turn radius corresponding to maximum bank angle for the present mission(2)";
        mission(2).physics.bank_angle.maximum.units = "deg";
        mission(2).physics.bank_angle.maximum.type = "ang";
        mission(2).physics.bank_angle.maximum.description = "maximum bank angle corresponding to minimum turn radius for the present mission(2)";
        mission(2).physics.CL_trim(3).units = '';
        mission(2).physics.CL_trim(3).type = "non";
        mission(2).physics.CL_trim(3).description = "trimmed lift coefficient outputted from Lift_Distr function called in structural analysis";
    else
        error('Unit mismatch: propulsion analysis not possible.')
    end

    fprintf('Completed Mission 2 structural integrity analysis for %s\n', iterName)

    % turn radius sometimes turns out to be less than zero for negative lift coefficients. In
    % reality, this structures function should always be called after
    % stability anlysis has weeded out designs with negative lift.
    if mission(2).physics.turn_radius.minimum.value < 0 || mission(2).structures.num_fasteners.minimum.value > constants.wing.max_num_fasteners.value || mission(2).physics.bank_angle.value > 90
        continue_mission_analysis.value = false;
        if mission(2).structures.num_fasteners.minimum.value > constants.wing.max_num_fasteners.value
            failure_message = sprintf("Design would notionally require at least %d fasteners, more than the allotted maximum of %d.", mission(2).structures.num_fasteners.minimum.value, constants.wing.max_num_fasteners.value);
            % UNCOMMENT THE FOLLOWING 2 LINES AFTER TESTING
            % else
            %     error('A design has failed, but no failure message is defined. The structural analysis function was likely invoked to analyze a design that trims at a negative lift coefficient. Consider analyzing stability upstream of the structural analysis. Alternatively, define a failure message for the structural failure mode in question.')
        end
        fprintf('%s\nRejecting Aircraft-Mission Combination %d.%d.\n', failure_message, aircraftIteration, missionIteration);
    end

end

continue_mission_analysis.value = true; % for testing only

%% 4. Aerodynamics (M2)
if continue_mission_analysis.value
    fprintf('Analyzing Mission 2 aerodynamics for %s...\n', iterName)

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

    [aircraft, mission] = conv_aircraft_units(aircraft, mission, structNames, desiredUnits);

    unitsAgree = [strcmp(string(aircraft.loaded.weight.units), "N");
        strcmp(string(mission(2).physics.v_trim.units), "m/s");
        strcmp(string(mission(2).physics.CL_trim.units), "");
        strcmp(string(aircraft.wing.b.units), "m");
        strcmp(string(aircraft.wing.c.units), "m");
        strcmp(string(aircraft.tail.horizontal.b.units), "m");
        strcmp(string(aircraft.tail.horizontal.c.units), "m");
        strcmp(string(aircraft.fuselage.length.units), "m");
        strcmp(string(aircraft.fuselage.diameter.units), "m");
        strcmp(string(aircraft.banner.area.units), "m^2");
        strcmp(string(aircraft.banner.AR.units), "");
        strcmp(string(mission(2).physics.alpha_trim.units), "deg");
        strcmp(string(aircraft.wing.alpha_stall.units), "deg");
        strcmp(string(aircraft.wing.a_wb.units), "/deg");
        strcmp(string(aircraft.wing.resting_angle.units), "deg");
        strcmp(string(aircraft.wing.alpha_0L_wb.units), "deg");
        strcmp(string(aircraft.tail.horizontal.resting_angle.units), "deg");
        strcmp(string(aircraft.tail.horizontal.a.units), "/deg");
        strcmp(string(aircraft.tail.horizontal.alpha_0L_t.units), "deg")];

    % W_loaded
    % W_ref, b_w, c_w, b_t, c_t, l_fuse, t_ref, d_fuse, A_banner, AR_banner

    if all(unitsAgree)

        [mission(2).physics.L(1).value, ...
            mission(2).physics.L(2).value, ...
            mission(2).physics.D.value, ...
            mission(2).physics.CD_trim.value, ...
            mission(2).physics.CL_trim(2).value, ...
            mission(2).physics.v_stall.value, ...
            speed_boolean, ...
            alpha_boolean] = AeroCode_2(aircraft.loaded.weight.value, ...
            mission(2).physics.v_trim.value, ...
            mission(2).physics.CL_trim(1).value, ...
            aircraft.wing.b.value, ...
            aircraft.wing.c.value, ...
            aircraft.tail.horizontal.b.value, ...
            aircraft.tail.horizontal.c.value, ...
            aircraft.fuselage.length.value, ...
            aircraft.fuselage.diameter.value, ...
            0, ...
            1, ...
            mission(2).physics.alpha_trim.value, ...
            aircraft.wing.alpha_stall.value, ...
            aircraft.wing.a_wb.value, ...
            aircraft.wing.resting_angle.value, ...
            aircraft.wing.alpha_0L_wb.value, ...
            aircraft.tail.horizontal.a.value, ...
            aircraft.tail.horizontal.resting_angle.value, ...
            aircraft.tail.horizontal.alpha_0L_t.value);

        mission(2).physics.L(1).units = 'N';
        mission(2).physics.L(1).type = "force";
        mission(2).physics.L(1).description = "trimmed lift";

        mission(2).physics.L(2).units = 'N';
        mission(2).physics.L(2).type = "force";
        mission(2).physics.L(2).description = "trimmed lift (alternate method)";

        mission(2).physics.D.units = 'N';
        mission(2).physics.D.type = "force";
        mission(2).physics.D.description = "drag force during trimmed flight";

        mission(2).physics.CD_trim.units = '';
        mission(2).physics.CD_trim.type = "non";
        mission(2).physics.CD_trim.description = "drag coefficient during trimmed flight";

        mission(2).physics.CL_trim(2).units = '';
        mission(2).physics.CL_trim(2).type = "non";
        mission(2).physics.CL_trim(2).description = "trimmed lift coefficient (from aerodynamics analysis)";

        mission(2).physics.v_stall.units = 'm/s';
        mission(2).physics.v_stall.type = "vel";
        mission(2).physics.v_stall.description = "stall speed of 3D aircraft";
    else
        error('Unit mismatch: aerodynamic analysis not possible.')
    end

    fprintf('Completed Mission 2 aerodynamics analysis for %s\n', iterName)

    if ~speed_boolean || ~alpha_boolean
        continue_mission_analysis.value = false;
        if ~speed_boolean && alpha_boolean
            failure_message = "Trimmed airspeed is less than stall speed, meaning the aircraft will stall during flight.";
        elseif ~alpha_boolean && speed_boolean
            failure_message = "Trimmed angle of attack is greater than stall angle, meaning the aircraft will stall during flight.";
        elseif ~alpha_boolean && ~speed_boolean
            failure_message = "Trimmed airspeed is less than stall speed, meaning the aircraft will stall during flight. Also, trimmed angle of attack is greater than stall angle, which is another reason for stall.";
        end
        fprintf('%s\nRejecting Aircraft-Mission Combination %d.%d.\n', failure_message, aircraftIteration, missionIteration);
    end

end

% for TESTING ONLY, DELETE later: run other analyses even if the design
% failed
continue_mission_analysis.value = true;

%% 5. Propulsion (M2)

if continue_mission_analysis.value
    fprintf('Analyzing Mission 2 propulsion system for %s...\n', iterName)

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

    [aircraft, mission] = conv_aircraft_units(aircraft, mission, structNames, desiredUnits);

    unitsAgree = [strcmp(string(aircraft.loaded.weight.units), "N");
        strcmp(string(mission(2).physics.D.units), "N");
        strcmp(string(aircraft.propulsion.battery.capacity.units), "Wh");
        strcmp(string(mission(2).physics.v_trim.units), "m/s");
        strcmp(string(aircraft.propulsion.motor.voltage.max.units), "V");
        strcmp(string(aircraft.propulsion.motor.kV.units), "RPM/V");
        strcmp(string(aircraft.propulsion.motor.resistance.units), "ohm");
        strcmp(string(aircraft.propulsion.motor.current.no_load.units), "A");
        strcmp(string(aircraft.propulsion.motor.current.max.units), "A");
        strcmp(string(aircraft.propulsion.motor.power.max.units), "W")];
    % no need to programatically check units of propeller data
    % (aircraft.propulsion.propeller.data), they were checked manually against
    % the spreadsheet

    % W_loaded
    % W_ref, b_w, c_w, b_t, c_t, l_fuse, t_ref, d_fuse, A_banner, AR_banner

    if all(unitsAgree)

        [aircraft.physics.P_trim.value, ...
            aircraft.physics.max_flight_time.value, ...
            mission(2).physics.TW_ratio.value, ...
            mission(2).physics.RPM.value, ...
            mission(2).physics.propulsion.FOS.value, ...
            safetyCheck, ...
            RPM_exists] = PropulsionCalc(aircraft.loaded.weight.value, ...
            mission(2).physics.D.value, ...
            aircraft.propulsion.battery.capacity.value, ...
            mission(2).physics.v_trim.value, ...
            aircraft.propulsion.motor.voltage.max.value, ...
            aircraft.propulsion.motor.kV.value, ...
            aircraft.propulsion.motor.resistance.value, ...
            aircraft.propulsion.motor.current.no_load.value, ...
            aircraft.propulsion.motor.current.max.value, ...
            aircraft.propulsion.motor.power.max.value, ...
            aircraft.propulsion.propeller.data.value);

        aircraft.physics.P_trim.units = 'W';
        aircraft.physics.P_trim.type = "pow";
        aircraft.physics.P_trim.description = "power utilized during cruise";
        aircraft.physics.max_flight_time.units = 's';
        aircraft.physics.max_flight_time.type = "time";
        aircraft.physics.max_flight_time.description = "maximum cruising flight time according to propulsion analysis";
        mission(2).physics.TW_ratio.units = '';
        mission(2).physics.TW_ratio.type = "non";
        mission(2).physics.TW_ratio.description = "thrust-to-weight ratio of aircraft for the current mission(2) being considered. Note that this will change from mission(2) to mission(2)";
        mission(2).physics.RPM.units = "RPM";
        mission(2).physics.RPM.type = "angvel"; % angular velocity dimensional type
        mission(2).physics.RPM.description = "RPM of motor in cruise for the mission(2) being considered";
        mission(2).physics.propulsion.FOS.units = '';
        mission(2).physics.propulsion.FOS.type = "non";
        mission(2).physics.propulsion.FOS.description = "factors of safety of the Voltage, Current, and Power for the propulsion system";
    else
        error('Unit mismatch: propulsion analysis not possible.')
    end

    fprintf('Completed Mission 2 propulsion system analysis for %s\n', iterName)

    if ~safetyCheck || ~RPM_exists
        continue_mission_analysis.value = false;
        if ~RPM_exists
            failure_message = "No motor RPM was found matching the required trim speed.";
        else
            failure_message = "Propulsion system has insufficient electrical factors of safety.";
        end
        fprintf('%s\nRejecting Aircraft-Mission Combination %d.%d.\n', failure_message, aircraftIteration, missionIteration);
    end

end

% for TESTING ONLY, DELETE later: run other analyses even if the design
% failed
continue_mission_analysis.value = true;

fprintf('Completed verification of Mission 2 feasibility.\n')