function [pUtilizationVals, maxFlightTimeVals, TW, RPMvals, FactorOfSafetyVals, rejectedIndex, failure_messages] = PropulsionCalc(weight, drag, batteryCapacity, vTrim, maxVoltage, kV, resistance, currentNoLoad, maxCurrent, maxPower, propData, numMissionConfigs)
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

% Defining Thrust Needed
thrust = drag; % N

% Defining Thrust/Weight Ratio
TW = thrust./weight;

% Initiating k and i
i = 1;
k = 0;

failure_messages = strings([numMissionConfigs, 1]);
pUtilizationVals = zeros([numMissionConfigs, 1]);
maxFlightTimeVals = pUtilizationVals;
RPMvals = pUtilizationVals;
FactorOfSafetyVals = zeros([numMissionConfigs, 3]);

% RPMvals = zeros([numMissionConfigs, 1]);
% pRotationalVals = zeros([numMissionConfigs, 1]);

for j = 1:numMissionConfigs
    %vTrim = vTrim(j);

% Determine the Prop Efficiency and Power for Possible Config
try
    while k == 0
        if abs( (propData(i,1,j) * 0.44704) - vTrim(j))  <= (3*0.447) % Checks whether a certain RPM has the desired velocity within a 3 mph Tolerance
            i = i + 1;   % Go to the next row next time
            if propData(i,11,j) >= thrust % Checks if at that velocity enough thrust is produced
                pRotational = propData(i,9,j); % Grabbing Power Value
                RPM = (propData(i,9,j) / (propData(i,10,j)) * (30/pi)); % Calculating RPM from Power and Torque
                k = 1; % Breaking the loop
            end
        else
            i = i + 1; % If not, check the next row
        end
    end
catch % if no RPM can be found that matches the velocity within the tolerance
    failure_messages(j) = "no RPM exists";
    % RPM_exists = false;
end

if ~strcmp(failure_messages(j), "no RPM exists")
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

    FactorOfSafetyVals(j,:) = [voltageFS, currentFS, powerFS];

    % Set Safety Boolean Based on Factors of Safety
    if ~(currentFS >= (1/0.85) && voltageFS >= 1 && powerFS >= (1/0.85))
        if ~(currentFS >= (1/0.85))
        failure_messages(j) = sprintf("insufficient electircal current factor of safety: max current = %.4f but required current = %.4f", maxCurrent, current);
        elseif ~(voltageFS >= 1)
        failure_messages(j) = sprintf("insufficient electrical voltage factor of safety: max voltage = %.4f but required voltage = %.4f", maxVoltage, voltage);
        elseif ~(powerFS >= (1/0.85))
        failure_messages(j) = sprintf("insufficient electrical power factor of safety: max power = %.4f but required power = %.4f", maxPower, power);
        end
    end

    if voltage < 0 || current < 0 || pUtilization < 0
        failure_messages(j) = "negative current, power, or voltage... failed assumption for current.";
    end

    pUtilizationVals(j) = pUtilization;
    maxFlightTimeVals(j) = maxFlightTime;
    RPMvals(j) = RPM;
end

end

rejectedIndex = failure_messages ~= "";

end

