cd 'physics\stability\Dynamic Stab' % enter flight stability directory (for AVL call)

design_title               = sprintf("%s", iterName);

file_name           = "QuackPack";

airfoil_file        = sprintf("%s.dat", aircraft.wing.airfoil_name);
% airfoil_file        = "clarky.dat";
% Htail_airfoil_file  = "n0012-TAIL.dat";
% Vtail_airfoil_file  = "n0012-TAIL.dat";
Htail_airfoil_file = sprintf("%s.dat", aircraft.tail.horizontal.airfoil_name);
Vtail_airfoil_file = sprintf("%s.dat", aircraft.tail.vertical.airfoil_name);

% tail_config = "C";
tail_config = string(aircraft.tail.config.value(1));

delete_files = true;

%% Wing Geometry

% mass    = 35;   % [kg]
switch missionNumber
    case 2 % mission 2... use parameters for loaded aircraft
        if strcmp(string(aircraft.loaded.mass.units), "kg")
            mass = aircraft.loaded.mass.value;
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end
    case 3 % mission 3... use parameters for unloaded aircraft
        if strcmp(string(aircraft.unloaded.mass.units), "kg")
            mass = aircraft.unloaded.mass.value;
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end
end

if strcmp(string(aircraft.wing.S.units), "m^2") && strcmp(string(aircraft.wing.b.units), "m")
    S = aircraft.wing.S.value;
    b = aircraft.wing.b.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end
% % Wing Properties
% S       = 5;    % Directly used for lift equation
% b       = 5;    % Between 3 ft and 5 ft

% dihedral_angle = 5; % [°]
if strcmp(string(aircraft.wing.dihedral.units), "deg")
    dihedral_angle = aircraft.wing.dihedral.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end

%% Tail Configuration Parameters

% Tail Position Properties
% d_tail  = 5; % Distance from LE of wing to LE of tail
if strcmp(string(aircraft.tail.d_tail.units), "m")
    d_tail = aircraft.tail.d_tail.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end

% i_t     = 3;
if strcmp(string(aircraft.tail.horizontal.i_tail.units), "deg")
    i_t = aircraft.tail.horizontal.i_tail.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end

switch missionNumber
    case 2 % mission 2... use parameters for loaded aircraft
        structNames = ["aircraft.tail.horizontal.skin.XYZ_CG";
            "aircraft.wing.skin.XYZ_CG";
            "aircraft.tail.horizontal.S";
            "aircraft.tail.vertical.S";
            "aircraft.loaded.MOI"];
    case 3 % mission 3... use parameters for unloaded aircraft
        structNames = ["aircraft.tail.horizontal.skin.XYZ_CG";
            "aircraft.wing.skin.XYZ_CG";
            "aircraft.tail.horizontal.S";
            "aircraft.tail.vertical.S";
            "aircraft.unloaded.MOI"];
end
desiredUnits = ["m"; "m"; "m^2"; "m^2"; "kg*m^2"];
[aircraft, ~] = conv_aircraft_units(aircraft, 0, structNames, desiredUnits);

% z-location of the tail
%z_tail  = 0.5;
if strcmp(tail_config, "C") && strcmp(string(aircraft.tail.horizontal.skin.XYZ_CG.units), "m") && strcmp(string(aircraft.wing.skin.XYZ_CG.units), "m") && strcmp(string(aircraft.tail.horizontal.c.units), "m")
    z_tail = aircraft.tail.horizontal.skin.XYZ_CG.value(3) - aircraft.wing.skin.XYZ_CG.value(3); % z distance between wing and horizontal tail
    C_r_fuselage = aircraft.tail.horizontal.c.value; % for conventional tail, the root chord of the part of the tail connected to the fuselage is the root chord of the horizontal tail
else
    error('Dynamic stability function must be rewritten to use tail types other than conventional.')
end

% C_r_fuselage = 0.75;

% Horizontal Tail Properties
%S_ht = 0.75;
if strcmp(string(aircraft.tail.horizontal.S.units), "m^2")
    S_ht = aircraft.tail.horizontal.S.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end

lambda_ht = aircraft.tail.horizontal.taper_ratio.value;
lambda_vt = aircraft.tail.vertical.taper_ratio.value;

% lambda_ht = 2/3;


% Vertical Tail Properties
%S_vt = 0.25;
if strcmp(string(aircraft.tail.vertical.S.units), "m^2")
    S_vt = aircraft.tail.vertical.S.value;
else
    error('Unit mismatch: dynamic stability analysis not possible.')
end


%% Mass Parameters

% Center of mass
% x_cm                = -0.4;         % [m]
% y_cm                = 0;            % [m]
% z_cm                = -0.1;         % [m]
switch missionNumber
    case 2
        if strcmp(string(aircraft.loaded.XYZ_CG.units), "m")
            x_cm = aircraft.loaded.XYZ_CG.value(1);
            y_cm = aircraft.loaded.XYZ_CG.value(2);
            z_cm = aircraft.loaded.XYZ_CG.value(3);
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end

        % I_matrix    = [1.9, 0, -0.5; ...
        %                0, 220, 0; ...
        %                -0.5, 0, 159.4];
        if strcmp(string(aircraft.loaded.MOI.units), "kg*m^2")
            I_matrix = aircraft.loaded.MOI.value;
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end

    case 3
        [aircraft, mission] = conv_aircraft_units(aircraft, mission, "aircraft.unloaded.XYZ_CG", "m");
        if strcmp(string(aircraft.unloaded.XYZ_CG.units), "m")
            x_cm = aircraft.unloaded.XYZ_CG.value(1);
            y_cm = aircraft.unloaded.XYZ_CG.value(2);
            z_cm = aircraft.unloaded.XYZ_CG.value(3);
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end

        % I_matrix    = [1.9, 0, -0.5; ...
        %                0, 220, 0; ...
        %                -0.5, 0, 159.4];
        if strcmp(string(aircraft.unloaded.MOI.units), "kg*m^2")
            I_matrix = aircraft.unloaded.MOI.value;
        else
            error('Unit mismatch: dynamic stability analysis not possible.')
        end

