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

aircraft.dynamics.X_CG.value = 1;
aircraft.dynamics.X_CG.units = 'm';
aircraft.dynamics.X_CG.description = "X coordinate for CG location according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at LE of wing";
% aircraft.weight.loaded.value
% mission.weather.air_density.value % from getMission
% S,b,d_tail,i_t,C_r_ht,C_t_ht,b_ht % from getAircraft


assumptions.wing.a_wb = "Assume that lift-curve slope of the wing approximately equals the lift-curve slope of the wing-body system";
aircraft.wing.a_wb.units = '/rad';
aircraft.wing.a_wb.description = "3D lift-curve slope of wing";
aircraft.wing.Cm0.units = '';
aircraft.wing.Cm0.description = "pitching moment coefficient at zero lift for wing";
aircraft.wing.alpha_0L_wb.units = 'rad';
aircraft.wing.alpha_0L_wb.description = "zero-lift angle for wing";
assumptions.wing.alpha_0L_wb = "Assume that zero-lift angle of the wing approximately equals zero-lift angle of the wing-body system";
aircraft.wing.alpha_stall.units = 'rad';
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
aircraft.tail.horizontal.a.description = "3D lift-curve slope of horizontal tail";
[aircraft.tail.horizontal.a.value,...
    ~,...
    ~,...
    ~,...
    ~] = CL_alpha(aircraft.tail.horizontal.b.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.tail.airfoil_name);

% a_wb,alpha_0L_wb,C_M0_wb % from CL_alpha for wing
% a_wb needs to be converted from /rad to /deg before calling static stab 
% alpha_0L_wb needs to be converted from rad to 
% a_tail % from CL_alpha for tail



% use all SI units when calling static stability analysis function
% all angles for static stability analysis are in degrees
aircraft.dynamics.X_NP.units = 'm';
aircraft.dynamics.X_NP.description = "X location of neutral point  according to AVL coordinate system: x positive rear, y positive to the right hand wing, and z positive up. Origin at LE of wing";
aircraft.dynamics.CL_trim.units = '';
assumptions.dynamics.CL_trim = "assume that total trimmed lift coefficient for all lifting surfaces approximately equals total trimmed lift coefficient for entire aircraft";
aircraft.dynamics.CL_trim.description = "total trimmed lift coefficient of aircraft";
aircraft.dynamics.v_trim.units = 'm/s';
aircraft.dynamics.v_trim.description = "freestream velocity during trimmed flight";
aircraft.dynamics.alpha_trim.units = 'deg';
aircraft.dynamics.alpha_trim.description = "angle of attack (with respect to fuselage reference line) during trimmed flight";
aircraft.dynamics.stability.static.failure.units = '';
aircraft.dynamics.stability.static.failure.description = "discrete value indicating the presence and mode of static failure: 0 = statically stable, 1 = inadequate pitching moment coefficient gradient (bad Cm_alpha), and 2 = inadequate trimmed lift coefficient (bad CL_trim)";

unitsAgree = [strcmp(string(aircraft.dynamics.X_CG.units), "m"); 
    strcmp(string(aircraft.weight.loaded.units), "N");
    strcmp(string(aircraft.wing.S.units), "m^2");
    strcmp(string(aircraft.wing.b.units), "m");
    strcmp(string(aircraft.tail.horizontal.d_tail.units), "m");
    strcmp(string(aircraft.tail.horizontal.i_tail.units), "deg");
    strcmp(string(aircraft.tail.horizontal.c.units), "m");
    strcmp(string(aircraft.tail.horizontal.b.units), "m");
    strcmp(string(aircraft.wing.a_wb.units), "/deg");
    strcmp(string(aircraft.tail.horizontal.a.units), "/deg");
    strcmp(string(aircraft.wing.alpha_0L_wb.units), "deg");
    strcmp(string(aircraft.wing.Cm0.units), "");
    strcmp(string(mission.weather.air_density.units), "kg/m^3")];

if all(unitsAgree)
    % capture assumptions embedded in the static stability analysis function call
    assumptions.wing.Cm0 = "assume that the Cm0 of the wing approximately equals the Cm0 of the wing-body system";

    % call static stability analysis function
    [aircraft.dynamics.X_NP.value,...
    aircraft.dynamics.CL_trim.value,...
    aircraft.dynamics.v_trim.value,...
    aircraft.dynamics.alpha_trim.value,...
    aircraft.dynamics.stability.static.failure.value] = StaticStab(aircraft.dynamics.X_CG.value,...
    aircraft.weight.loaded.value,...
    aircraft.wing.S.value,...
    aircraft.wing.b.value,...
    aircraft.tail.horizontal.d_tail.value,...
    aircraft.tail.horizontal.i_tail.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.tail.horizontal.b.value,...
    aircraft.wing.a_wb.value,...
    aircraft.tail.horizontal.a.value,...
    aircraft.wing.alpha_0L_wb.value,...
    aircraft.wing.Cm0.value,...
    mission.weather.air_density.value);
else
    error('Unit mismatch: static stability analysis not possible. For convention, ensure static stability analysis functions are called with SI units (except for angles, which should use degrees rather than radians).')
end

fprintf('Completed static stability checks for loaded aircraft (Mission 2).\n')

%% 2. Aerodynamics (M2)

%% 3. Propulsion (M2)

%% 4. Structures (M2)

%% 5. Dynamic Stability (M2)

fprintf('Completed verification of Mission 2 feasibility.\n')

else

    fprintf('Skipping Mission 2 analysis for rejected aircraft design.\n')

end
