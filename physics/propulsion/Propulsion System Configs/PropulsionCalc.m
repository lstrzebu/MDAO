function [pUtilization, maxFlightTime, TW, RPM, FactorOfSafety, safetyCheck, RPM_exists] = PropulsionCalc(weight, drag, batteryCapacity, vTrim, maxVoltage, kV, resistance, currentNoLoad, maxCurrent, maxPower, propData)
%   PropulsionCalc is a function that takes in an aircraft's configuration
%   and previously computed performance characteristics and outputs six
%   key things: 1. Power Utilization (in Watts During Cruise), 2. Max
%   Flight Time (in seconds), 3. Thrust/Weight Ratio, 4. RPM, 5. The Factor
%   of Safety (of the Voltage, Current, and Power) and 6. A boolean that
%   checks whether the propulsion system has sufficient Factors of Safety
%
%   It will be assumed that all inputs are given in the following units:
%       - Weight in Newtons
%       - Drag in Newtons
%       - Battery Capacity in Watt-hours
%       - Trim Velocity in Meters / Second
%       - Max Voltage in Volts
%       - kV in RPM / Volt
%       - Resistance in Ohms
%       - No Current Load in Amps
%       - Max Current in Amps
%       - Max Power in Watts
%
%       - Utilized Prop Data includes:
%           - omega (RPM)
%           - v (mph)
%           - T (N)
%           - PWR (W)
%           - Q (N-m)

RPM_exists = true; % assume until proven otherwise that an RPM exists that matches the trim speed within the tolerance

% Defining Thrust Needed
thrust = drag; % N

% Defining Thrust/Weight Ratio
TW = thrust/weight;

% Initiating k and i
i = 1;
k = 0;

% Determine the Prop Efficiency and Power for Possible Config
try
    while k == 0
        if abs( (propData(i,1) * 0.44704) - vTrim)  <= (3*0.447) % Checks whether a certain RPM has the desired velocity within a 3 mph Tolerance
            i = i + 1;   % Go to the next row next time
            if propData(i,11) >= thrust % Checks if at that velocity enough thrust is produced
                pRotational = propData(i,9); % Grabbing Power Value
                RPM = (propData(i,9) / (propData(i,10)) * (30/pi)); % Calculating RPM from Power and Torque
                k = 1; % Breaking the loop
            end
        else
            i = i + 1; % If not, check the next row
        end
    end
catch % if no RPM can be found that matches the velocity within the tolerance
    RPM_exists = false;
end

if RPM_exists == true
    % Determining Voltage
    voltage = RPM / kV;

    % "Guess" Current Values to Calc. Approximate Motor Efficiency
    currentApprox = 40; % Amps
    pInApprox = voltage * currentApprox; % Watts

    % Calculating Motor Losses (Copper + Iron Losses)
    copperLoss = resistance * (currentApprox^2);
    ironLoss = voltage * currentNoLoad;
    pOutApprox = pRotational - (copperLoss + ironLoss);

    % Calculating Motor Efficiency
    motorEfficiency = pOutApprox / pInApprox;

    % Determining True Power Utilization using Approximate motorEfficiency
    pUtilization = pRotational / motorEfficiency;

    % Determining Current
    current = pUtilization/voltage;

    % Compute Flight Time
    maxFlightTime = (batteryCapacity / pUtilization) * 3600;

    % Imposes an Absolute Maximum Current of 100
    if maxCurrent > 100
        maxCurrent = 100;
    end

    % Proceeded with Safety Checks
    voltageFS = maxVoltage / voltage;
    currentFS = maxCurrent / current;
    powerFS = maxPower / pUtilization;

    FactorOfSafety = [voltageFS, currentFS, powerFS];

    % Set Safety Boolean Based on Factors of Safety
    if currentFS >= (1/0.85) && voltageFS >= 1 && powerFS >= (1/0.85)
        safetyCheck = true;
    else
        safetyCheck = false;
    end

else % no RPM could be found, therefore the mission cannot be flown with the present motor configuration
    pUtilization = NaN;
    maxFlightTime = NaN;
    TW = NaN;
    RPM = NaN;
    FactorOfSafety = NaN;
    safetyCheck = true; % cannot set safetyCheck to NaN, it will cause an error in the logical comparison later 
end

end

