clear;clc
%% Index of Variables
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

%% One-Time Setup Actions
setup

%% Vary Design Parameters (Outer Loop)
% In other words, select a configuration.

getAircraft % primary output: a bunch of (global?) sizing variables

% check constraints here
%% Compute Mission Scores (Inner Loop)
% generate a matrix of missions to test
getMissions % primary output: missions

% remove physically infeasible missions
pruneMissions % primary output: feasibleMissions

% select the best mission for this particular aircraft
optimizeMission % primary output: bestMission

% store the aircraft and its optimal mission somewhere for future use
saveAircraft

% scoredDesigns = missionObjective(feasibleDesigns); % will need to rewrite missionObjective to be elementwise (i.e. receive a matrix input)

