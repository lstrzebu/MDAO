function [maxG,y_span,L_prime,minNumFasteners, minTurnRadius, maxBankAngle, CL] = structures_MDAO(b, c, alpha, a0, alpha_L0, v_inf, emptyWeight, loadedWeight)
%structures_MDAO -  calculates max wing loading (G's) ALL SI UNITS

%   Idealizes wing spar as a cantilevered beam and applies a given
%   lift distribution, discretizes beam into n elements, then uses stiffness 
%   matrix method to calculate max stress.
%   
%   Utilizes lift distribution from 
%   Aerodynamics sub-team,calculates max stress, then calculates load
%   factor by dividing sigma_allowable/sigma_max. Applies FoS

%   a0 = 2d lift curve slope
%   alpha_L0 = 0 lift AoA
%   v_inf = trim velocity
%   sigma_allowable: spar property
%   N = number of fasteners (4, 6, 8)? 
%   emptyWeight = OL empty takeoff weight
%   loadedWeight = IL emptyWeight + payload

% maxG
% y_span = normalized halfspan corresponding to nodal locations
% L_prime = 2d lift distribution
% fastenersHold = Boolean variable, will the fasteners pull out (not eccentrically loaded)
% minTurnRadius = based on maxG's
% maxBankAngle = based on minTurnRadius
% CL = output from Lift_Distr function

% -------------------compute lift distribution---------------------------
[y_span, L_prime, L_total, CL] = Lift_Distr(b, c, alpha, a0, alpha_L0, v_inf); 

%----------------Max G's-------------------------------------------------

maxG_ref = 4.4;
weight_ref = emptyWeight; %empty weight

maxG = maxG_ref * (weight_ref/loadedWeight);

% ------------------Fastener Pullout Stress -------------------------------

FoS_fastener = 1.5;
t_skin = 2 * 0.2/1000; %skin thickness [m], accounts for upper surface and lower surface CF, neglects foam shear resistance 
d = 3/8*0.0254; %bolt shank diameter [m]
tau_allow = 30*10^6; %CF shear interface strength [Pa]

PulloutForce_allow = tau_allow * (pi*d) * t_skin/(3*FoS_fastener); % https://ntrs.nasa.gov/api/citations/19900009424/downloads/19900009424.pdf
% factor of 3 in the denominator is empirical and accounts for imperfect
% mating between threads and material

numFasteners = (L_total * maxG) / PulloutForce_allow;

wholeNum = ceil(numFasteners);

if rem(wholeNum,2) ~= 0 
    minNumFasteners = wholeNum + 1;
else
    minNumFasteners = wholeNum;
end


%-----------------Turn Radius---------------------------------------------

g = 9.81;
numerator = v_inf^2;
denominator = g*sqrt(maxG^2 - 1);
minTurnRadius = numerator/denominator;
maxBankAngle = acosd(1/maxG);

end