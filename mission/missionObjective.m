function recip = missionObjective(missionVars)
% Liam Trzebunia
% 26 September 2025
% Calculate total competition score for an AIAA DBF 2025-2026 aircraft
% design flown for a particular number of laps (l), carrying a particular
% number of passengers (p) and cargo (c), towing a banner of a particular
% length (bl), and carrying a particular total propulsion battery capacity
% (TPBC). 

fprintf('Calculating mission scores for designs... ')

% aircraft configuration parameters change depending on when the function is called. 
% These configuration parameters (design variables) are accessed as global
% variables.
global b 
global probabilities 
p       = missionVars(1);
c       = missionVars(2);
l       = missionVars(3);
bl      = missionVars(4);
TPBC    = missionVars(5);

readM2pars

RAC = 0.05*b + 0.75;
EF = TPBC/100;

successfulMission = 1; % points received for a successful Mission 1
M1 = probabilities.M1 * successfulMission;

global mission_time

global income_net_best
global quantity_best
global mission_time_best

income = p*(Ip1 + Ip2*l) + c*(Ic1 + Ic2*l);
cost = EF*l*(Ce + p*Cp + c*Cc);
income_net = income - cost;
M2 = 1 + income_net./income_net_best;

quantity = (l*bl)/RAC;
M3 = 2 + quantity./quantity_best;

GM = mission_time_best/mission_time; 

global proposal
global report

flyoff = 1; % assume we attend flyoff
techInspScore = 1; % assume we pass tech inspection
flightAttempt = 1; % assume we attempt a flight

TMS = M1 + M2 + M3 + GM;
TRS = 0.15*proposal + 0.85*report; 
P = flyoff + techInspScore + flightAttempt;

total_score = TMS*TRS + P;

recip = 1/total_score;

fprintf('Done \n');

end


