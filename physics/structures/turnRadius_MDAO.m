function [turnRadius,bankAngle] = turnRadius_MDAO(v_inf, maxG)
%turnRadius_MDAO calculates minimum turn radius using JD Anderson's eqn 6.9 in
%"Aircraft Performance and Design"
% Using maximum n yields minimum turn radius
g = 9.81;
numerator = v_inf^2;
denominator = g*sqrt(maxG^2 - 1);
turnRadius = numerator/denominator;
bankAngle = acosd(1/maxG);
end