% Check whether an aircraft-mission combination is physically feasible
% Created by Liam Trzebunia-Niebies on 7 October 2025

aircraftIteration = 1;
missionIteration = 1;

continue_mission_analysis.value = 1;
continue_mission_analysis.units = '';
continue_mission_analysis.type = "non";
continue_mission_analysis.description = "boolean used to skip suboptimal mission configurations if flaw is found";

%% Mission 2 Physics Analysis
if continue_mission_analysis.value
    physics_M2
else
    fprintf('Skipping Mission 2 analysis for rejected Aircraft-Mission Combination %d.%d\n', aircraftIteration, missionIteration)
end

%% Mission 3 Physics Analysis
if continue_mission_analysis.value
    physics_M3
else
    fprintf('Skipping Mission 3 analysis for rejected Aircraft-Mission Combination %d.%d\n', aircraftIteration, missionIteration)
end
