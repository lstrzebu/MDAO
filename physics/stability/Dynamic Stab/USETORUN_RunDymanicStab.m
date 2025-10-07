clear; clc; close all;

title               = "TheCHC";

file_name           = "QuackPack";

airfoil_file        = "clarky.dat";

Htail_airfoil_file  = "n0012-TAIL.dat";

Vtail_airfoil_file  = "n0012-TAIL.dat";

tail_config = "U";

delete_files = true;

%% Wing Geometry

mass    = 35;   % [kg]

% Wing Properties
S       = 5;    % Directly used for lift equation
b       = 5;    % Between 3 in and 5 in

dihedral_angle = 5; % [°]




%% Tail Configuration Parameters

% Tail Position Properties
d_tail  = 5; % Distance from LE of wing to LE of tail
i_t     = 3;

% z-location of the tail
z_tail  = 0.5;


C_r_fuselage = 0.75;

% Horizontal Tail Properties
S_ht = 0.75;

lambda_ht = 2/3;


% Vertical Tail Properties
S_vt = 0.25;

lambda_vt = 0.7;


%% Mass Parameters

% Center of mass
x_cm                = -0.4;         % [m]

y_cm                = 0;            % [m]

z_cm                = -0.1;         % [m]

I_matrix    = [1.9, 0, -0.5; ...
               0, 220, 0; ...
               -0.5, 0, 159.4];

DynamicStab(title,file_name,airfoil_file,Htail_airfoil_file,Vtail_airfoil_file,tail_config,x_cm,y_cm,z_cm,mass,I_matrix,b,S,dihedral_angle,d_tail,z_tail,i_t,S_ht,S_vt,C_r_fuselage,lambda_ht,lambda_vt)

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

% If the configuration outputs more than the 5 expected modes, halt
% analysis and throw an error.
if failure_eigen

    fprintf("Dynamic Stability Failed! Eigenvalue output does not show the expected 5 Dynamic modes. Double-check that your mass and inertia values make sense\n")
    fprintf("Possible Fix - Increase your I_yy and/or I_zz values and ensure they are reflecting the wing/tail placements\n\n")


% if the eigenvalues do make sense
else

    % -------------------------------------------------------------------------
    % Phugoid Failure
    % -------------------------------------------------------------------------

    % If phugoid is not damped, the stability of the plane is not sufficient
    Phugoid_failure = (Phugoid(1)>=0);

    if Phugoid_failure
        fprintf("Dynamic Stability Failed! Phugoid mode is undamped\n")
        fprintf("Possible Fix - Move your NP closer to your CG. An overly statically stable aircraft is often dynamically unstable\n\n")
    end

    % -------------------------------------------------------------------------
    % Dutch_roll_failure
    % -------------------------------------------------------------------------

    Dutch_roll_failure = (Dutch_roll(1)>=0);

    if Dutch_roll_failure
        fprintf("Dynamic Stability Failed! Dutch Roll mode is undamped\n")
        fprintf("Possible Fix - Decrease Wing Sweep and/or dihedral\n\n")
    end
    
    % -------------------------------------------------------------------------
    % SPO Failure
    % -------------------------------------------------------------------------

    SPO_failure = (SPO(1)>=-0.5);

    if SPO_failure
        fprintf("Dynamic Stability Failed! SPO mode is underdamped\n")
        fprintf("Possible Fix - Move lifting surfaces farther from CG\n\n")
    end
    
    
    % -------------------------------------------------------------------------
    % Spiral Failure
    % -------------------------------------------------------------------------

    Spiral_failure = (Spiral>=0);

    if Spiral_failure
        fprintf("Dynamic Stability Failed! Spiral mode is undamped\n")
        fprintf("Possible Fix - Decrease Tail Fin Size and/or Increase Dihedral. Spiral is caused by strong directional stability and weak lateral stability\n\n")
    end


    % -------------------------------------------------------------------------
    % Roll Failure
    % -------------------------------------------------------------------------

    Roll_failure = (Roll>=-0.5);

    if Roll_failure
        fprintf("Dynamic Stability Failed! Rolling mode is underdamped\n")
        fprintf("Possible Fix - Increase Wing Dihedral\n\n")
    end

end