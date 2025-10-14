function A = convvol(V, UI, UO)
% convarea - physical volume unit conversion in the style of the Aerospace
% Toolbox: https://www.mathworks.com/help/aerotbx/unit-conversions-1.html
% Liam Trzebunia
% 14 October 2025

% supported units conversions: 
% m^3 <-> ft^3
% in^3 <-> cm^3


if strcmp(UI, UO)
    A = V;
end

if strcmp(UI, "m^3") && strcmp(UO, "ft^3")
    A = V.*(3.28084)^3;
elseif strcmp(UI, "ft^3") && strcmp(UO, "m^3")
    A = V./(3.28084)^3;
end

if strcmp(UI, "in^3") && strcmp(UO, "cm^3")
    A = V.*(2.54)^3;
elseif strcmp(UI, "cm^3") && strcmp(UO, "in^3")
    A = V./(2.54)^3;
end

