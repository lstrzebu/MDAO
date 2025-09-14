clear;clc
%% Human Variable Index 
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
% M3 = 
% bl = banner length (inches)

%% Vary Design Parameters (Outer Loop) 
% In other words, select a configuration. 

readM2pars

% fprintf('Generating Mission 2 variables from rules... ');
% % declare Ip1, Ip2, Ic1, Ic2, Ce, Cp, Cc
% M2_given_params = readcell("rules\M2_given_params.xlsx");
% varNames = M2_given_params(:, 2);
% varSyms = M2_given_params(:, 3);
% [thisVar, ~] = size(M2_given_params);
% for i = 1:thisVar
%     eval(sprintf("%s = %d;", varNames{i}, varSyms{i}));
% end
% fprintf('done \n');
% 
% b = 3; % wingspan;
% TPBC = 70; % total propulsion battery capacity (W*hr)
% 
% %% Run Analyses (Inner Loop)
% % In other words, tie the configuration to the physics. 
% 
% 
% %% Compute Scores (Inner Loop)
% % In other words, consider multiple mission strategies for the configuration-in-physics 
% 
% % M1 + M2 + M3
% successfulMission = 1; % points received for a successful Mission 1
% probabilities.M1 = 0.9;
% M1 = probabilities.M1 * successfulMission;

p = optimvar('p'); % passengers (ducks)
c = optimvar('c'); % cargo (pucks)
l = optimvar('l'); % laps
bl = optimvar('bl'); % banner length (inches, rounded) 

% syms bl p c l
global b 
global TPBC 
global probabilities
b = 4;
TPBC = 70;
probabilities.M1 = 0.9;
missionVars = [p, c, l, bl];

global income_net_best
global quantity_best
global mission_time_best

income_net_best = 1; % assume something here
quantity_best = 1; % assume something here
mission_time_best = 62; % assume something here

global proposal
global report
proposal = 0.9; % assume something here
report = 0.9; % assume something here

global mission_time
mission_time = 71; % ground mission time

total_score = missionObjective(missionVars)

for pVal = 1:10
    for cVal = 1:10
        for lVal = 1:10
            for blVal = 10:40
                
            end
        end
    end
end



% need to do some coarse characterization of the missionObjective()
% function to inform the initial guess

%fmincon(missionObjective, )

% p = 1; % passengers (ducks)
% c = 1; % cargo (pucks)
% l = 1; % laps
% bl = 1; % banner length (inches, rounded) 

% RAC = 0.05*b + 0.75;
% EF = TPBC/100;
% 
% income = p*(Ip1 + Ip2*l) + c*(Ic1 + Ic2*l);
% cost = EF*l*(Ce + p*Cp + c*Cc);
% income_net = income - cost;
% income_net_best = 1; % assume something here
% M2 = 1 + income_net./income_net_best;
% 
% quantity = (l*bl)/RAC;
% quantity_best = 1; % assume something here
% M3 = 2 + quantity./quantity_best;
% 
% mission_time = 71; % ground mission time
% mission_time_best = 62; % assume something here
% GM = mission_time_best/mission_time; 
% 
% proposal = 0.9; % assume something here
% report = 0.9; % assume something here
% 
% flyoff = 1; % assume we attend flyoff
% techInspScore = 1; % assume we pass tech inspection
% flightAttempt = 1; % assume we attempt a flight
% 
% TMS = M1 + M2 + M3 + GM;
% TRS = 0.15*proposal + 0.85*report; 
% P = flyoff + techInspScore + flightAttempt;
% 
% total_score = TMS*TRS + P;
% 
% missionProb = optimproblem("Objective", total_score, "ObjectiveSense", 'maximize');
% % wingspan constraints
% missionProb.Constraints.cons1 = p >= 3*c;
% 
% show(missionProb)
% solve(missionProb)
%% Optimize Mission Scores for this Configuration (Inner Loop)
% In other words, select the optimal mission strategy for this configuration-in-physics

%% Present the Best Optimal Configurations (Post Outer Loop)
% patternsearch()
% genetic algorithm ga()
% fmincon
% surrogates
% maybe an OpenMDAO call or something

%configProb.Constraints.cons1 = RAC >= 0.9;
configProb.Constraints.cons2 = b <= 5;