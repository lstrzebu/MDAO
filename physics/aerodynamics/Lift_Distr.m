function [y_span, L_prime, L_total, CL] = Lift_Distr(b, c, alpha, a0, alpha_L0, V)
% Lifting Line Theory Solver using Collocation Method (rectangular wing)
%
% Inputs:
%   b         - wing span [m]
%   c         - chord [m]
%   alpha     - geometric angle of attack [rad]
%   a0        - 2D lift slope [1/rad]
%   alpha_L0  - zero-lift angle of attack [rad]
%   V         - freestream velocity [m/s]
%   N_eval    - number of evenly spaced evaluation points along span (default 200)
%
% Outputs:
%   y_span    - evenly spaced spanwise positions [m]
%   L_prime   - local lift per unit span [N/m]
%   L_total   - total lift [N]
%   CL        - lift coefficient

    % Fixed parameters
    rho = 1.225;  % air density [kg/m^3]
    N   = 30;     % number of collocation points

    % Default evaluation points
    N_eval = 200;

    % Collocation points
    theta_i = pi*(2*(1:N)-1)/(2*N);
    sin_theta = sin(theta_i);

    % Build coefficient matrix
    A_matrix = zeros(N,N);
    RHS = alpha - alpha_L0;

    b = mean(b); % handle the vectorized case
    c = mean(c);
    for i = 1:N
        for j = 1:N
            n = j;
            A_matrix(i,j) = (4*b/(c*a0)) * sin(n*theta_i(i)) + ...
                             n * sin(n*theta_i(i))/sin_theta(i);
        end
    end

    % Solve for Fourier coefficients
    An = A_matrix \ (RHS * ones(N,1));

    % Evenly spaced spanwise coordinates
    y_span = linspace(0, b/2, N_eval);

    % Convert y -> theta for evaluation
    theta_eval = acos(-2*y_span/b);

    % Compute circulation distribution
    Gamma = zeros(size(theta_eval));
    for k = 1:length(theta_eval)
        for j = 1:N
            Gamma(k) = Gamma(k) + 2*b*V*An(j)*sin(j*theta_eval(k));
        end
    end

    % Local lift per unit span
    L_prime = rho * V * Gamma;

    % Total lift
    L_total = 2*trapz(y_span, L_prime);

    % Lift coefficient
    CL = An(1)*pi*b/c;
end