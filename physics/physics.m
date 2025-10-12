% Check whether an aircraft design - mission strategy combination is
% physically feasible
% Created by Liam Trzebunia-Niebies on 7 October 2025

fprintf('Verifying Mission 2 feasibility... \n')

% P       = 1;
% C       = 1;
% L       = 1; 
% BL      = 1;
% TPBC    = 75;

%% 1. Static Stability (M2)
fprintf('Running static stability checks for loaded aircraft (Mission 2)... \n')

% X_CG, 
% aircraft.weight.loaded.value
mission.weather.air_density.value % from getMission
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


aircraft.horizontal.a.units = '/rad';
aircraft.horizontal.a.description = "3D lift-curve slope of horizontal tail";
[aircraft.tail.horizontal.a.value,...
    ~,...
    ~,...
    ~,...
    ~] = CL_alpha(aircraft.tail.horizontal.b.value,...
    aircraft.tail.horizontal.c.value,...
    aircraft.fuselage.diameter.value, ...
    0,...
    aircraft.tail.airfoil_name);

a_wb,alpha_0L_wb,C_M0_wb % from CL_alpha for wing
% a_wb needs to be converted from /rad to /deg before calling static stab 
% alpha_0L_wb needs to be converted from rad to 
a_tail % from CL_alpha for tail

fprintf('Completed static stability checks for loaded aircraft (Mission 2).\n')

%% 2. Aerodynamics (M2)

%% 3. Propulsion (M2)

%% 4. Structures (M2)

%% 5. Dynamic Stability (M2)

fprintf('Completed verification of Mission 2 feasibility.\n')

