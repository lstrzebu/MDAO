function A = convrecang(V, UI, UO)
% convrecang - physical reciprocal angle unit conversion in the style of
% the Aerospace Toolbox: 
% https://www.mathworks.com/help/aerotbx/unit-conversions-1.html
% Liam Trzebunia
% 12 October 2025

% supported units: 1/deg, 1/rad

if strcmp(UI, UO)
    A = V;
end

if (strcmp(UI, "1/deg") && strcmp(UO, "1/rad")) || (strcmp(UI, "/deg") && strcmp(UO, "/rad"))  
    A = V.*(180/pi);
elseif (strcmp(UI, "1/rad") && strcmp(UO, "1/deg")) || (strcmp(UI, "/rad") && strcmp(UO, "/deg")) 
    A = V.*(pi/180);
end

