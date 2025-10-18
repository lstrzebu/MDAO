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
probabilities.M1.value = 0.9;
probabilities.M1.description = "Probability of completing mission 1 (currently assumed)";

assumptions(end+1).name = "Mission 1 Completion Probability";
assumptions(end+1).description = sprintf("Assume %d%% probability of successfully completing Mission 1", 100*probabilities.M1.value);
assumptions(end+1).rationale = "Assumed value out of a desire to holistically evaluate total competition score";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

missionVars = [p, c, l, bl, TPBC];

% global income_net_best
% global quantity_best
% global mission_time_best

income_net_best = 1;

assumptions(end+1).name = "Best Mission 2 Net Income";
assumptions(end+1).description = sprintf("Assume the highest net income score for Mission 2 out of any teams at the competition is %d", income_net_best);
assumptions(end+1).rationale = "None; temporary value";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

quantity_best = 1;

assumptions(end+1).name = "Best Mission 3 Scoring Parameter";
assumptions(end+1).description = sprintf("Assume the best scoring parameter for Mission 3 out of any team at the competition is %d", quantity_best);
assumptions(end+1).rationale = "None; temporary value";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

mission_time_best = 62; % assume something here

assumptions(end+1).name = "Best Ground Mission Time";
assumptions(end+1).description = sprintf("Assume the best ground mission time out of any team at the competition is %d", mission_time_best);
assumptions(end+1).rationale = "None; temporary value";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

% global proposal
% global report
proposal = 0.9; % assumed proposal score
% assumptions.proposal.description = "Our score on the proposal";
report = 0.9; % assume something here
% assumptions.report.description = "Our score on the design report";

assumptions(end+1).name = "Proposal Score";
assumptions(end+1).description = sprintf("Assume %d%% score on proposal submission", 100*proposal);
assumptions(end+1).rationale = "None; temporary value";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

assumptions(end+1).name = "Report Score";
assumptions(end+1).description = sprintf("Assume %d%% score on report submission", 100*report);
assumptions(end+1).rationale = "None; temporary value";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

% global mission_time
mission_time = 71; % ground mission time in seconds

assumptions(end+1).name = "Ground Mission Time";
assumptions(end+1).description = sprintf("Assume %ds time for completion of ground mission", mission_time);
assumptions(end+1).rationale = "None; temporary value. In the future time ourselves practicing the ground mission and use an average of our timed practice attempts";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";


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
minP = 1; stepP = 1; maxP = 30; 
minC = 1; stepC = 1; maxC = 4;
minL = 1; stepL = 1; maxL = 8; 
minBL = 10; stepBL = 5; maxBL = 15;
TPBCscal = aircraft.propulsion.battery.capacity.value; % scalar for total propulsion battery capacity: units of Wh
%minTPBC = 25; stepTPBC = 25; maxTPBC = 100;
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
%PBCvec = minTPBC:stepTPBC:maxTPBC;

% Generate the multi-dimensional grids
[P, C, L, BL] = ndgrid(pVec, cVec, lVec, blVec);

% Flatten into an n x 5 matrix (each row is a combination: [pVal, cVal, lVal, blVal, TPBCval])
missions = [P(:), C(:), L(:), BL(:)];
missions(:, 5) = TPBCscal; % no variation of propulsion battery capacity during mission generation... only during aircraft generation 

% logical mask for missions to ensure (number of ducks) >= 3*(number of pucks)
ducks_pucks_mask = missions(:,1) >= 3.*missions(:,2);
missions = missions(ducks_pucks_mask, :);

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
aircraft.payload.passengers.number.type = "non";
aircraft.payload.passengers.number.description = "number of passengers (rubber ducks) for Mission 2";

assumptions(end+1).name = "Statistical Consideration of Rubber Duck Weight";
assumptions(end+1).description = "Assume that on average, a rubber duck weighs 0.65 oz";
assumptions(end+1).rationale = "Competition rules state that rubber ducks are between 0.6 and 0.7 oz in mass, although this is not necessarily a hard and fast rule";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.payload.passengers.individual.mass.minimum.value = 0.6;
aircraft.payload.passengers.individual.mass.minimum.units = 'oz';
aircraft.payload.passengers.individual.mass.minimum.description = "lower limit of standard commerically available rubber duck mass (provided by competition)";

aircraft.payload.passengers.individual.mass.maximum.value = 0.7;
aircraft.payload.passengers.individual.mass.maximum.units = 'oz';
aircraft.payload.passengers.individual.mass.maximum.description = "upper limit of standard commerically available rubber duck mass (provided by competition)";

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
    aircraft.payload.passengers.weight.type = "force";
    aircraft.payload.passengers.weight.description = "total weight of all passengers (ducks) on the aircraft (Mission 2)";
else
    error('Unit mismatch: computation of total rubber duck weight is not possible.')
end

aircraft.payload.cargo.number.value = missions(:, 2);
aircraft.payload.cargo.number.units = '';
aircraft.payload.cargo.number.description = "number of pieces of cargo (hockey pucks) for Mission 2";

