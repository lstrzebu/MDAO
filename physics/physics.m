% Check whether an aircraft design - mission strategy combination is
% physically feasible
% Created by Liam Trzebunia-Niebies on 7 October 2025

if aircraft.continue_design_analysis.value == true

fprintf('Verifying Mission 2 feasibility... \n')

% P       = 1;
% C       = 1;
% L       = 1; 
% BL      = 1;
% TPBC    = 75;

%% 1. Static Stability (M2)
fprintf('Running static stability checks for loaded aircraft (Mission 2)... \n')

% aircraft.physics.X_CG.value = 1;
% aircraft.physics.X_CG.units = 'm';
% aircraft.physics.X_CG.description = "X coordinate for CG location according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at LE of wing";
% aircraft.physics.X_CG.type = "length";
% aircraft.loaded.weight.value
% mission.weather.air_density.value % from getMission
% S,b,d_tail,i_t,C_r_ht,C_t_ht,b_ht % from getAircraft


assumptions(end+1).name = "Wing-Body System Lift-Curve Slope Approximation";
assumptions(end+1).description = "Assume that lift-curve slope of the wing approximately equals the lift-curve slope of the wing-body system";
assumptions(end+1).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.a_wb.units = '/rad';
aircraft.wing.a_wb.type = "recang"; % reciprocal angle unit type
aircraft.wing.a_wb.description = "3D lift-curve slope of wing";
aircraft.wing.Cm0.units = '';
aircraft.wing.Cm0.type = "non"; % nondimensional unit type
aircraft.wing.Cm0.description = "pitching moment coefficient at zero lift for wing";
aircraft.wing.alpha_0L_wb.units = 'rad';
aircraft.wing.alpha_0L_wb.type = "ang";
aircraft.wing.alpha_0L_wb.description = "zero-lift angle for wing";

assumptions(end+1).name = "Wing-Body System Zero-Lift Angle Approximation";
assumptions(end+1).description = "Assume that zero-lift angle of the wing approximately equals the lift-curve slope of the wing-body system";
assumptions(end+1).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.alpha_stall.units = 'rad';
aircraft.wing.alpha_stall.type = "ang";
[aircraft.wing.a_wb.value,...
    aircraft.wing.Cm0.value,...
    aircraft.wing.alpha_0L_wb.value,...
    ~,...
    aircraft.wing.alpha_stall.value] = CL_alpha(aircraft.wing.b.value,...
    aircraft.wing.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.wing.airfoil_name);


aircraft.tail.horizontal.a.units = '/rad';
aircraft.tail.horizontal.a.type = "recang";
aircraft.tail.horizontal.a.description = "3D lift-curve slope of horizontal tail";
[aircraft.tail.horizontal.a.value,...
    ~,...
    ~,...
    ~,...
    ~] = CL_alpha(aircraft.tail.horizontal.b.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.tail.horizontal.airfoil_name);

% a_wb,alpha_0L_wb,C_M0_wb % from CL_alpha for wing
% a_wb needs to be converted from /rad to /deg before calling static stab 
% alpha_0L_wb needs to be converted from rad to 
% a_tail % from CL_alpha for tail



% use SI units when calling static stability analysis function (however angles are in degrees)
aircraft.physics.X_NP.units = 'm';
aircraft.physics.X_NP.type = "length";
aircraft.physics.X_NP.description = "X location of neutral point  according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at LE of wing";
aircraft.physics.CL_trim.units = '';
aircraft.physics.CL_trim.type = "non";

assumptions(end+1).name = "Total Lift Approximation";
assumptions(end+1).description = "Assume that total trimmed lift coefficient for all lifting surfaces approximately equals total trimmed lift coefficient for entire aircraft";
assumptions(end+1).rationale = "Lift effects of fuselage seem laborious to model although it would be feasible to do so";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.physics.CL_trim.description = "total trimmed lift coefficient of aircraft";
aircraft.physics.v_trim.units = 'm/s';
aircraft.physics.v_trim.type = "vel";
aircraft.physics.v_trim.description = "freestream velocity during trimmed flight";
aircraft.physics.alpha_trim.units = 'deg';
aircraft.physics.alpha_trim.type = "ang";
aircraft.physics.alpha_trim.description = "angle of attack (with respect to fuselage reference line) during trimmed flight";
aircraft.physics.stability.static.failure.units = '';
aircraft.physics.stability.static.failure.type = "non";
aircraft.physics.stability.static.failure.description = "discrete value indicating the presence and mode of static failure: 0 = statically stable, 1 = inadequate pitching moment coefficient gradient (bad Cm_alpha), and 2 = inadequate trimmed lift coefficient (bad CL_trim)";

% indicator of which type of unit conversion to use via the MATLAB Aerospace Toolbox: acc for acceleration units, vel for velocity units, etc: https://www.mathworks.com/help/aerotbx/unit-conversions-1.html


