function A = convMOI(V, UI, UO)
% convarea - physical moment of inertia unit conversion in the style of the Aerospace
% Toolbox: https://www.mathworks.com/help/aerotbx/unit-conversions-1.html
% Liam Trzebunia
% 12 October 2025

% supported unit conversions:
% kg*m^2 <-> kg*in^2
% lbm*in^2 -> kg*in^2

if strcmp(UI, UO)
    A = V;
end

if strcmp(UI, "kg*m^2") && strcmp(UO, "kg*in^2")
    A = V.*1550;
elseif strcmp(UI, "kg*in^2") && strcmp(UO, "kg*m^2")
    A = V./1550;
end

if strcmp(UI, "lbm*in^2") && strcmp(UO, "kg*in^2")
    A = V./2.205;
end

% if strcmp(UI, "m^2") && strcmp(UO, "cm^2")
%     A = V.*(100)^2;
% elseif strcmp(UI, "cm^2") && strcmp(UO, "m^2")
%     A = V./(100)^2;
% end

end