assumptions(end+1).name = "Hockey Puck Weight";
assumptions(end+1).description = "Assume average hockey puck weight of 6 oz";
assumptions(end+1).rationale = "Source: competition rules";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

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
    aircraft.payload.cargo.weight.type = "force";
    aircraft.payload.cargo.weight.description = "total weight of all cargo (ducks) on the aircraft (Mission 2)";
else
    error('Unit mismatch: computation of total hockye puck weight is not possible.')
end

% % check if units are equal
% unitsToCompare = [string(aircraft.unloaded.weight.units), ...
%     string(aircraft.payload.passengers.weight.units), ...
%     string(aircraft.payload.cargo.weight.units)];
% % Compare each string to the first one
% comparisonResults = strcmp(unitsToCompare, unitsToCompare(1));
% % Check if all comparisons are true
% equalUnits = all(comparisonResults);
% 
% if equalUnits
% aircraft.loaded.weight.value = aircraft.unloaded.weight.value + aircraft.payload.passengers.weight.value + aircraft.payload.cargo.weight.value; 
% aircraft.loaded.weight.units = char(unitsToCompare(1));
% aircraft.loaded.weight.type = "force";
% aircraft.loaded.weight.description = "maximum gross takeoff weight for aircraft for Mission 2";
% else
%     error('Unit mismatch: maximum gross takeoff weight could not be computed. Ensure the weights of aircraft components share the same units.')
% end

mission.weather.air_density.value = 0.002377; % SSL density (change later)
mission.weather.air_density.units = 'slug/ft^3';
mission.weather.air_density.description = "density of air at competition location on competition day";
mission.weather.air_density.type = "density";

aircraft.payload.cargo.XYZ_CG = aircraft.unloaded.XYZ_CG;
aircraft.payload.cargo.XYZ_CG.description = "vector of X, Y, Z coordinates for CG of pucks";

% duck dimensions
aircraft.payload.passengers.individual.width.value = mean([2.0 2.3]);
aircraft.payload.passengers.individual.width.units = 'in';
aircraft.payload.passengers.individual.width.type = "length";
aircraft.payload.passengers.individual.width.description = "average width of rubber duck";

assumptions(end+1).name = "Rubber Duck Width";
assumptions(end+1).description = sprintf("Assume average rubber duck width (including padding/spacing and restraint) of %.2f %s. This is obtained by multiplying the mean of 2.0 and 2.3 by 110%.", aircraft.payload.passengers.individual.width.value, aircraft.payload.passengers.individual.width.units);
assumptions(end+1).rationale = "Source: competition rules. Assumption is applying the average";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.payload.passengers.individual.length.value = 1.1*mean([2.0 2.5]);
aircraft.payload.passengers.individual.length.units = 'in';
aircraft.payload.passengers.individual.length.type = "length";
aircraft.payload.passengers.individual.length.description = "average length of rubber duck";

assumptions(end+1).name = "Rubber Duck Length";
assumptions(end+1).description = sprintf("Assume average rubber duck length (including padding/spacing and restraint) of %.2f %s. This is obtained by multiplying the mean of 2.0 and 2.5 by 110%.", aircraft.payload.passengers.individual.width.value, aircraft.payload.passengers.individual.width.units);
assumptions(end+1).rationale = "Source: competition rules. Assumption is applying the average";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

if strcmp(string(aircraft.payload.passengers.individual.length.units), "in") && strcmp(string(aircraft.payload.passengers.individual.width.units), "in")
aircraft.payload.passengers.individual.area.value = aircraft.payload.passengers.individual.length.value.*aircraft.payload.passengers.individual.width.value;
aircraft.payload.passengers.individual.area.units = "in^2";
aircraft.payload.passengers.individual.area.type = "area";
aircraft.payload.passengers.individual.area.description = "average area occupied by a rubber duck";
else
    error('Unit mismatch: calculation of average rubber duck area is not possible.');
end

ducksPerRow = 2;
assumptions(end+1).name = "Rubber Ducks per Row";
assumptions(end+1).description = "Assume 2 rubber ducks per row of seating in the fuselage";
assumptions(end+1).rationale = "Would take a very wide fuselage to accomodate more than 2 ducks per row";
assumptions(end+1).responsible_engineer = "Eric Stout";

% calculate max number of rows of ducks the fuselage can hold
if strcmp(string(aircraft.fuselage.length.units), string(aircraft.payload.passengers.individual.length.units))
maxRows = floor((aircraft.fuselage.length.value/2)/aircraft.payload.passengers.individual.length.value);
else
    error('Unit mismatch: computation of maximum number of ducks not possible.');
end
maxDucks = maxRows.*2;

% remove missions with too many ducks to fit into the fuselage
max_ducks_mask = missions(:,1) <= maxDucks;
missions = missions(max_ducks_mask, :);

% start placing ducks at front right of available areas and work way to
% left and backwards
aircraft.payload.passengers.available_area.value = (2.*aircraft.payload.passengers.individual.width.value).*(aircraft.fuselage.length.value./2);
aircraft.payload.passengers.available_area.units = "in^2";
aircraft.payload.passengers.available_area.type = "area";
aircraft.payload.passengers.available_area.description = "area in fuselage available to accomodate additional ducks";

