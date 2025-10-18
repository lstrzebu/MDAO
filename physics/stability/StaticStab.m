function [X_NP,C_L_trim,V_trim,alpha_FRL_trim,failure, failure_message] = StaticStab(X_CG,W,S,b,d_tail,i_t,C_r_ht,C_t_ht,b_ht,a_wb,a_tail,alpha_0L_wb,C_M0_wb,air_density)
%STATICSTAB evaluates the static stability properties of the aircraft.
%           Dimensions can be metric or imperial, but the have to be
%           consistent.
%INPUTS
% X_CG    = 0.2;  % The location of the CG from the leading edge of the wing.
%                 % Positive X_CG points toward the tail
% 
% W       = 13;   % weight of the aircraft (N)
% 
% % Wing Properties
% S       = 17.5; % Directly used for lift equation
% b       = 5;    % Between 3 in and 5 in
% 
% 
% % Tail Position Properties
% d_tail  = 5; % Distance from LE of wing to LE of tail
% i_t     = 0; % [deg]
% 
% % Horizontal Tail Properties
% C_r_ht  = 1;
% C_t_ht  = 1;
% b_ht    = 4;
% 
% % Lift curve slopes
% a_wb    = 0.1;  % [1/deg] -   
% a_tail  = 0.07; % [1/deg] -   
% 
% downwash_derivative   -   derivative of epsilon_0 with respect to α
% epsilon_0             -   Angle of downwash at the tail at α_wb = 0

%OUTPUTS
% X_NP              -   the neutral point of the aircraft. Only depends on wing and tail
%                       shape. Mass and tail incidence properties are not needed.
%
% C_L_trim          -   The trim coefficient of lift for the entire aircraft
%
% V_trim            -   The trim speed for the entire aircraft
%
% alpha_FRL_trim    -   The trim angle of attack of the FRL. Measured from
%                       the airfoil camber line of the wing. can be used to
%                       find the α_trim of the wing and tail
%% Calculating the i_t for calculations

epsilon_0 = 0;
downwash_derivative = 0;

% i_t that the user inputs is based on the fuselage reference line, but in
% the calculations, the i_t used is based on the 0-L line of the wing.
i_t_0L      = i_t + alpha_0L_wb;

%% Wing Calculations (ONLY WORKS FOR RECTANGULAR WING)

% Chord of the wing
c           = S/b;

% The neutral point if the airplane only consists of the wing
X_NP_wing   = c/4;

% Normalized Neutral Point
h_n_WB      = X_NP_wing./c;

%% Horizontal Tail Planform Calculations

S_ht        = (C_r_ht + C_t_ht)*(b_ht/2);

lambda_ht   = C_t_ht/C_r_ht;
C_bar_ht    = (2/3)*C_r_ht*((1+lambda_ht+lambda_ht^2)/(1+lambda_ht));

Y_bar_ht    = (b_ht/2)*(1/3)*((1+2*lambda_ht)/(1+lambda_ht));

% Finds the location of the leading edge of HT where the C_bar is located
X_bar_LE_ht = Y_bar_ht*(C_r_ht-C_t_ht)/(b_ht/2);

% Finds the Neutral Point of the tail with respect to the tail LE
X_NP_tail   = X_bar_LE_ht + C_bar_ht/4;

%% Tail Positioning

l_bar_ht    = d_tail - X_NP_wing + X_NP_tail;

V_bar_ht    = (l_bar_ht*S_ht)/(X_NP_wing*S);


%% Finding the total lift-curve slope

a_tot       = a_wb*(1 + (a_tail/a_wb)*(S_ht/S)*(1-downwash_derivative));


%% Finding the total neutral point

% Total h_n
h_n         = h_n_WB + (a_tail/a_tot)*V_bar_ht*(1-downwash_derivative);

X_NP        = h_n*c;

%% C_L_trim calculation

C_M0        = C_M0_wb + a_tail*V_bar_ht*(epsilon_0 + i_t_0L);

C_L_trim    = c*C_M0/(X_NP - X_CG);

%% α_trim calculation

% This alpha is defined as the angle between freestream air and 0-L line of
% the entire airplane.
alpha_trim  = C_L_trim./a_tot;

% Convert to α_wb
alpha_wb_trim = alpha_trim + (a_tail/a_tot) * (S_ht/S) * (i_t_0L + epsilon_0);

% α_wb is now known. Use to find α_FRL_trim
alpha_FRL_trim = alpha_wb_trim + alpha_0L_wb;

%% Finding the C_Lwb_0

% C_L_wb_0 at alpha_FRL = 0


%% Trim Velocity

V_trim = sqrt((W)/((1/2)*air_density*C_L_trim*S)); % [m/s]


%% Determining if failure occurs

Cm_failure_key = 1;
Cl_failure_key = 2;
% If the CG is further aft of NP
if X_CG > X_NP

    failure = Cm_failure_key;

    failure_message = "Static Stability Failed! The CG is behind the NP";
elseif C_L_trim < 0 

    failure = Cl_failure_key;

    failure_message = "Static Stability Failed! The aircraft is statically stable but trims at a negative lift";
else
    failure = 0;

    failure_message = "Static Stability Succeeded.";
end

end % End of function

