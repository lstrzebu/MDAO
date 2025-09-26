% Jorge Quintana-Maldano
% 26 September 2025
% Inputs:
%   - wingspan, chord, planform area
%   - aspect ratio
%   - airfoil
%   - V_trim
%   - alpha_trim
%   - fuselage & landing info... elaborate?
%   - weight
%   - banner info
% Outputs:
%   - Lift and lift coefficients
%   - Drag and drag coefficients
%   - L/D
%   - V_stall
%   - alpha_stall

%% Given Parameters

% FoIl = 'NACA2412'; %Foil name
% alpha =; % angle of attack
% c =1; % chord length
% V = 10; %free stream velocity (trim speed)
%parameters at standard sea level conditions <400 ft
% mu = ; %dynamic viscosity [Pa*s]
% rho = 1.225; % density
% Re = rho*V*c/mu;

%% Invoke XFOIL

[pol,~] = xfoil('NACA2412', -5:20, 1e6, 0.2, 'oper iter 200');

%% Wing and flow parameters
b = 3.0;          % span [m]
c = 1;          % chord [m]
%AR = b/c;         % aspect ratio
alpha = deg2rad(0); % geometric angle of attack [rad]
a0 = 2*pi;         % 2D lift slope at low Re [per rad]
alpha_L0 = deg2rad(-2.1);     % zero-lift angle [rad]
rho = 1.225;      % air density [kg/m^3]
V = 30;           % freestream velocity [m/s]

N = 100;            % number of Fourier terms (all n)

%% Collocation points (midpoints)
theta_i = pi*(2*(1:N)-1)/(2*N); % 0 < theta_i < pi
sin_theta = sin(theta_i);

%% Build coefficient matrix and RHS
A_matrix = zeros(N,N);
RHS = alpha - alpha_L0; % same for all points (uniform AoA)

for i = 1:N
    for j = 1:N
        n = j; % all n included
        A_matrix(i,j) = (4*b/(c*a0)) * sin(n*theta_i(i)) + n * sin(n*theta_i(i))/sin_theta(i);
    end
end

RHS_vector = RHS * ones(N,1);

%% Solve for Fourier coefficients An
An = A_matrix \ RHS_vector;

disp('Fourier coefficients A_n:');
disp(An);

%% Compute spanwise circulation for plotting
theta_plot = linspace(0, pi, 200); % dense points for smooth curve
Gamma = zeros(size(theta_plot));

for k = 1:length(theta_plot)
    for j = 1:N
        n = j; % all n
        Gamma(k) = Gamma(k) + 2*b*V*An(j)*sin(n*theta_plot(k));
    end
end

%% Map theta -> spanwise y position
y_span = -b/2 * cos(theta_plot);

%% Compute local lift per unit span
L_prime = rho * V * Gamma;

%% Total lift
L_total = trapz(y_span, L_prime); % integrate across full span
CL = An(1)*pi*b/c;

%% Plot results
figure;
plot(y_span, L_prime, 'LineWidth',2);
xlabel('Spanwise position y [m]');
ylabel('Lift per unit span L'' [N/m]');
title('Spanwise Lift Distribution (Rectangular Wing, All n)');
grid on;

fprintf('Total Lift = %.2f N\n', L_total);
fprintf('Wing Lift Coefficient CL = %.3f\n', CL);