aircraft.payload.passengers.individual.max_height.value = 2.5;
aircraft.payload.passengers.individual.max_height.units = 'in';
aircraft.payload.passengers.individual.max_height.type = "length";
aircraft.payload.passengers.individual.max_height.description = "maximum height of a rubber duck";

assumptions(end+1).name = "Rubber Duck Locations";
assumptions(end+1).description = "Assume rubber ducks are placed in a plane in the rear half of the fuselage with an extra 10% of their width and length used as spacing/for restraints and an extra 50% of their maximum height used as spacing between the tops of the ducks and the heighest point of the fuselage";
assumptions(end+1).rationale = "Get something working for MDAO; replace with one of multiple fuselages later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

if strcmp(string(aircraft.fuselage.protrusion.units), "in") && strcmp(string(aircraft.fuselage.length.units), "in") && strcmp(string(aircraft.payload.passengers.individual.length.units), "in") && strcmp(string(aircraft.payload.passengers.individual.width.units), "in") && strcmp(string(aircraft.fuselage.diameter.units), "in") && strcmp(string(aircraft.fuselage.hull.thickness.units), "in") && strcmp(aircraft.payload.passengers.individual.max_height.units, "in")
    for i = 1:aircraft.payload.passengers.number.value
        rowNum = ceil(i/2); 

        % if i is odd, place duck on right hand side of aircraft
        % if i is even, place duck on left hand side of aircraft
        if rem(i, 2) ~= 0
            aircraft.payload.passengers.individual.XYZ_CG.value(i, :) = [-aircraft.fuselage.protrusion.value + aircraft.fuselage.length.value + (rowNum-1).*aircraft.payload.passengers.individual.length.value + aircraft.payload.passengers.individual.length.value/2, aircraft.payload.passengers.individual.width.value, aircraft.fuselage.diameter.value - aircraft.fuselage.hull.thickness.value - aircraft.payload.passengers.individual.max_height.value]; 
        else
            aircraft.payload.passengers.individual.XYZ_CG.value(i, :) = [-aircraft.fuselage.protrusion.value + aircraft.fuselage.length.value + (rowNum-1).*aircraft.payload.passengers.individual.length.value + aircraft.payload.passengers.individual.length.value/2, -aircraft.payload.passengers.individual.width.value, aircraft.fuselage.diameter.value - aircraft.fuselage.hull.thickness.value - aircraft.payload.passengers.individual.max_height.value]; 
        end
        aircraft.payload.passengers.individual.XYZ_CG.units = 'in';
        aircraft.payload.passengers.individual.XYZ_CG.type = "length";
        aircraft.payload.passengers.individual.XYZ_CG.description = "array where each row is the X, Y, Z coordinates of a rubber duck CG";
    end
else
    error('Unit mismatch: computation of rubber duck CGs is not possible.')
end

if strcmp(string(aircraft.payload.passengers.individual.mass.average.units), "oz")
    aircraft.payload.passengers.individual.mass.average.value = aircraft.payload.passengers.individual.mass.average.value./35.274;
    aircraft.payload.passengers.individual.mass.average.units = 'kg';
else
    error('Unit mismatch: computation of rubber duck CGs is not possible.')
end

if strcmp(string(constants.g.units), "m/s^2")
duck_weights = zeros([aircraft.payload.passengers.number.value, 1]);
duck_weights(:) = aircraft.payload.passengers.individual.mass.average.value.*constants.g.value; % kg * m/s^2 = N
else
    error('Unit mismatch: computation of rubber duck CGs is not possible.');
end

duck_cgs = aircraft.payload.passengers.individual.XYZ_CG.value; % units should be inches 

% calculate net duck CG
aircraft.payload.passengers.XYZ_CG.value = composite_cg(duck_weights, duck_cgs); % output units match input units
aircraft.payload.passengers.XYZ_CG.units = aircraft.payload.passengers.individual.XYZ_CG.units;
aircraft.payload.passengers.XYZ_CG.type = "length";
aircraft.payload.passengers.XYZ_CG.description = "net CG of all ducks onboard aircraft";

% ensure units match up prior to loaded weight calculation
structNames = ["aircraft.unloaded.weight";
"aircraft.payload.passengers.weight";
"aircraft.payload.cargo.weight"];
desiredUnits = ["N";
    "N";
    "N"];
[aircraft, ~] = conv_aircraft_units(aircraft, 0, structNames, desiredUnits);

% ensure units match up prior to loaded CG calculation
structNames = ["aircraft.unloaded.XYZ_CG";
"aircraft.payload.passengers.XYZ_CG";
"aircraft.payload.cargo.XYZ_CG"];
desiredUnits = ["in";
    "in";
    "in"];
[aircraft, ~] = conv_aircraft_units(aircraft, 0, structNames, desiredUnits);

