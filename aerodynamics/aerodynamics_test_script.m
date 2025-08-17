% inputs
b = 4; % m
c = 0.5; % m 
example_linear_region_coords = [2.250, 0.6029]; % alpha, C_l pair at a point on the linear region of the C_l vs alpha graph


%% Airfoil Data
a_0 = 2*pi; % assumption
   

C_l = a_0*(alpha - alpha_0L);
% C_l = (dC_l/dalpha)*alpha + C_l_0 = a_0*alpha + C_l_0

dz_dz = ; % curvature of airfoil camber line
fun = @(theta) dz_dx*(cos(theta) - 1)
C_l_0 = 2*integral(fun, 0, pi); % does this need to be multiplied by 2*pi to get C_l_0?

C_l = @(alpha) a_0*alpha + C_l_0

%% Convert to Wing
S = b*c; % rectangular wing
AR = b^2/S;

e1 = 1; % assumption, Dr. G recommends for MAE 251
a = a_0/(1 + a_0/(pi*AR*e1));
C_L = a*(alpha - alpha_0L);

C_D = C_D_0L + (C_L^2)/(pi*AR*e);

% or, as a better approximation, C_D = C_D_min + ((C_L - C_L_minCD)^2)/(pi*AR*e)

vStall_cruise = sqrt(W/(0.5*rho*S*C_L_max));

