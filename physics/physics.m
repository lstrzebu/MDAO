% Check whether an aircraft-mission combination is physically feasible
% Created by Liam Trzebunia-Niebies on 7 October 2025

aircraftName = sprintf('Aircraft %d', aircraftIteration);

continue_mission_analysis.value = 1;
continue_mission_analysis.units = '';
continue_mission_analysis.type = "non";
continue_mission_analysis.description = "boolean used to skip suboptimal mission configurations if flaw is found";

%% Mission 2 Physics Analysis
if continue_mission_analysis.value
    missionNumber = 2;
    physics_M2
else
    fprintf('Skipping Mission 2 analysis for rejected Aircraft-Mission Combination %d.%d\n', aircraftIteration, missionIteration)
end

%% Mission 3 Physics Analysis
if continue_mission_analysis.value
    missionNumber = 3;
    physics_M3
else
    fprintf('Skipping Mission 3 analysis for rejected Aircraft-Mission Combination %d.%d\n', aircraftIteration, missionIteration)
end

%% Score Result if Physically Feasible
if continue_mission_analysis.value
    evalScore
end

%% Save Feasible Missions
data = readcell("6S Battery Data Condensed.xlsx"); % project file takes care of the pathing
data = data(2:end, :); % discard header
batteryName = data{batteryIndex, 1};
print_missions = missions(:, 1:4)';
print_missions = string(print_missions);
print_missions(5, :) = string(batteryName);
fid = fopen('output\accepted_missions.csv', 'a');
for i = 1:numMissionConfigs
    fprintf(fid, "\n%d, %s, %s, %s, %s, %s, %.3f", aircraftIteration, print_missions(:, i), total_score(i));
end
fclose(fid);