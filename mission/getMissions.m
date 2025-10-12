% Get missions to evaluate for AIAA 2025-2026 DBF (for a given aircraft)
% Created by Liam Trzebunia on 7 Oct 2025

fprintf('Generating mission ideas... \n')

p = optimvar('p'); % passengers (ducks)
c = optimvar('c'); % cargo (pucks)
l = optimvar('l'); % laps
bl = optimvar('bl'); % banner length (inches, rounded)
TPBC = optimvar('TPBC'); % battery capacity (W*hrs)

% syms bl p c l
% global b
% global probabilities

% TPBC = 70;
assumptions.probabilities.M1.value = 0.9;
assumptions.probabilities.M1.description = "Probability of completing mission 1 (currently assumed)";
missionVars = [p, c, l, bl, TPBC];

% global income_net_best
% global quantity_best
% global mission_time_best

assumptions.income_net_best.value = 1; % assume something here
assumptions.income_net_best.description = "Best scored income out of any team at the competition (Mission 2)";
assumptions.quantity_best.value = 1; % assume something here
assumptions.quantity_best.description = "Best Mission 3 scoring parameter (equal to something defined in the rules) scored out of any team at the competition (Mission 3)";
assumptions.mission_time_best.value = 62; % assume something here
assumptions.mission_time_best.units = 's';
assumptions.mission_time_best.description = "Best ground mission time scored out of any team at the competition";

% global proposal
% global report
assumptions.proposal.value = 0.9; % assume something here
assumptions.proposal.description = "Our score on the proposal";
assumptions.report.value = 0.9; % assume something here
assumptions.report.description = "Our score on the design report";

% global mission_time
assumptions.mission_time.value = 71; % ground mission time
assumptions.mission_time.units = 's';
assumptions.mission_time.description = "Our time scored on the ground mission";

% step = 2;
% minP = 1; stepP = 1; maxP = 2;
% minC = 1; stepC = 1; maxC = 2;
% minL = 1; stepL = 1; maxL = 2;
% minBL = 10; stepBL = 5; maxBL = 15;
% minTPBC = 5; stepTPBC = 10; maxTPBC = 15;
% coarse = zeros([length(minP:maxP), length(minC:maxC), length(minL:maxL), length(minBL:maxBL), length(minTPBC:maxTPBC)]);
% expectedRuns = length(minP:maxP)*length(minC:maxC)*length(minL:maxL)*length(minBL:maxBL)*length(minTPBC:maxTPBC);
% fprintf("Expected runs: %d", expectedRuns)
% i = 0;
% 
% Prange      = minP:stepP:maxP;
% Crange      = minC:stepC:maxC;
% Lrange      = minL:stepL:maxL;
% BLrange     = minBL:stepBL:maxBL;
% TPBCrange   = minTPBC:stepTPBC:maxTPBC;
% 
% pMat = zeros(length(minP:maxP), length(missionVars));
% numPinstances       = length(Prange);
% numCinstances       = length(Crange);
% numLinstances       = length(Lrange);
% numBLinstances      = length(BLrange);
% numTPBCinstances    = length(TPBCrange);
% numInstances = numPinstances*numCinstances*numLinstances*numBLinstances*numTPBCinstances;
% missionParamAttempts = zeros(numInstances, length(missionVars));
% 
% missionParamAttempts(1:numPinstances, 1) = Prange';
% missionParamAttempts(1:numPinstances, 2) = Crange(1);
% missionParamAttempts(1:numPinstances, 3) = Lrange(1);
% missionParamAttempts(1:numPinstances, 4) = BLrange(1);
% missionParamAttempts(1:numPinstances, 5) = TPBCrange(1);
% % missionParamAttempts(numPinstances+1:2*numPinstances, )
% % missionParamAttempts()


