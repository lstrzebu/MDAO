function [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, aircraftIteration, missions, numMissionConfigs, rejectedIndex, failure_messages, structNames, batteryIndex, missionNumber)
% At the time this function is called, certain parameters in the "aircraft"
% structure common to the MDAO framework will be nx1 vectors, where n is
% the number of heretofore valid missions being considered. This function
% uses logical arrays to update the aircraft struct to eliminate missions
% that have been labeled as rejected.
% failure_messages can be a string or string array. If it is a string, the
% function will convert it to a string array of the desired length.
% Liam Trzebunia
% 23 October 2025

if length(rejectedIndex) ~= numMissionConfigs
    error('Error: mismatched inputs')
end

[r, c] = size(failure_messages);
if r == 1 && c == 1
    failure_messages = repmat(failure_messages, numMissionConfigs, 1);
end

% store rejected missions (for visibility/debugging later)
rejectedMissions = missions(rejectedIndex, :);
data = readcell("6S Battery Data Condensed.xlsx"); % project file takes care of the pathing
data = data(2:end, :); % discard header
batteryName = data{batteryIndex, 1};
rejected_print_missions = rejectedMissions(:, 1:4)';
rejected_print_missions = string(rejected_print_missions);
rejected_print_missions(5, :) = string(batteryName);
if ~isempty(rejectedMissions)
    fid = fopen('output\rejected_missions.csv', 'a');
    [r, ~] = size(rejectedMissions);
    for i = 1:r
        fprintf(fid, "\n%d, %s, %s, %s, %s, %s, %s, %s, %.4f", aircraftIteration, rejected_print_missions(:, i), sprintf('M%d: %s', missionNumber, failure_messages(i)), aircraft.propulsion.propeller.name{i}, aircraft.banner.AR.value(i));
    end
    fclose(fid);
end

% update all specified aircraft/mission parameter vectors
acceptedIndex = ~rejectedIndex;
numMissionConfigs = sum(acceptedIndex);
missions = missions(acceptedIndex, :);
structNames = [structNames; structNames];
eval(sprintf('%s.value = %s.value(acceptedIndex, :);\n', structNames));

% if length(structNames) == length(desiredUnits)
%     for i = 1:length(structNames)
%         structName = structNames(i);
%         desiredUnit = desiredUnits(i);
%         eval(sprintf('unitType = %s.type;', structName));
%         if ~strcmp(unitType, "non")
%             eval(sprintf('%s.value = conv%s(%s.value, %s.units, "%s");', structName, unitType, structName, structName, desiredUnit))
%             eval(sprintf('%s.units = "%s";', structName, desiredUnit))
%         end
%     end
% else
%     error('Function was called with mismatching input vectors. Input two vectors of the same length.')
% end

end

