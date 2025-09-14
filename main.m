%% Variable Definitions (for human)
% RAC = rated aircraft cost
% Income = Mission 2 income
% Income_Net = Mission 2 net income (income - cost)
% Cost = Mission 2 cost
% p = # passengers
% Ip1 = Fixed income per passenger
% Ip2 = Income per passenger per lap
% Ic1 = Fixed income per cargo
% Ic2 = Income per cargo per lap
% l = # laps
% c = # cargo
% EF = efficiency factor
% TPBC = total propulsion battery capacity (W*hr)
% Ce = base operating cost per lap
% Cp = passenger operating cost per lap
% Cc = cargo operating cost per lap

%% Vary Design Parameters (Outer Loop)

% declare Ip1, Ip2, Ic1, Ic2, Ce, Cp, Cc
M2_given_params = readcell("rules\M2_given_params.xlsx");
varNames = M2_given_params(:, 2);
varSyms = M2_given_params(:, 3);
[thisVar, ~] = size(M2_given_params);
for i = 1:thisVar
    eval(sprintf("%s = %d", varNames{i}, varSyms{i}));
end

% b = ; % wingspan;

%% Run Analyses and Compute Scores (Inner Loop)
% M1 + M2 + M3

RAC = 0.05*b + 0.75;
EF = TPBC/100;

Income = p*(Ip1 + Ip2*l) + c*(Ic1 + Ic2*l);
Cost = l*(Ce + (p * Cp) + (c * Cc)) * EF;
Income_Net = Income - Cost;



%% Optimize
% patternsearch()
% genetic algorithm ga()
% fmincon
% surrogates
% maybe an OpenMDAO call or something