% step = 2; 
minP = 1; stepP = 1; maxP = 9; 
minC = 1; stepC = 1; maxC = 4;
minL = 1; stepL = 1; maxL = 8; 
minBL = 10; stepBL = 5; maxBL = 15;
minTPBC = 25; stepTPBC = 25; maxTPBC = 100;
% coarse = zeros([length(minP:maxP), length(minC:maxC), length(minL:maxL), length(minBL:maxBL), length(minTPBC:maxTPBC)]);
% 
% for pVal = minP:maxP
%     for cVal = minC:maxC
%         for lVal = minL:maxL
%             for blVal = minBL:maxBL
%                 for TPBCval = minTPBC:maxTPBC
%                     i = i + 1;
%                     fprintf('Progress = %0.2f%%\n', (i/expectedRuns)*100)
%                     coarse(pVal, cVal, lVal, blVal, TPBCval) = missionObjective([pVal, cVal, lVal, blVal, TPBCval]);
%                 end
%             end
%         end
%     end
% end


% Define the vectors for each parameter range (using the steps for generality)
pVec = minP:stepP:maxP;
cVec = minC:stepC:maxC;
lVec = minL:stepL:maxL;
blVec = minBL:stepBL:maxBL;
TPBCvec = minTPBC:stepTPBC:maxTPBC;

% Generate the multi-dimensional grids
[P, C, L, BL, TPBC] = ndgrid(pVec, cVec, lVec, blVec, TPBCvec);

% Flatten into an n x 5 matrix (each row is a combination: [pVal, cVal, lVal, blVal, TPBCval])
missions = [P(:), C(:), L(:), BL(:), TPBC(:)];

% For testing only (DELETE afterwards):
missions = missions(1,:);

% Now paramMatrix has n rows, where n = prod([numel(pVec), numel(cVec), numel(lVec), numel(blVec), numel(TPBCvec)])
expectedRuns = size(missions, 1);

% example of how to evaluate these missions
% total_score = evalScore(missionVars, aircraft, assumptions);
% show(total_score)
%% Variables necessary for static stability

% X_CG =

% aircraft.weight.empty.units
% aircraft.payload.passengers.weight.units
% aircraft.payload.cargo.weight.units

aircraft.payload.passengers.number.value = missions(:, 1);
aircraft.payload.passengers.number.units = '';
aircraft.payload.passengers.number.description = "number of passengers (rubber ducks) for Mission 2";

assumptions.payload.rubber_duck_weight_1 = "assume that the rubber ducks are between 0.6 and 0.7 oz in mass (source: competition rules)";
aircraft.payload.passengers.individual.mass.minimum.value = 0.6;
aircraft.payload.passengers.individual.mass.minimum.units = 'oz';
aircraft.payload.passengers.individual.mass.minimum.description = "lower limit of standard commerically available rubber duck mass (provided by competition)";

aircraft.payload.passengers.individual.mass.maximum.value = 0.7;
aircraft.payload.passengers.individual.mass.maximum.units = 'oz';
aircraft.payload.passengers.individual.mass.maximum.description = "upper limit of standard commerically available rubber duck mass (provided by competition)";

assumptions.payload.rubber_duck_weight_2 = "assume that on average the ducks weigh 0.65 oz (directly between minimum and maximum weights provided by competition rules)";
if strcmp(string(aircraft.payload.passengers.individual.mass.minimum.units), string(aircraft.payload.passengers.individual.mass.maximum.units))
    aircraft.payload.passengers.individual.mass.average.value = mean([aircraft.payload.passengers.individual.mass.minimum.value, aircraft.payload.passengers.individual.mass.maximum.value]);
    aircraft.payload.passengers.individual.mass.average.units = aircraft.payload.passengers.individual.mass.minimum.units;
    aircraft.payload.passengers.individual.mass.average.description = "average mass of rubber duck passenger (assumed)";
else
    error('Unit mismatch: unable to compute average mass of rubber duck passengers')
end

% (total mass of ducks) = (number of ducks)*(average mass of duck)
aircraft.payload.passengers.mass.value = aircraft.payload.passengers.number.value.*aircraft.payload.passengers.individual.mass.average.value;
aircraft.payload.passengers.mass.units = aircraft.payload.passengers.individual.mass.average.units;
aircraft.payload.passengers.mass.description = "total mass of all passengers (ducks) onboard aircraft (Mission 2)";

