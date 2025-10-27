function A = convarea(V, UI, UO)
% convarea - physical area unit conversion in the style of the Aerospace
% Toolbox: https://www.mathworks.com/help/aerotbx/unit-conversions-1.html
% Liam Trzebunia
% 12 October 2025

% supported unit conversions:
% m^2 <-> ft^2
% m^2 <-> cm^2
% in^2 - m^2

if strcmp(UI, UO)
    A = V;
end

if strcmp(UI, "m^2") && strcmp(UO, "ft^2")
    A = V.*(3.28084)^2;
elseif strcmp(UI, "ft^2") && strcmp(UO, "m^2")
    A = V./(3.28084)^2;
end

if strcmp(UI, "m^2") && strcmp(UO, "cm^2")
    A = V.*(100)^2;
elseif strcmp(UI, "cm^2") && strcmp(UO, "m^2")
    A = V./(100)^2;
end

if strcmp(UI, "in^2") && strcmp(UO, "m^2")
    A = V./1550;
end

end

