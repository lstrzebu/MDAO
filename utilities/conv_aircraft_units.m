function [aircraft] = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits)
% CONV_AIRCRAFT_UNITS converts the units of parameters in the "aircraft"
% structure common to the 2025-2026 NCSU AIAA DBF MDAO framework 
% Liam Trzebunia
% 12 October 2025

if length(structNames) == length(desiredUnits)
    for i = 1:length(structNames)
        structName = structNames(i); 
        desiredUnit = desiredUnits(i);
        eval(sprintf('unitType = %s.type;', structName));
        if ~strcmp(unitType, "non")
            eval(sprintf('%s.value = conv%s(%s.value, %s.units, "%s");', structName, unitType, structName, structName, desiredUnit))
            eval(sprintf('%s.units = "%s";', structName, desiredUnit))
        end
    end
else
    error('Function was called with mismatching input vectors. Input two vectors of the same length.')
end

end

