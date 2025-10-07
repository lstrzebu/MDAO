function [Cla,Cm0,alpha_L0,a0,alpha_stall] = CL_alpha(b, c, d_fuse, sweep_deg, air_foil)
% Compute 3D lift-curve slope (per rad) for a finite lifting surface
% using Raymer Eq. 12.6 with fuselage-buried area correction.
%
% Inputs:
%   b        = span of lifting surface [m]
%   c        = chord [m] 
%   sweep_deg= sweep at maximum thickness line [deg]
%   d_fuse   = fuselage box width (portion of span buried) [m]
%   aif_foil = airfoil name (ex:'NACA 2412')
%
% Output:
%   Cla      = 3D lift-curve slope [per rad]
%   Cm0      = Pitching moment at aerodynamic center
%   alpha_L0  - zero-lift angle of attack [rad]
%   a0        - 2D lift slope [1/rad]
    
    %%
    % Reference and exposed areas
    S_ref = b * c;                % full planform
    S_exposed = S_ref - c * d_fuse; % subtract buried portion

    % Aspect ratio
    AR = b^2 / S_ref;

    % Compressibility factor
    beta = 1;

    % Sweep in radians
    sweep = deg2rad(sweep_deg);

    % Xfoil call for 2-D Cl-alpha slope
    [pol,~] = xfoil(air_foil, -5:20, 3e5, 0,'ppar n 200 ', 'oper iter 200');

    % pol is the struct returned by xfoil
    alpha = pol.alpha(:);   % degrees
    CL    = pol.CL(:);
    
    [~,stall_indx] = max(CL);
    alpha_stall = alpha(stall_indx);
    % choose linear range (adjust as appropriate)
    idx = alpha >= -2 & alpha <= 11;
    
    % linear fit
    p = polyfit(alpha(idx), CL(idx), 1); % p(1) = slope [CL per deg], p(2) = intercept
    slope_per_deg = p(1);
    slope_per_rad = slope_per_deg * (180/pi); % convert: CL/(deg) * (180/pi) = CL/(rad)
    if slope_per_rad>2*pi
        slope_per_rad = 2*pi;
    end

    CL_fit = polyval(p,alpha(idx));

    %2d cl alpha slope
    a0 = slope_per_rad;

    %Cm_0 wing calculation

    % take moment data from quarter chord
    Cm_c4 = pol.Cm;
    %linear fit
    pCm  = polyfit(alpha(idx), Cm_c4(idx), 1); % Cm(c/4) = pCm(1)*alpha + pCm(2)

    Cm_c4_fit = polyval(pCm,alpha(idx));

    dCm_dalpha = pCm(1) * (180/pi);   % Cm per rad

    % aerodynamic center location (non-dim chord)
    x_ac = 0.25 - dCm_dalpha / slope_per_rad;

    % compute Cm about AC for each alpha (should be ~constant)
    Cm_ac_all = Cm_c4_fit + CL_fit .* (x_ac - 0.25);

    Cm0 = mean(Cm_ac_all);

    % higher-order fit (cubic)
    p_1 = polyfit(alpha, CL, 3); % 3rd order polynomial

    % Solve p3*alpha^3 + p2*alpha^2 + p1*alpha + p0 = 0 for CL=0
    alpha0_all = roots(p_1);              % gives all roots
    % select the root within alpha range
    alpha_L0 = alpha0_all(alpha0_all >= min(alpha) & alpha0_all <= max(alpha));


    eta = slope_per_rad/(2*pi/beta);
    % Raymer Eq. 12.9
    F = 1.07*(1+d_fuse/b)^2;
    rat = (S_exposed / S_ref)*F;
    if rat>1
        rat = 0.98;
    end

    % Raymer Eq. 12.6
    numerator = 2 * pi * AR;
    denom = 2 + sqrt(4 + (AR^2 * beta^2 / eta^2) * (1 + (tan(sweep)^2 / beta^2)));
    Cla = (numerator / denom) * rat;
end
