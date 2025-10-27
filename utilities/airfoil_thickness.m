function [max_thickness, normalized_thickness] = airfoil_thickness(filename)
% AIRFOIL_THICKNESS Reads an airfoil .dat file and computes its maximum thickness.
% Input: filename - Path to the airfoil .dat file
% Outputs: max_thickness - Maximum thickness of the airfoil
%          normalized_thickness - Maximum thickness divided by chord length
% Assumptions: Chord length is 1 (standard for .dat files); adjust if needed.
% Grokked on 26 October 2025 by Liam Trzebunia

% fprintf('Calculating airfoil thickness from .dat file... \n');

% Read the .dat file
data = load(filename); % Assumes .dat file contains [x, y] coordinates
x = data(:, 1);
y = data(:, 2);

% Determine if file is in Selig or Lednicer format
% Selig: Single loop from leading edge to trailing edge
% Lednicer: Upper surface followed by lower surface
n_points = length(x);
mid_idx = find(x(2:end) > x(1:end-1), 1, 'first') + 1; % Find where x starts increasing

if isempty(mid_idx) || mid_idx >= n_points
    % Likely Selig format: Single loop
    [x_le, le_idx] = min(x); % Leading edge (smallest x)
    x_upper = x(1:le_idx);
    y_upper = y(1:le_idx);
    x_lower = x(le_idx:end);
    y_lower = y(le_idx:end);
else
    % Lednicer format: Upper and lower surfaces separated
    x_upper = x(1:mid_idx-1);
    y_upper = y(1:mid_idx-1);
    x_lower = x(mid_idx:end);
    y_lower = y(mid_idx:end);
end

% Ensure upper and lower surfaces are ordered from leading to trailing edge
if x_upper(1) > x_upper(end)
    x_upper = flip(x_upper);
    y_upper = flip(y_upper);
end
if x_lower(1) > x_lower(end)
    x_lower = flip(x_lower);
    y_lower = flip(y_lower);
end

% Interpolate to align x-coordinates
x_common = linspace(max(min(x_upper), min(x_lower)), min(max(x_upper), max(x_lower)), 1000);
y_upper_interp = interp1(x_upper, y_upper, x_common, 'pchip');
y_lower_interp = interp1(x_lower, y_lower, x_common, 'pchip');

% Calculate thickness at each x-location
thickness = y_upper_interp - y_lower_interp;

% Find maximum thickness
max_thickness = max(thickness);

% Normalize by chord length (assumed 1 unless specified in file)
% If chord length is not 1, modify this value based on file or user input
chord_length = 1;
normalized_thickness = max_thickness / chord_length;

% % Display results
% fprintf('Maximum Thickness: %.4f\n', max_thickness);
% fprintf('Normalized Thickness (t/c): %.4f\n', normalized_thickness);

% % Optional: Plot airfoil and thickness
% figure;
% plot(x_common, y_upper_interp, 'b-', 'DisplayName', 'Upper Surface');
% hold on;
% plot(x_common, y_lower_interp, 'r-', 'DisplayName', 'Lower Surface');
% plot(x_common, thickness, 'k--', 'DisplayName', 'Thickness');
% xlabel('x/c');
% ylabel('y/c or Thickness');
% title('Airfoil and Thickness Distribution');
% legend;
% grid on;

% fprintf('Completed airfoil thickness calculation.\n')
end