% prepare for loaded weight and loaded CG calculations
weights = [aircraft.unloaded.weight.value; 
    aircraft.payload.passengers.weight.value;
    aircraft.payload.cargo.weight.value];
cgs = [aircraft.unloaded.XYZ_CG.value; 
    aircraft.payload.passengers.XYZ_CG.value;
    aircraft.payload.cargo.XYZ_CG.value];

% loaded weight calculation
aircraft.loaded.weight.value = sum(weights);
aircraft.loaded.weight.units = 'N';
aircraft.loaded.weight.type = "force";
aircraft.loaded.weight.description = "total weight of aircraft + payload, where payload is all ducks and all pucks for Mission 2";

% loaded CG calculation
aircraft.loaded.XYZ_CG.value = composite_cg(weights, cgs);
aircraft.loaded.XYZ_CG.units = 'in';
aircraft.loaded.XYZ_CG.type = "length";
aircraft.loaded.XYZ_CG.description = "vector of X, Y, Z coordinates for loaded aircraft CG (loaded aircraft includes payload of ducks, pucks)";

assumptions(end+1).name = "Neglect Rubber Duck Moment of Inertia";
assumptions(end+1).description = "Assume that moment of inertia of each individual duck (and therefore of the ducks collectively) are approximately zero";
assumptions(end+1).rationale = "Rubber ducks are light and small";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.payload.passengers.MOI.value = zeros(3);
aircraft.payload.passengers.MOI.units = '';
aircraft.payload.passengers.MOI.type = "MOI";
aircraft.payload.passengers.MOI.description = "moment of inertia of all ducks about the origin of the coordinate system";

aircraft.payload.cargo.individual.radius.value = 3/2;
aircraft.payload.cargo.individual.radius.units = 'in';
aircraft.payload.cargo.individual.radius.type = "length";
aircraft.payload.cargo.individual.radius.description = "radius of a standard hockey puck";

aircraft.payload.cargo.individual.height.value = 1;
aircraft.payload.cargo.individual.height.units = 'in';
aircraft.payload.cargo.individual.height.type = "length";
aircraft.payload.cargo.individual.height.description = "height of a standard hockey puck";


% compute the total pucks MOI as the MOI of a cylinder whose axis is
% parallel to the x axis
m = aircraft.payload.cargo.mass.value; % mass of the net cylinder of stacked pucks (kg)
r = aircraft.payload.cargo.individual.radius.value; % radius of the net cylinder of stacked pucks (in)
numPucks = missions(:, 2);
h = numPucks.*aircraft.payload.cargo.individual.height.value; % height of the net cylinder of stacked pucks (in)
I_par = m.*(r.^2)./2; % parallel moment of inertia of cylinder
I_perp = (1/12).*m.*(h.^2 + 3.*r.^2); % perpendicular moment of inertia of cylinder
I_xx = I_par;
I_yy = I_perp;
I_zz = I_perp;
I = zeros(3);
I(1,1) = I_xx;
I(2,2) = I_yy;
I(3,3) = I_zz;
aircraft.payload.cargo.MOI.value = I;
aircraft.payload.cargo.MOI.units = 'kg*in^2';
aircraft.payload.cargo.MOI.type = "MOI";
aircraft.payload.cargo.MOI.description = "moment of inertia matrix for all pucks about the CG of the net stacked cylinder of pucks";

% % Wing MOI 
% if strcmp(string(aircraft.wing.skin.XYZ_CG.units), "in")
%     cm_wing = aircraft.wing.skin.XYZ_CG.value';
% else
%     error('Unit mismatch: computation of wing skin MOI not possible.')
% end

if strcmp(string(aircraft.wing.skin.mass.units), "kg") && strcmp(string(aircraft.wing.b.units), "in") && strcmp(string(aircraft.wing.c.units), "in")
    mass_wing = aircraft.wing.skin.mass.value; % [kg]
    b_wing = aircraft.wing.b.value;
    c_wing = aircraft.wing.c.value;
    
    % Mass moments of inertia about the wing's cm
    I_xx_wing = (1/12)*(mass_wing)*(b_wing^2); % kg*in^2
    I_yy_wing = (1/12)*(mass_wing)*(c_wing^2); % kg*in^@
    I_zz_wing = I_xx_wing + I_yy_wing; % kg*in^2

    % Product moments of inertia about wings CM are zero because wing is
    % symmetrical
    I_xy_wing = 0;
    I_yz_wing = 0;
    I_xz_wing = 0;

    I_wing  = [I_xx_wing, I_xy_wing, I_xz_wing; ...
        I_xy_wing, I_yy_wing, I_yz_wing; ...
        I_xz_wing, I_yz_wing, I_zz_wing];

else
    error('Unit mismatch: computation of wing skin MOI not possible.')
end

aircraft.wing.skin.MOI.value = I_wing;
aircraft.wing.skin.MOI.units = 'kg*in^2';
aircraft.wing.skin.MOI.type = "MOI";
aircraft.wing.skin.MOI.description = "moment of inertia matrix for wings about their own center of mass";

