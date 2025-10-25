function aircraft = vectorize_aircraft_params(aircraft, numMissionConfigs, structNames)
% Vectorizes aircraft parameters by representing a scalar input as a column
% vector output whose rows all equal the scalar input
%
% Designed to work with the aircraft structure common to the DBF MDAO
% framework
%
% Liam Trzebunia
% 12 October 2025

structNames = [structNames; structNames];

eval(sprintf('%s.value = repmat(%s.value, numMissionConfigs, 1);\n', structNames));

% eval(sprintf(['[~,c] = size(%s.value);' ...
%     'vec = zeros([numMissionConfigs, c]); ' ...
%     'vec(:) = %s.value; ' ...
%     '%s.value = vec;\n'], structNames, structNames));

end

