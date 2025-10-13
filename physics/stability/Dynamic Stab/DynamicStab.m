function [] = DynamicStab(design_title,file_name,airfoil_file,Htail_airfoil_file,Vtail_airfoil_file,tail_config,x_cm,y_cm,z_cm,mass,I_matrix,b,S,dihedral_angle,d_tail,z_tail,i_t,S_ht,S_vt,C_r_fuselage,lambda_ht,lambda_vt)
%DYNAMICSTAB Summary of this function goes here
%   Detailed explanation goes here
%   - INPUTS:
%
%       design_title               -   The name of the input design. Will appear
%                               on plots and graphs
%                               (STRING OR CHAR)
%
%       file_name           -   The name of the AVL file generated from
%                               this function 
%                               (STRING OR CHAR)
%
%       airfoil_file        -   The file of the airfoil you want to use for
%                               the wing
%                               (STRING OR CHAR)
%
%       Htail_airfoil_file  -   The file of the airfoil you want to use for
%                               the horizontal tail
%                               (STRING OR CHAR)
%
%       Vtail_airfoil_file  -   The file of the airfoil you want to use for
%                               the vertical tail
%                               (STRING OR CHAR)
%
%       tail_config         -   The tail configuration of the HT + VT
%                               ("C" (For conventional), "U", or "T")
%
%       x_cm                -   x location of the Center of Mass (+ towards
%                               tail)
%                               (DOUBLE)
%
%       y_cm                -   y location of the Center of Mass (+ towards
%                               right wing)
%                               (DOUBLE)
%
%       z_cm                -   z location of the Center of Mass (+ up)
%                               (DOUBLE)
%
%       mass                -   Mass of the aircraft
%                               (DOUBLE)
%
%       I_matrix            -   The mass moment of inertias of your
%                               aircraft
%                               (3x3 DOUBLE)
%
%
%       b                   -   Wingspan 
%                               (DOUBLE)
%
%       S                   -   Wing Area
%                               (DOUBLE)
%                               
%       dihedral_angle      -   Angle of the wing dihedral in degrees 
%                               (+) for dihedral, (-) for anhedral
%                               (DOUBLE)
%
%       d_tail              -   x distance from LE of wing to LE of tail
%                               Used to calculate l_t
%                               (DOUBLE)
%
%       z_tail              -   z distance from LE of wing to LE of tail
%                               (DOUBLE)
%
%       i_t                 -   Tail incidence angle in degrees.
%                               (+) for CCW rotation (Assuming nose is
%                               pointing left).
%
%                               (+) decreases tail lift (Usually
%                               negligible), and increases α_trim
%
%                               (DOUBLE)
%
%
%
%


%% Reading Tail Config


% If statement defines tail properties based on the tail_config

if strcmp(tail_config,"C") % Conventional Tail

    % Reference root chord defines the Horizontal Tail root chord for
    % Conventional Tail Config
    C_r_ht = C_r_fuselage;

    % Finding tip chord of HT from root chord
    C_t_ht = C_r_ht .* lambda_ht;

    % Reference root chord also defines the Vertical Tail root chord for
    % Conventional Tail Config
    C_r_vt = C_r_fuselage;

    % Finding tip chord of VT from root chord
    C_t_vt = C_r_vt .* lambda_vt;


    % Finding the reference spans
    b_ht = 2.*S_ht./(C_r_ht + C_t_ht);

    b_vt = 4.*S_vt./(C_r_vt + C_t_vt); % Doubled due to 1 fin instead of 2

    % Finding the tail locations. For Conventional Tail, HT and VT have
    % same LE at root chord
    d_tail_ht = d_tail;
    z_tail_ht = z_tail;

    d_tail_vt = d_tail;
    z_tail_vt = z_tail;

    % No fin offset from the x-z plane:
    y_vt = 0;
    duplicate_Vtail = false;

elseif strcmp(tail_config,"T") % High Tail

    % Reference root chord defines the Vertical Tail root chord for
    % T Tail Config
    C_r_vt = C_r_fuselage;

    % Finding tip chord of VT from root chord
    C_t_vt = C_r_vt .* lambda_vt;

    b_vt = 4.*S_vt./(C_r_vt + C_t_vt); % Doubled due to 1 fin instead of 2

    % Defines the span of the horizontal tail.
    b_ht = b_vt .* 2;

    % Defines the HT root chord using max span definition. 
    C_r_ht = S_ht ./ ((0.5).*b_ht.*(1 + lambda_ht));

    C_t_ht = C_r_ht .* lambda_ht;
    
    % Finding the tail locations. For Conventional Tail, HT and VT have
    % same LE at root chord
    d_tail_ht = d_tail + C_r_vt - C_t_vt;
    z_tail_ht = z_tail + b_vt;

    d_tail_vt = d_tail;
    z_tail_vt = z_tail;

    % No fin offset from the x-z plane:
    y_vt = 0;
    duplicate_Vtail = false;