% HT MOI 
if strcmp(string(aircraft.tail.horizontal.skin.XYZ_CG.units), "in")
    cm_HT = aircraft.tail.horizontal.skin.XYZ_CG.value';
else
    error('Unit mismatch: computation of horizontal tail skin MOI not possible.')
end

if strcmp(string(aircraft.tail.horizontal.skin.mass.units), "kg") && strcmp(string(aircraft.tail.horizontal.b.units), "in") && strcmp(string(aircraft.tail.horizontal.c.units), "in")
    mass_HT = aircraft.tail.horizontal.skin.mass.value; % [kg]
    b_HT = aircraft.tail.horizontal.b.value;
    c_HT = aircraft.tail.horizontal.c.value;
    
    % Mass moments of inertia about the horizontal tail's cm
    I_xx_HT = (1/12)*(mass_HT)*(b_HT^2); % kg*in^2
    I_yy_HT = (1/12)*(mass_HT)*(c_HT^2); % kg*in^2
    I_zz_HT = I_xx_HT + I_yy_HT; % kg*in^2

    % Product moments of inertia about horizontal tails CM are zero because horizontal tail is
    % symmetrical
    I_xy_HT = 0;
    I_yz_HT = 0;
    I_xz_HT = 0;

    I_HT  = [I_xx_HT, I_xy_HT, I_xz_HT; ...
        I_xy_HT, I_yy_HT, I_yz_HT; ...
        I_xz_HT, I_yz_HT, I_zz_HT];

else
    error('Unit mismatch: computation of horizontal tail skin MOI not possible.')
end

aircraft.tail.horizontal.skin.MOI.value = I_HT;
aircraft.tail.horizontal.skin.MOI.units = 'kg*in^2';
aircraft.tail.horizontal.skin.MOI.type = "MOI";
aircraft.tail.horizontal.skin.MOI.description = "moment of inertia matrix for horizontal tail about its own center of mass";

% VT MOI 
if strcmp(string(aircraft.tail.vertical.skin.XYZ_CG.units), "in")
    cm_VT = aircraft.tail.vertical.skin.XYZ_CG.value';
else
    error('Unit mismatch: computation of vertical tail skin MOI not possible.')
end

if strcmp(string(aircraft.tail.vertical.skin.mass.units), "kg") && strcmp(string(aircraft.tail.vertical.b.units), "in") && strcmp(string(aircraft.tail.vertical.c.units), "in")
    mass_VT = aircraft.tail.vertical.skin.mass.value; % [kg]
    b_VT = aircraft.tail.vertical.b.value;
    c_VT = aircraft.tail.vertical.c.value;
    
    % Mass moments of inertia about the vertical tail's cm
    I_xx_VT = (1/12)*(mass_VT)*((b_VT/2)^2); % kg*in^2
    I_zz_VT = (1/12)*(mass_VT)*(c_VT^2); % kg*in^2
    I_yy_VT = I_xx_VT + I_zz_VT; % kg*in^2

    % Product moments of inertia about vertical tails CM are zero because vertical tail is
    % symmetrical
    I_xy_VT = 0;
    I_yz_VT = 0;
    I_xz_VT = 0;

    I_VT  = [I_xx_VT, I_xy_VT, I_xz_VT; ...
        I_xy_VT, I_yy_VT, I_yz_VT; ...
        I_xz_VT, I_yz_VT, I_zz_VT];

else
    error('Unit mismatch: computation of vertical tail skin MOI not possible.')
end

aircraft.tail.vertical.skin.MOI.value = I_VT;
aircraft.tail.vertical.skin.MOI.units = 'kg*in^2';
aircraft.tail.vertical.skin.MOI.type = "MOI";
aircraft.tail.vertical.skin.MOI.description = "moment of inertia matrix for vertical tail about its own center of mass";

% prepare to calculate motor MOI
if strcmp(string(constants.g.units), "m/s^2") && strcmp(string(aircraft.propulsion.motor.weight.units), "N")
    aircraft.propulsion.motor.mass.value = aircraft.propulsion.motor.weight.value./constants.g.value;
    aircraft.propulsion.motor.mass.units = 'kg';
    aircraft.propulsion.motor.mass.type = "mass";
    aircraft.propulsion.motor.mass.description = "mass of motor (modeled as a uniform density cylinder, slightly inaccurate due to stator length differing from shaft length)";
else
    error('Unit mismatch: computation of motor MOI is not possible.')
end

% compute the motor MOI as the MOI of a uniform density cylinder whose axis is parallel to the x axis
m = aircraft.propulsion.motor.mass.value; % mass of the motor cylinder (kg)
r = aircraft.propulsion.motor.diameter_outer.value./2; % radius of the motor cylinder (in)
h = aircraft.propulsion.motor.length.value; % height of the motor cylinder (in)
I_par = m.*(r.^2)./2; % parallel moment of inertia of cylinder
I_perp = (1/12).*m.*(h.^2 + 3.*r.^2); % perpendicular moment of inertia of cylinder
I_xx = I_par;
I_yy = I_perp;
I_zz = I_perp;
I = zeros(3);
I(1,1) = I_xx;
I(2,2) = I_yy;
I(3,3) = I_zz;
aircraft.propulsion.motor.MOI.value = I;
aircraft.propulsion.motor.MOI.units = 'kg*in^2';
aircraft.propulsion.motor.MOI.type = "MOI";
aircraft.propulsion.motor.MOI.description = "moment of inertia matrix for motor";

