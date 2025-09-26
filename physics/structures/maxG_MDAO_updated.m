function [maxG] = maxG_MDAO_updated(liftDistribution,b)
% Sam Prochnau
% 25 September 2025
%structures_MDAO -  calculates max wing loading (G's) ALL SI UNITS

%   Idealizes wing spar as a cantilevered beam and applies a given
%   lift distribution, discretizes beam into n elements, then uses stiffness 
%   matrix method to calculate max stress. Utilizes lift distribution from 
%   Aerodynamics sub-team,calculates max stress, then calculates load
%   factor by dividing sigma_allowable/sigma_max. Applies FoS

%liftDistribution: a numNode x 1 matrix containing the lift distribution
%points
%sigma_allowable: spar property

%% Spar Properties
E_spar = 22.5*10^6*6894.76; %msi to Pa
OD = 0.75*0.0254;                               thickness = 1/16*0.0254; %m
maxAllowableStress_spar = 100000*6894.76;       R_outer = OD/2;
l = b/2;                                        R_inner = R_outer - thickness;
FoS = 2;                                      I_spar = pi/4*(R_outer^4 - R_inner^4);

numNodes = 200;
numElements = numNodes-1;
DOF = numNodes*2;
Le = l/numElements; %length of element

%% Compute KL matrix for each Element
EI_L3 = E_spar*I_spar/Le^3;
KL = (EI_L3).*[12           6*Le         -12        6*Le; %KL matrix
               6*Le        4*Le^2       -6*Le      2*Le^2;
              -12          -6*Le          12       -6*Le;
               6*Le        2*Le^2       -6*Le      4*Le^2];
%% Assembly Matrix
KG = zeros(DOF);
for i = 1:numElements
    index = (2*i - 2)+(1:4);
    KG(index, index) = KG(index, index) + KL;
end
KG_reduced = KG(3:end,3:end); % due to boundary conditions at node 1

%% Compute distributed load (w) for each element
w = zeros(1,numElements);
for i = 1:numElements
    w(i) = -1*(liftDistribution(i) + liftDistribution(i+1))/2;
    %negative because traditional sign convention says w is positive
    %DOWNWARD, and lift points UPWARD
end

%% F vector
F_global = zeros(DOF,1);
C = zeros(1,numElements);
for i = 1:numElements
    C(i) = w(i)*Le/12;
    fe = C(i)*[6;Le;6;-Le]; %[Fi, Mi, Fi+1, Mi+1]
    index = (2*i - 2)+(1:4);
    F_global(index) = F_global(index) + fe;
end
F_reduced = F_global(3:end); %boundary conditions at node 1

%% Displacement Vector
u_reduced = KG_reduced\F_reduced; %[v_tip, theta_tip]
U = [0;0;u_reduced];
R = KG*U - F_global;

%% Calculate max stress

M_reaction = R(2);
sigmaMax = abs(M_reaction)*R_outer/I_spar; % sigma = Mc/I
loadFactor = maxAllowableStress_spar/sigmaMax;

maxG = loadFactor/FoS;
end