% convert total rubber duck mass from oz to kg
if strcmp(string(aircraft.payload.passengers.mass.units), "oz")
    aircraft.payload.passengers.mass.value = aircraft.payload.passengers.mass.value./35.274;
    aircraft.payload.passengers.mass.units = 'kg';
else
    error('Unit mismatch: conversion of total rubber duck mass from oz to kg is not possible.');
end

% compute total rubber duck weight
if strcmp(string(aircraft.payload.passengers.mass.units), "kg") && strcmp(string(constants.g.units), "m/s^2")
    aircraft.payload.passengers.weight.value = aircraft.payload.passengers.mass.value.*constants.g.value;
    aircraft.payload.passengers.weight.units = 'N';
    aircraft.payload.passengers.weight.description = "total weight of all passengers (ducks) on the aircraft (Mission 2)";
else
    error('Unit mismatch: computation of total rubber duck weight is not possible.')
end

aircraft.payload.cargo.number.value = missions(:, 2);
aircraft.payload.cargo.number.units = '';
aircraft.payload.cargo.number.description = "number of pieces of cargo (hockey pucks) for Mission 2";

assumptions.payload.puck_weight = "assume average hockey puck weight of 6 oz (source: competition rules)";
aircraft.payload.cargo.individual.mass.value = 6;
aircraft.payload.cargo.individual.mass.units = 'oz';
aircraft.payload.cargo.individual.mass.description = "standard hockey puck mass (provided by competition)";

% (total mass of pucks) = (number of pucks)*(average mass of puck)
aircraft.payload.cargo.mass.value = aircraft.payload.cargo.number.value.*aircraft.payload.cargo.individual.mass.value;
aircraft.payload.cargo.mass.units = aircraft.payload.cargo.individual.mass.units;
aircraft.payload.cargo.mass.description = "total mass of all cargo (pucks) onboard aircraft (Mission 2)";

% convert total hockey puck mass from oz to kg
if strcmp(string(aircraft.payload.cargo.mass.units), "oz")
    aircraft.payload.cargo.mass.value = aircraft.payload.cargo.mass.value./35.274;
    aircraft.payload.cargo.mass.units = 'kg';
else
    error('Unit mismatch: conversion of total hockey puck mass from oz to kg is not possible.');
end

% compute total hockey puck weight
if strcmp(string(aircraft.payload.cargo.mass.units), "kg") && strcmp(string(constants.g.units), "m/s^2")
    aircraft.payload.cargo.weight.value = aircraft.payload.cargo.mass.value.*constants.g.value;
    aircraft.payload.cargo.weight.units = 'N';
    aircraft.payload.cargo.weight.description = "total weight of all cargo (ducks) on the aircraft (Mission 2)";
else
    error('Unit mismatch: computation of total hockye puck weight is not possible.')
end

% check if units are equal
unitsToCompare = [string(aircraft.weight.empty.units), ...
    string(aircraft.payload.passengers.weight.units), ...
    string(aircraft.payload.cargo.weight.units)];
% Compare each string to the first one
comparisonResults = strcmp(unitsToCompare, unitsToCompare(1));
% Check if all comparisons are true
equalUnits = all(comparisonResults);

if equalUnits
aircraft.weight.loaded.value = aircraft.weight.empty.value + aircraft.payload.passengers.weight.value + aircraft.payload.cargo.weight.value; 
aircraft.weight.loaded.units = char(unitsToCompare(1));
aircraft.weight.loaded.description = "maximum gross takeoff weight for aircraft for Mission 2";
else
    error('Unit mismatch: maximum gross takeoff weight could not be computed. Ensure the weights of aircraft components share the same units.')
end

mission.weather.air_density.value = 0.002377; % SSL density (change later)
mission.weather.air_density.units = 'slugs/ft^3';
mission.weather.air_density.description = "density of air at competition location on competition day";

fprintf('Done generating mission ideas.\n')