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

getAircraft

% check constraints here
%% Compute Scores (Inner Loop)
% % In other words, consider multiple mission strategies for the configuration-in-physics
% % M1 + M2 + M3
% successfulMission = 1; % points received for a successful Mission 1
% probabilities.M1 = 0.9;
% M1 = probabilities.M1 * successfulMission;

getMissions

% feasibleDesigns = physics(missionMatrix); % check designs for physical feasibility
% scoredDesigns = missionObjective(feasibleDesigns); % will need to rewrite
% missionObjective to be elementwise (i.e. take a matrix)









% RAC = 0.05*b + 0.75;


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