aircraft.propulsion.ESC.MOI.value = zeros(3);
aircraft.propulsion.ESC.MOI.units = 'kg*in^2';
aircraft.propulsion.ESC.MOI.type = "MOI";
aircraft.propulsion.ESC.MOI.description = "moment of inertia matrix for electronic speed controller (ESC)";

assumptions(end+1).name = "Neglect ESC MOI";
assumptions(end+1).description = "Assume the moments of inertia for the ESC are approximately zero";
assumptions(end+1).rationale = "The ESC weighs only 126 grams";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

% prepare to calculate propeller MOI
if strcmp(string(constants.g.units), "m/s^2") && strcmp(string(aircraft.propulsion.propeller.weight.units), "N")
    aircraft.propulsion.propeller.mass.value = aircraft.propulsion.propeller.weight.value./constants.g.value;
    aircraft.propulsion.propeller.mass.units = 'kg';
    aircraft.propulsion.propeller.mass.type = "mass";
    aircraft.propulsion.propeller.mass.description = "mass of propeller (modeled as a flat disk)";
else
    error('Unit mismatch: computation of propeller MOI is not possible.')
end

% compute the propeller MOI as the MOI of a flat disk
m = aircraft.propulsion.propeller.mass.value; % mass (kg)
r = aircraft.propulsion.propeller.diameter.value/2; % radius (in)
I_xx = 0.5*m*r^2;
I_yy = 0.25*m*r^2;
I_zz = I_yy;
I = zeros(3);
I(1,1) = I_xx;
I(2,2) = I_yy;
I(3,3) = I_zz;
aircraft.propulsion.propeller.MOI.value = I;
aircraft.propulsion.propeller.MOI.units = 'kg*in^2';
aircraft.propulsion.propeller.MOI.type = "MOI";
aircraft.propulsion.propeller.MOI.description = "moment of inertia matrix for propeller";

% prepare to calculate battery MOI
if strcmp(string(constants.g.units), "m/s^2") && strcmp(string(aircraft.propulsion.battery.weight.units), "N")
    aircraft.propulsion.battery.mass.value = aircraft.propulsion.battery.weight.value./constants.g.value;
    aircraft.propulsion.battery.mass.units = 'kg';
    aircraft.propulsion.battery.mass.type = "mass";
    aircraft.propulsion.battery.mass.description = "mass of battery";
else
    error('Unit mismatch: computation of battery MOI is not possible.')
end

% compute the battery MOI as the MOI of a rectangular prism
m = aircraft.propulsion.battery.mass.value; % kg
l = aircraft.propulsion.battery.length.value; % in
w = aircraft.propulsion.battery.width.value; % in
h = aircraft.propulsion.battery.height.value; % in 

assumptions(end+1).name = "Battery Orientation";
assumptions(end+1).description = "Assume the battery has an identical z coordinate to the aircraft CG. The battery length is in line with the y axis, the width is in line with the x axis, and the height is in line with the z axis.";
assumptions(end+1).rationale = "Orienting the battery with length along the y axis will help the aircraft resist roll. Change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

% l along y
% w along x
% h along z

% https://mechanicsmap.psu.edu/websites/centroidtables/centroids3D/centroids3D.html
% w along x therefore their w = my w
% h along y therefore their h = my l
% d along z therefore their d = my h

I_xx = (1/12)*m*(l^2 + h^2);
I_yy = (1/12)*m*(h^2 + w^2);
I_zz = (1/12)*m*(l^2 + w^2);
I = zeros(3);
I(1,1) = I_xx;
I(2,2) = I_yy;
I(3,3) = I_zz;
aircraft.propulsion.battery.MOI.value = I;
aircraft.propulsion.battery.MOI.units = 'kg*in^2';
aircraft.propulsion.battery.MOI.type = "MOI";
aircraft.propulsion.battery.MOI.description = "moment of inertia matrix for battery";

% Calculate net MOI for unloaded aircraft

