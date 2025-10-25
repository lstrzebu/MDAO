% select the best mission for this particular aircraft
% Created 7 October 2025 by Liam Trzebunia

if numMissionConfigs == 1
    bestMission = missions;
elseif numMissionConfigs > 1
    [topScore, indx] = max(total_score);
    bestMission = missions(indx,:);
end