function [L, L_2, D, C_D_Total, CL_trim_tot,V_stall, rejectedIndex, failure_messages] = AeroCode_2(W, V, C_L_Total, b_w, c_w, b_t, c_t, l_fuse, d_fuse, alpha_trim, stall_w, CLa_w, W_ref, alphaL0_w, Cla_t, t_ref, alphaL0_t, numMissionConfigs, missionNumber)
% Aero_Forces calculates total lift and drag for an aircraft
%
% Inputs:
% W         : Weight
% V         : Freestream velocity (m./s) (Trim speed)
% C_L_tot   : total lift coefficient
% b_w       : Wing span (m)
% c_w       : Wing chord (m)
% b_t       : Tail span (m)
% c_t       : Tail chord (m)
% l_fuse    : Fuselage length (m)
% d_fuse    : Fuselage diameter (m)
% alpha_trim: trim angle of attack
% stall_w   : 2d wing stall angle
% CLa_w       : 3d lift slope for wing
% W_ref       : wing resting angle of attack with respect to fuselage
% alphaL0_w   : 0 lift wing angle of attack
% Cla_t       : 3d lift slope for tail
% t_ref       : tail resting angle of attack with respect to fuselage
% alphaL0_t   : 0 lift tail angle of attack
%
% Outputs:
% L           : Total lift (N)
% L_2         : Total lift second option
% D           : Total drag (N)
% C_D_Total   : Total drag coefficient
% C_L_Total   : Total Lift coefficient
% V_stall     : Stall speed
% speed_boolean : true if speed is good false if bad speed
% alpha_boolean : true if angle is good false if bad angle



%% Constants
rho = 1.225;       % Air density (kg./m.^3)
mu = 1.81e-5;      % Dynamic viscosity (kg./(m·s))

%% Wing & Tail areas
S_w = b_w .* c_w;
S_t = b_t .* c_t;

%% Aspect ratio
AR = b_w.^2 ./ S_w;

%% Total lift coefficient

% Method 2
CL_trim_tot = CLa_w.*(W_ref+alpha_trim-alphaL0_w) + (S_t./S_w).*Cla_t.*(t_ref+alpha_trim-alphaL0_t);

%% Total lift
L = 0.5 .* rho .* V.^2 .* S_w .* C_L_Total;
L_2 = 0.5 .* rho .* V.^2 .* S_w .* CL_trim_tot;

%% Zero-lift drag components

% Fuselage Reynolds number
R_fuse = rho .* V .* l_fuse ./ mu;

% Fuselage skin friction coefficient (Eqn 12.27, M ~ 0)
C_f_fuse = 0.455 ./ (log10(R_fuse).^2.58);

% Fuselage form factor (Eqn 12.31 & 12.33)
f_fuse = l_fuse ./ d_fuse;
FF_fuse = 0.9 + 5./(f_fuse.^1.5) + f_fuse./400;

Q_fuse = 1; % Interference factor
S_wet_fuse = 2.*pi.*(d_fuse./2).^2 + pi.*d_fuse.*l_fuse;

CD_o_fuse = C_f_fuse .* FF_fuse .* Q_fuse .* S_wet_fuse ./ S_w;

% Other drag contributions
CD_o_gear = 0.02;
CD_o_pro  = 0.01;
CD_o_FP   = 0.02;

% Total zero-lift drag
CD_o = CD_o_fuse + CD_o_gear + CD_o_pro + CD_o_FP;

%% Induced drag (Eqns 12.48 & 12.49)
e_oswa = 1.78.*(1 - 0.045.*AR.^0.68) - 0.64;  % Oswald efficiency
K = 1./(pi.*AR.*e_oswa);
CD_i = K .* CL_trim_tot.^2;

%% Banner info

switch missionNumber
    case 2
        CD_banner_equiv = 0; % no banner for M2
    case 3
        D_banner   = 0.5 .* rho .* V.^2 .* 0.685981815499670 .* 0.05;  % [N]
        % Convert banner drag to an equivalent CD normalized by wing area
        CD_banner_equiv = D_banner ./ (0.5 .* rho .* V.^2 .* S_w);
    otherwise
        error('Rewrite Aerodynamics analysis to support Mission 1.')
end

%% Total drag coefficient and drag
C_D_Total = CD_o + CD_i + CD_banner_equiv;
D = 0.5 .* rho .* V.^2 .* S_w .* C_D_Total;
%% Boolean

%approximation for 3d wing stall compared to 2d airfoil stall
alpha_w_trim = W_ref + alpha_trim - alphaL0_w;
td_stall = 0.8.*(stall_w - alphaL0_w); % 3d stall approx
% if alpha_w_trim<td_stall
%     alpha_boolean = true; 
% else
%     alpha_boolean = false; 
% end

CL_max = CLa_w.*(W_ref+td_stall-alphaL0_w) + (S_t./S_w).*Cla_t.*(t_ref+td_stall-alphaL0_t);
V_stall = sqrt(2.*W./(rho.*S_w.*CL_max));
% if V>V_stall
%     speed_boolean = true;
% else
%     speed_boolean = false; 
% end

failure_messages = strings([numMissionConfigs, 1]);
rejectedIndx_speed = V<=V_stall & alpha_w_trim < td_stall; % failure due to speed only
rejectedIndx_angle = alpha_w_trim > td_stall & V > V_stall; % failure due to angle only
rejectedIndx_both = V<=V_stall & alpha_w_trim > td_stall; % failure due to both speed and angle

% for testing
rejectedIndx_angle(:) = 0;

if all(sum([rejectedIndx_speed, rejectedIndx_angle, rejectedIndx_both], 2) <= 1) % make sure no row is being set to true for multiple arrays
    failure_messages(rejectedIndx_speed) = "Trimmed airspeed is less than stall speed, meaning the aircraft will stall during flight.";
    failure_messages(rejectedIndx_angle) = "Trimmed angle of attack is greater than stall angle, meaning the aircraft will stall during flight.";
    failure_messages(rejectedIndx_both) = "Trimmed airspeed is less than stall speed, meaning the aircraft will stall during flight. Also, trimmed angle of attack is greater than stall angle, which is another reason for stall.";
    rejectedIndex = any([rejectedIndx_both, rejectedIndx_speed, rejectedIndx_angle], 2);
else
    error('An error in conditional logic has been made. Check the failure logic for static stability. Multiple mutually exclusive failure modes are being triggered simultaneously.')
end
end