units = [aircraft.fuselage.hull.XYZ_CG.units;
aircraft.wing.skin.XYZ_CG.units;
aircraft.tail.horizontal.skin.XYZ_CG.units;
aircraft.tail.vertical.skin.XYZ_CG.units;
aircraft.propulsion.motor.XYZ_CG.units;
aircraft.propulsion.ESC.XYZ_CG.units;
aircraft.propulsion.propeller.XYZ_CG.units;
aircraft.propulsion.battery.XYZ_CG.units];
unitsAgree = strcmp(units, "in");
if all(unitsAgree)
cg_locations = {aircraft.fuselage.hull.XYZ_CG.value', ...
    aircraft.wing.skin.XYZ_CG.value', ...
aircraft.tail.horizontal.skin.XYZ_CG.value', ...
aircraft.tail.vertical.skin.XYZ_CG.value', ...
aircraft.propulsion.motor.XYZ_CG.value', ...
aircraft.propulsion.ESC.XYZ_CG.value', ...
aircraft.propulsion.propeller.XYZ_CG.value', ...
aircraft.propulsion.battery.XYZ_CG.value'};
else
    error('Unit mismatch: calculation of unloaded aircraft MOI not possible.')
end

units = [aircraft.fuselage.hull.mass.units;
aircraft.wing.skin.mass.units;
aircraft.tail.horizontal.skin.mass.units;
aircraft.tail.vertical.skin.mass.units;
aircraft.propulsion.motor.mass.units;
aircraft.propulsion.ESC.mass.units;
aircraft.propulsion.propeller.mass.units;
aircraft.propulsion.battery.mass.units];
unitsAgree = strcmp(units, "kg");
if all(unitsAgree)
masses = {aircraft.fuselage.hull.mass.value, ...
    aircraft.wing.skin.mass.value, ...
aircraft.tail.horizontal.skin.mass.value, ...
aircraft.tail.vertical.skin.mass.value, ...
aircraft.propulsion.motor.mass.value, ...
aircraft.propulsion.ESC.mass.value, ...
aircraft.propulsion.propeller.mass.value, ...
aircraft.propulsion.battery.mass.value};
else
    error('Unit mismatch: calculation of unloaded aircraft MOI not possible.')
end

aircraft.fuselage.hull.MOI.value = zeros(3);
aircraft.fuselage.hull.MOI.units = 'kg*in^2';
aircraft.fuselage.hull.MOI.type = "MOI";
aircraft.fuselage.hull.MOI.description = "moment of inertia of fuselage hull (not including structural bulkheads)";

assumptions(end+1).name = "Neglect Fuselage MOI";
assumptions(end+1).description = "For now, until I get values from Sam... neglect fuselage MOI";
assumptions(end+1).rationale = "Temporary";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

units = [aircraft.fuselage.hull.MOI.units;
aircraft.wing.skin.MOI.units;
aircraft.tail.horizontal.skin.MOI.units;
aircraft.tail.vertical.skin.MOI.units;
aircraft.propulsion.motor.MOI.units;
aircraft.propulsion.ESC.MOI.units;
aircraft.propulsion.propeller.MOI.units;
aircraft.propulsion.battery.MOI.units];
unitsAgree = strcmp(units, "kg*in^2");
if all(unitsAgree)
I_matrices = {aircraft.fuselage.hull.MOI.value, ...
    aircraft.wing.skin.MOI.value, ...
aircraft.tail.horizontal.skin.MOI.value, ...
aircraft.tail.vertical.skin.MOI.value, ...
aircraft.propulsion.motor.MOI.value, ...
aircraft.propulsion.ESC.MOI.value, ...
aircraft.propulsion.propeller.MOI.value, ...
aircraft.propulsion.battery.MOI.value};
else
    error('Unit mismatch: calculation of unloaded aircraft MOI not possible.')
end

%I_matrices = {I_wing,I_fuselage,I_duck_1,I_duck_2};

aircraft.unloaded.MOI.units = 'kg*in^2';
aircraft.unloaded.MOI.type = "MOI";
aircraft.unloaded.MOI.description = "moments of inertia of unloaded aircraft";
aircraft.unloaded.mass.units = 'kg';
aircraft.unloaded.mass.type = "mass";
aircraft.unloaded.mass.description = "mass of unloaded aircraft";
aircraft.unloaded.XYZ_CG_2.units = 'in';
aircraft.unloaded.XYZ_CG_2.type = "length";
aircraft.unloaded.XYZ_CG_2.description = "vector of X, Y, Z coordinates of CG location for unloaded aircraft";
[aircraft.unloaded.MOI.value,aircraft.unloaded.mass.value,aircraft.unloaded.XYZ_CG_2.value] = InertiaCalc(cg_locations,masses,I_matrices);

I_tot = aircraft.unloaded.MOI.value;
% Flipping product moment of inertia signs
% (AVL Defines the I_ab values with a flipped sign)
I_xy = -1.*I_tot(1,2);
I_yz = -1.*I_tot(2,3);
I_xz = -1.*I_tot(1,3);

I_tot(1,2) = I_xy;
I_tot(2,1) = I_xy;

I_tot(2,3) = I_yz;
I_tot(3,2) = I_yz;

I_tot(1,3) = I_xz;
I_tot(3,1) = I_xz;

aircraft.unloaded.MOI.value = I_tot;

% Calculate net MOI for loaded aircraft
units = [aircraft.payload.passengers.XYZ_CG.units;
    aircraft.payload.cargo.XYZ_CG.units;
    aircraft.fuselage.hull.XYZ_CG.units;
aircraft.wing.skin.XYZ_CG.units;
aircraft.tail.horizontal.skin.XYZ_CG.units;
aircraft.tail.vertical.skin.XYZ_CG.units;
aircraft.propulsion.motor.XYZ_CG.units;
aircraft.propulsion.ESC.XYZ_CG.units;
aircraft.propulsion.propeller.XYZ_CG.units;
aircraft.propulsion.battery.XYZ_CG.units];
unitsAgree = strcmp(units, "in");
if all(unitsAgree)
cg_locations = {aircraft.payload.passengers.XYZ_CG.value', ...
    aircraft.payload.cargo.XYZ_CG.value', ...
    aircraft.fuselage.hull.XYZ_CG.value', ...
    aircraft.wing.skin.XYZ_CG.value', ...
aircraft.tail.horizontal.skin.XYZ_CG.value', ...
aircraft.tail.vertical.skin.XYZ_CG.value', ...
aircraft.propulsion.motor.XYZ_CG.value', ...
aircraft.propulsion.ESC.XYZ_CG.value', ...
aircraft.propulsion.propeller.XYZ_CG.value', ...
aircraft.propulsion.battery.XYZ_CG.value'};
else
    error('Unit mismatch: calculation of loaded aircraft MOI not possible.')
end

units = [aircraft.payload.passengers.mass.units;
    aircraft.payload.cargo.mass.units;
    aircraft.fuselage.hull.mass.units;
aircraft.wing.skin.mass.units;
aircraft.tail.horizontal.skin.mass.units;
aircraft.tail.vertical.skin.mass.units;
aircraft.propulsion.motor.mass.units;
aircraft.propulsion.ESC.mass.units;
aircraft.propulsion.propeller.mass.units;
aircraft.propulsion.battery.mass.units];
unitsAgree = strcmp(units, "kg");
if all(unitsAgree)
masses = {aircraft.payload.passengers.mass.value, ...
    aircraft.payload.cargo.mass.value, ...
    aircraft.fuselage.hull.mass.value, ...
    aircraft.wing.skin.mass.value, ...
aircraft.tail.horizontal.skin.mass.value, ...
aircraft.tail.vertical.skin.mass.value, ...
aircraft.propulsion.motor.mass.value, ...
aircraft.propulsion.ESC.mass.value, ...
aircraft.propulsion.propeller.mass.value, ...
aircraft.propulsion.battery.mass.value};
else
    error('Unit mismatch: calculation of loaded aircraft MOI not possible.')
end

units = [aircraft.payload.passengers.MOI.units;
    aircraft.payload.cargo.MOI.units;
    aircraft.fuselage.hull.MOI.units;
aircraft.wing.skin.MOI.units;
aircraft.tail.horizontal.skin.MOI.units;
aircraft.tail.vertical.skin.MOI.units;
aircraft.propulsion.motor.MOI.units;
aircraft.propulsion.ESC.MOI.units;
aircraft.propulsion.propeller.MOI.units;
aircraft.propulsion.battery.MOI.units];
unitsAgree = strcmp(units, "kg*in^2");
if all(unitsAgree)
I_matrices = {aircraft.payload.passengers.MOI.value, ...
    aircraft.payload.cargo.MOI.value, ...
    aircraft.fuselage.hull.MOI.value, ...
    aircraft.wing.skin.MOI.value, ...
aircraft.tail.horizontal.skin.MOI.value, ...
aircraft.tail.vertical.skin.MOI.value, ...
aircraft.propulsion.motor.MOI.value, ...
aircraft.propulsion.ESC.MOI.value, ...
aircraft.propulsion.propeller.MOI.value, ...
aircraft.propulsion.battery.MOI.value};
else
    error('Unit mismatch: calculation of loaded aircraft MOI not possible.')
end

%I_matrices = {I_wing,I_fuselage,I_duck_1,I_duck_2};

aircraft.loaded.MOI.units = 'kg*in^2';
aircraft.loaded.MOI.type = "MOI";
aircraft.loaded.MOI.description = "moments of inertia of loaded aircraft";
aircraft.loaded.mass.units = 'kg';
aircraft.loaded.mass.type = "mass";
aircraft.loaded.mass.description = "mass of loaded aircraft";
aircraft.loaded.XYZ_CG_2.units = 'in';
aircraft.loaded.XYZ_CG_2.type = "length";
aircraft.loaded.XYZ_CG_2.description = "vector of X, Y, Z coordinates of CG location for loaded aircraft";
[aircraft.loaded.MOI.value,aircraft.loaded.mass.value,aircraft.loaded.XYZ_CG_2.value] = InertiaCalc(cg_locations,masses,I_matrices);

I_tot = aircraft.loaded.MOI.value;
% Flipping product moment of inertia signs
% (AVL Defines the I_ab values with a flipped sign)
I_xy = -1.*I_tot(1,2);
I_yz = -1.*I_tot(2,3);
I_xz = -1.*I_tot(1,3);

I_tot(1,2) = I_xy;
I_tot(2,1) = I_xy;

I_tot(2,3) = I_yz;
I_tot(3,2) = I_yz;

I_tot(1,3) = I_xz;
I_tot(3,1) = I_xz;

aircraft.loaded.MOI.value = I_tot;

fprintf('Done generating mission ideas.\n')