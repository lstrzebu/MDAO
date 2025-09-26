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

checkDesignConstraints
checkMissionConstraints

% check constraints here

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
%% Compute Scores (Inner Loop)
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
TPBC = optimvar('TPBC'); % battery capacity (W*hrs)

% syms bl p c l
global b
global probabilities
b = 4;
% TPBC = 70;
probabilities.M1 = 0.9;
missionVars = [p, c, l, bl, TPBC];

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

total_score = missionObjective(missionVars);
show(total_score)

step = 2;
minP = 1; stepP = 1; maxP = 2;
minC = 1; stepC = 1; maxC = 2;
minL = 1; stepL = 1; maxL = 2;
minBL = 10; stepBL = 5; maxBL = 15;
minTPBC = 5; stepTPBC = 10; maxTPBC = 15;
coarse = zeros([length(minP:maxP), length(minC:maxC), length(minL:maxL), length(minBL:maxBL), length(minTPBC:maxTPBC)]);
expectedRuns = length(minP:maxP)*length(minC:maxC)*length(minL:maxL)*length(minBL:maxBL)*length(minTPBC:maxTPBC);
fprintf("Expected runs: %d", expectedRuns)
i = 0;

Prange      = minP:stepP:maxP;
Crange      = minC:stepC:maxC;
Lrange      = minL:stepL:maxL;
BLrange     = minBL:stepBL:maxBL;
TPBCrange   = minTPBC:stepTPBC:maxTPBC;

pMat = zeros(length(minP:maxP), length(missionVars));
numPinstances       = length(Prange);
numCinstances       = length(Crange);
numLinstances       = length(Lrange);
numBLinstances      = length(BLrange);
numTPBCinstances    = length(TPBCrange);
numInstances = numPinstances*numCinstances*numLinstances*numBLinstances*numTPBCinstances;
missionParamAttempts = zeros(numInstances, length(missionVars));

missionParamAttempts(1:numPinstances, 1) = Prange';
missionParamAttempts(1:numPinstances, 2) = Crange(1);
missionParamAttempts(1:numPinstances, 3) = Lrange(1);
missionParamAttempts(1:numPinstances, 4) = BLrange(1);
missionParamAttempts(1:numPinstances, 5) = TPBCrange(1);
% missionParamAttempts(numPinstances+1:2*numPinstances, )
% missionParamAttempts()

for pVal = minP:maxP
    for cVal = minC:maxC
        for lVal = minL:maxL
            for blVal = minBL:maxBL
                for TPBCval = minTPBC:maxTPBC
                    i = i + 1;
                    fprintf('Progress = %0.2f%%\n', (i/expectedRuns)*100)
                    coarse(pVal, cVal, lVal, blVal, TPBCval) = missionObjective([pVal, cVal, lVal, blVal, TPBCval]);
                end
            end
        end
    end
end

RAC = 0.05*b + 0.75;


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