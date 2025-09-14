% Inputs: b, c, which airfoil to analyze (which .dat file to use), alpha(?)
% Outputs: C_L, ... need to do C_D and C_M

%% Setup 
b = 4; % m
c = 0.5; % m 
datFilename = 'test.dat';

%% XFOIL Function Call
airfoil_path = sprintf('airfoil_files/%s', datFilename);
liftcurve.alpha = -1:8;
[pol, foil] = xfoil(sprintf('../%s', airfoil_path), liftcurve.alpha, 50000, 0.1);

plot(pol.alpha, pol.CL); 
figure(1)
grid on;
xlabel('\alpha (deg)'); ylabel('C_l');

%% Index the linear region from the CL vs alpha data
minLinearAlpha = input('Input the alpha value on the lower (left) end of the linear region: ');
maxLinearAlpha = input('Input the alpha value on the upper (right) end of the linear region: ');
minLinearAlphaIndx = find(pol.alpha == minLinearAlpha);
maxLinearAlphaIndx = find(pol.alpha == maxLinearAlpha);
linearAlphaIndx = minLinearAlphaIndx:maxLinearAlphaIndx; 
linearAlpha = pol.alpha(linearAlphaIndx);
linearCL = pol.CL(linearAlphaIndx);
P = polyfit(linearAlpha, linearCL, 1);
liftcurve.a_0 = P(1); % lift curve slope
% CL = a0*alpha - a0*alpha_0L
% Therefore -a0*alpha_0L = P(2)
% Therefore alpha_0L = -P(2)/a0
liftcurve.alpha_0L = -P(2)./a_0;
liftcurve.alpha_bounds = [minLinearAlpha, maxLinearAlpha];
close(1)
% example_linear_region_coords = [2.250, 0.6029]; % alpha, C_l pair at a point on the linear region of the C_l vs alpha graph


%% Airfoil Data
% a_0 = 2*pi; % assumption

%C_l = a_0*(alpha - alpha_0L);
% C_l = (dC_l/dalpha)*alpha + C_l_0 = a_0*alpha + C_l_0
C_l = @(alpha) a_0*(alpha - alpha_0L);

% dz_dx = 0; % curvature of airfoil camber line
% fun = @(theta) dz_dx*(cos(theta) - 1)
% C_l_0 = 2*integral(fun, 0, pi); % does this need to be multiplied by 2*pi to get C_l_0?

%% Convert to Wing
S = b*c; % rectangular wing
AR = b^2/S;

e1 = 1; % assumption, Dr. G recommends for MAE 251
a = a_0/(1 + a_0/(pi*AR*e1));
liftcurve.C_L = a*(liftcurve.alpha - alpha_0L);
hold on; grid on;
plot(pol.alpha, pol.CL, '-o', liftcurve.alpha, liftcurve.C_L, '-*');
legend('XFOIL', 'Linearized', 'Location', 'Northwest');
xlabel('\alpha (deg)'); ylabel('C_l');

C_D = C_D_0L + (C_L^2)/(pi*AR*e);

% or, as a better approximation, C_D = C_D_min + ((C_L - C_L_minCD)^2)/(pi*AR*e)

vStall_cruise = sqrt(W/(0.5*rho*S*C_L_max));

