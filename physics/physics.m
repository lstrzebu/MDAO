% Check whether an aircraft-mission combination is physically feasible
% Created by Liam Trzebunia-Niebies on 7 October 2025

aircraftName = sprintf('Aircraft %d', aircraftIteration);

continue_mission_analysis.value = 1;
continue_mission_analysis.units = '';
continue_mission_analysis.type = "non";
continue_mission_analysis.description = "boolean used to skip suboptimal mission configurations if flaw is found";

%% Mission 2 Physics Analysis
missionNumber = 2;
if continue_mission_analysis.value
    physics_M2
else
    fprintf('Skipping Mission %d analysis for rejected design "%s."\n', missionNumber, aircraftName)
end

%% Mission 3 Physics Analysis
missionNumber = 3;
if continue_mission_analysis.value
    physics_M3
else
    fprintf('Skipping Mission %d analysis for rejected design "%s."\n', missionNumber, aircraftName)
end

%% Score Result if Physically Feasible
if continue_mission_analysis.value
    evalScore

%% Save Feasible Missions
data = readcell("6S Battery Data Condensed.xlsx"); % project file takes care of the pathing
data = data(2:end, :); % discard header
batteryName = data{batteryIndex, 1};
print_missions = missions(:, 1:4)';
print_missions = string(print_missions);
print_missions(5, :) = string(batteryName);
fid = fopen('output\accepted_missions.csv', 'a');
for i = 1:numMissionConfigs
    fprintf(fid, "\n%d, %s, %s, %s, %s, %s, %.3f, %s", aircraftIteration, print_missions(:, i), total_score(i), aircraft.propulsion.propeller.name{i});
end
fclose(fid);

end