function [aircraft, missions, numMissionConfigs] = update_aircraft_mission_options(aircraft, missions, numMissionConfigs, rejectedIndex, failure_message, structNames)
% At the time this function is called, certain parameters in the "aircraft"
% structure common to the MDAO framework will be nx1 vectors, where n is
% the number of heretofore valid missions being considered. This function
% uses logical arrays to update the aircraft struct to eliminate missions
% that have been labeled as rejected. 
% Liam Trzebunia
% 23 October 2025

if length(rejectedIndex) ~= numMissionConfigs
    error('Error: mismatched inputs')
end

acceptedIndex = ~rejectedIndex;
numMissionConfigs = sum(acceptedIndex);
structNames = [structNames; structNames];
eval(sprintf('%s.value = %s.value(acceptedIndex, :);\n', structNames));

data = readmatrix("6S Battery Data Condensed.xlsx");

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