end

dynamic_failure_mode = 0; % assume no failure until proven otherwise

DynamicStab(design_title,file_name,airfoil_file,Htail_airfoil_file,Vtail_airfoil_file,tail_config,x_cm,y_cm,z_cm,mass,I_matrix,b,S,dihedral_angle,d_tail,z_tail,i_t,S_ht,S_vt,C_r_fuselage,lambda_ht,lambda_vt)

[X_NP,C_L0,C_D0,alpha_trim_FRL,C_Zw,C_Yw,C_lw,C_mw,C_nw,C_Zv,C_Yv,C_lv,C_mv,C_nv,C_Zp,C_Yp,C_lp,C_mp,C_np,C_Zq,C_Yq,C_lq,C_mq,C_nq,C_Zr,C_Yr,C_lr,C_mr,C_nr,efficiency_factor] = Read_Out(file_name);

%% Detecting the failure of the static stability

% Static stability failure if the CG is farther right than the NP
Static_failure = x_cm > X_NP;

% If the airplane trims at negative angle of attack, then plane doesn't
% trim properly
Trim_failure   = alpha_trim_FRL < 0;

[Phugoid,Dutch_roll,SPO,Spiral,Roll,failure_eigen] = Read_Eigen(file_name);

%% Deleting the files

% If the user decides to delete the files
if delete_files
    delete(sprintf("%s.avl",file_name))
    delete(sprintf("%s.run",file_name))
    delete(sprintf("%s.out",file_name))
    delete(sprintf("%s.mass",file_name))
    delete(sprintf("%s.eig",file_name))
    delete(sprintf("%s.bat",file_name))
end

%% Assessing the dynamic stability of the Aircraft

eigen_key = 1;
% If the configuration outputs more than the 5 expected modes, halt
% analysis and throw an error.
if failure_eigen
    dynamic_failure_mode = eigen_key;
    % fprintf("Dynamic Stability Failed! Eigenvalue output does not show the expected 5 Dynamic modes. Double-check that your mass and inertia values make sense\n")
    % fprintf("Possible Fix - Increase your I_yy and/or I_zz values and ensure they are reflecting the wing/tail placements\n\n")


    % if the eigenvalues do make sense
else

    % -------------------------------------------------------------------------
    % Phugoid Failure
    % -------------------------------------------------------------------------

    % If phugoid is not damped, the stability of the plane is not sufficient
    Phugoid_failure = (Phugoid(1)>=0);
    phugoid_key = 2;

    if Phugoid_failure
        dynamic_failure_mode = phugoid_key;
        % fprintf("Dynamic Stability Failed! Phugoid mode is undamped\n")
        % fprintf("Possible Fix - Move your NP closer to your CG. An overly statically stable aircraft is often dynamically unstable\n\n")
    end

    % -------------------------------------------------------------------------
    % Dutch_roll_failure
    % -------------------------------------------------------------------------

    Dutch_roll_failure = (Dutch_roll(1)>=0);
    dutch_roll_key = 3;

    if Dutch_roll_failure
        dynamic_failure_mode = dutch_roll_key;
        %     fprintf("Dynamic Stability Failed! Dutch Roll mode is undamped\n")
        %     fprintf("Possible Fix - Decrease Wing Sweep and/or dihedral\n\n")
    end

    % -------------------------------------------------------------------------
    % SPO Failure
    % -------------------------------------------------------------------------

    SPO_failure = (SPO(1)>=-0.5);
    SPO_key = 4;

    if SPO_failure
        dynamic_failure_mode = SPO_key;
        %     fprintf("Dynamic Stability Failed! SPO mode is underdamped\n")
        %     fprintf("Possible Fix - Move lifting surfaces farther from CG\n\n")
    end


    % -------------------------------------------------------------------------
    % Spiral Failure
    % -------------------------------------------------------------------------

    Spiral_failure = (Spiral>=0);
    spiral_key = 5;

    if Spiral_failure
        dynamic_failure_mode = spiral_key;
        % fprintf("Dynamic Stability Failed! Spiral mode is undamped\n")
        % fprintf("Possible Fix - Decrease Tail Fin Size and/or Increase Dihedral. Spiral is caused by strong directional stability and weak lateral stability\n\n")
    end


    % -------------------------------------------------------------------------
    % Roll Failure
    % -------------------------------------------------------------------------

    Roll_failure = (Roll>=-0.5);
    roll_key = 6;

    if Roll_failure
        dynamic_failure_mode = roll_key; % roll failure mode
        % fprintf("Dynamic Stability Failed! Rolling mode is underdamped\n")
        % fprintf("Possible Fix - Increase Wing Dihedral\n\n")
    end

end

% return to home directory
cd ..
cd ..
cd ..