elseif strcmp(tail_config,"U") % Dual-fin Tail

    % Reference root chord defines the Horizontal Tail root chord for
    % U Tail Config
    C_r_ht = C_r_fuselage;

    % Finding tip chord of HT from root chord
    C_t_ht = C_r_ht .* lambda_ht;

    % Vertical Tail root chord defined by tip chord of Horizontal Tail
    C_r_vt = C_t_ht;

    % Finding tip chord of VT from root chord
    C_t_vt = C_r_vt .* lambda_vt;


    % Finding the reference spans
    b_ht = 2.*S_ht./(C_r_ht + C_t_ht);

    b_vt = 2.*S_vt./(C_r_vt + C_t_vt); % Not doubled due to 2 fins

    % Finding the tail locations. For Conventional Tail, HT and VT have
    % same LE at root chord
    d_tail_ht = d_tail;
    z_tail_ht = z_tail;

    d_tail_vt = d_tail + C_r_ht - C_t_ht;
    z_tail_vt = z_tail;

    % Fin offset to be located at HT tip chords:
    y_vt = b_ht./2;
    duplicate_Vtail = true;

else % If the user inputs an unusual tail configuration

    error("ERROR DEFINING TAIL: Unrecognized tail_config ""%s"". Use ""C"" for conventional tail, ""T"" for high tail (T-tail), or ""U"" for U-shaped (dual-fin) tail",tail_config)

end

% Section x-locations, useful for AVL
HT_tip_LE = C_r_ht - C_t_ht;
VT_tip_LE = C_r_vt - C_t_vt;
%% Other stuff

z_wing_tip = (b/2).*tand(dihedral_angle);

% Assumes that the aircraft is running at low Mach Numbers
M                   = 0;            % [UNITLESS]

S_ref               = S;            % [m^2]

C_ref               = S/b;          % [m]

section_chord       = [C_ref, C_ref];       % [m]

section_alpha       = [0, 0];       % [°]

section_x           = [0, 0];       % [m]

section_y           = [0, b/2];       % [m]

section_z           = [0, z_wing_tip];    % [m]

tail_incidence      = i_t;           % [°]

Htail_location      = [d_tail_ht,0,z_tail_ht];     % [m]

Htail_section_chord = [C_r_ht,C_t_ht];    % [m]

Htail_section_alpha = [0,0];        % [°]

Htail_section_x     = [0,HT_tip_LE];        % [m]

Htail_section_y     = [0,b_ht/2];        % [m]

Htail_section_z     = [0,0];        % [m]

Vtail_location      = [d_tail_vt,y_vt,z_tail_vt];

Vtail_section_chord = [C_r_vt,C_t_vt];

Vtail_section_x     = [0,VT_tip_LE];

Vtail_section_y     = [0,0];

Vtail_section_z     = [0,b_vt];

WriteAvlFile(design_title,file_name,airfoil_file,Htail_airfoil_file,Vtail_airfoil_file,duplicate_Vtail,x_cm,y_cm,z_cm,M,S_ref,C_ref,b,section_chord,section_alpha,section_x,section_y,section_z,tail_incidence,Htail_location,Htail_section_chord,Htail_section_alpha,Htail_section_x,Htail_section_y,Htail_section_z,Vtail_location,Vtail_section_chord,Vtail_section_x,Vtail_section_y,Vtail_section_z)

%% Defining values for mass file

% Assuming the analysis is completed in metric units
Length_unit = "m";
Mass_unit   = "kg";
Time_unit   = "s";

% Gravity and density assumed
g           = 9.81;     % [m/s^2]

air_density = 1.225;    % [kg/m^3]

WriteMassFile(file_name,Length_unit,Mass_unit,Time_unit,g,air_density,mass,x_cm,y_cm,z_cm,I_matrix)


%% Creating the batch and run files

WriteBatchFile(file_name)


system(sprintf('%s.bat',file_name))


end

