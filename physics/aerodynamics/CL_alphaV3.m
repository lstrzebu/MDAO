function [Cla, Cm0, alpha_L0, a0, x_ac, alpha_stall] = CL_alphaV3(b, c, d_fuse, sweep_deg, airfoil)
% CL_ALPHA_LOOKUP: Returns precomputed 2D airfoil properties and computes 3D lift slope.
%
% Inputs:
%   b        = span [m]
%   c        = chord [m]
%   d_fuse   = fuselage width [m]
%   sweep_deg= sweep angle [deg]
%   airfoil  = string specifying airfoil, e.g., 'MH114'
%
% Outputs:
%   Cla         = 3D lift-curve slope [1/rad]
%   Cm0         = Pitching moment coefficient at AC
%   alpha_L0    = Zero-lift angle [rad]
%   a0          = 2D lift slope [1/rad]
%   x_ac        = aerodynamic center (fraction of chord)
%   alpha_stall = stall angle [rad]

%% --- Lookup table --- REYNOLDS NUMBER OF 250000
switch airfoil
    case "MH 114"
        a0          = 5.1515;        % 2D lift slope [1/rad]
        alpha_L0    = -0.1588;       % rad
        Cm0         = -0.2317;
        x_ac        = 0.2035;        % fraction of chord
        alpha_stall = deg2rad(13.00);         % deg

    case "CLARK Z"
        a0          = 5.8064;
        alpha_L0    = -0.0782;
        Cm0         = -0.1109;
        x_ac        = 0.2161;
        alpha_stall = deg2rad(15);

    case "PSU 94-097"
        a0          = 5.8592;
        alpha_L0    = -0.0827;
        Cm0         = -0.1339;
        x_ac        = 0.2157;
        alpha_stall = deg2rad(11);

    case "BE50"
        a0          = 6.2679;
        alpha_L0    = -0.0677;
        Cm0         = -0.1247;
        x_ac        = 0.2185;
        alpha_stall = deg2rad(11);

    case "FX 63-137" % VERY SMOOTH STALL
        a0          = 5.4419;
        alpha_L0    = -0.1597;
        Cm0         = -0.2535;
        x_ac        = 0.2003;
        alpha_stall = deg2rad(18);

    case "S1223" %SUPER HIGH LIFT
        a0          = 6.2832;
        alpha_L0    = -0.1571;
        Cm0         = -0.2188;
        x_ac        = 0.2789;
        alpha_stall = deg2rad(14);

    case "NACA 0012" % TAIL
        a0          = 6.1459;
        alpha_L0    = 0.0027;
        Cm0         = -0.0027;
        x_ac        = 0.2467;
        alpha_stall = deg2rad(13);

    case "NACA 0015" %TAIL
        a0          = 5.6350;
        alpha_L0    = 0.0004;
        Cm0         = -0.0132;
        x_ac        = 0.2241;
        alpha_stall = deg2rad(15.5);

    otherwise
        error('Airfoil "%s" not recognized. Add it to the lookup table.', airfoil);
end

%% --- Compute 3D lift slope (Raymer Eq. 12.6) ---
AR = b^2 / (b*c);         % aspect ratio
beta = 1;                  % incompressible
sweep = deg2rad(sweep_deg);

eta = a0/(2*pi);           % section efficiency factor
numerator = 2*pi*AR;
denom = 2 + sqrt(4 + (AR^2*beta^2/eta^2)*(1 + (tan(sweep)^2/beta^2)));

% fuselage correction factor
F = 1.07*(1 + d_fuse/b)^2;
rat = ((b*c - c*d_fuse)/(b*c)) * F;
if rat > 1
    rat = 0.98;
end

Cla = (numerator/denom) * rat;

end