% start test %
% unitsAgree = [strcmp(string(aircraft.physics.X_CG.units), "m"); 
%     strcmp(string(aircraft.loaded.weight.units), "N");
%     strcmp(string(aircraft.wing.S.units), "m^2");
%     strcmp(string(aircraft.wing.b.units), "m");
%     strcmp(string(aircraft.tail.horizontal.d_tail.units), "m");
%     strcmp(string(aircraft.tail.horizontal.i_tail.units), "deg");
%     strcmp(string(aircraft.tail.horizontal.c.units), "m");
%     strcmp(string(aircraft.tail.horizontal.b.units), "m");
%     strcmp(string(aircraft.wing.a_wb.units), "/deg");
%     strcmp(string(aircraft.tail.horizontal.a.units), "/deg");
%     strcmp(string(aircraft.wing.alpha_0L_wb.units), "deg");
%     strcmp(string(aircraft.wing.Cm0.units), "");
%     strcmp(string(mission.weather.air_density.units), "kg/m^3")];

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
    "mission.weather.air_density"];

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

%variableTypes = 

% structName = "aircraft.physics.X_CG";
%variableType = "length";
% desiredUnits = "m";

% if length(structNames) == length(desiredUnits)
% 
%     for i = 1:length(structNames)
%         structName = structNames(i); 
%         desiredUnit = desiredUnits(i);
%         eval(sprintf('type = %s.type;', structName));
%         if ~strcmp(type, "non")
%             eval(sprintf('%s.value = conv%s(%s.value, %s.units, "%s");', structName, type, structName, structName, desiredUnit))
%             eval(sprintf('%s.units = "%s";', structName, desiredUnit))
%         end
%     end
% else
%     error('Function was called with mismatching input vectors. Input two vectors of the same length.')
% end

[aircraft, mission] = conv_aircraft_units(aircraft, mission, structNames, desiredUnits);
%mission = conv_aircraft_units(mission, missionStructNames, missionDesiredUnits);

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
    strcmp(string(mission.weather.air_density.units), "kg/m^3")];

% end test %

% aircraft.physics.X_CG.value = convlength(aircraft.physics.X_CG.value, aircraft.physics.X_CG.units, "m"); 
% aircraft.physics.X_CG.units = "m";

if all(unitsAgree)
    % capture assumptions embedded in the static stability analysis function call
    assumptions(end+1).name = "Wing-Body System Zero-Lift Pitching Moment Coefficient Approximation";
    assumptions(end+1).description = "Assume that the Cm0 of the wing approximately equals the Cm0 of the wing-body system";
    assumptions(end+1).rationale = "Zero-lifting pitching moment coefficient for fuselage seems laborious to model although it would be feasible to do so";
    assumptions(end+1).responsible_engineer = "Liam Trzebunia";

    % call static stability analysis function
    [aircraft.physics.X_NP.value,...
    aircraft.physics.CL_trim.value,...
    aircraft.physics.v_trim.value,...
    aircraft.physics.alpha_trim.value,...
    aircraft.physics.stability.static.failure.value,...
    failure_message] = StaticStab(aircraft.unloaded.XYZ_CG.value(1),... % m
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
    mission.weather.air_density.value); % kg/m^3
else
    error('Unit mismatch: static stability analysis not possible. For convention, ensure static stability analysis functions are called with SI units (except for angles, which should use degrees rather than radians).')
end

iterationNumber = 1; % for testing

% move on to another design if needed (and explain why)
if aircraft.physics.stability.static.failure.value ~= 0
    aircraft.continue_design_analysis = false;
    % failure message already assigned by static stability function, just
    % need to print it out
    fprintf('%s\nRejected Design %d.\n', failure_message, iterationNumber)
else
    clear failure_message
end

fprintf('Completed static stability checks for loaded aircraft (Mission 2).\n')

%% 2. Aerodynamics (M2)

% W_loaded 
% W_ref, b_w, c_w, b_t, c_t, l_fuse, t_ref, d_fuse, A_banner, AR_banner
% 
% [L, ...
%     L_2, ...
%     D, ...
%     C_D_Total, ...
%     CL_trim_tot, ...
%     V_stall, ... 
%     speed_boolean, ... 
%     alpha_boolean] = AeroCode_2(W, ...
%     V, ...
%     C_L_Total, ...
%     b_w, ...
%     c_w, ...
%     b_t, ...
%     c_t, ...
%     l_fuse, ...
%     d_fuse, ...
%     A_banner, ...
%     AR_banner, ...
%     alpha_trim, ...
%     stall_w, ...
%     CLa_w, ...
%     W_ref, ...
%     alphaL0_w, ...
%     Cla_t, ...
%     t_ref, ...
%     alphaL0_t);

%% 3. Propulsion (M2)

%% 4. Structures (M2)

%% 5. Dynamic Stability (M2)

if aircraft.continue_design_analysis
    USETORUN_RunDymanicStab % run dynamic stability analysis

% interpret dynamic stability results
if Static_failure ~= 0 || Trim_failure ~= 0 || dynamic_failure_mode ~= 0
    aircraft.continue_design_analysis = false;
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
    fprintf('%s\nRejected Design %dn', failure_message, iterationNumber);
end

end


fprintf('Completed verification of Mission 2 feasibility.\n')

else

    fprintf('Skipping Mission 2 analysis for rejected aircraft design.\n')

end
