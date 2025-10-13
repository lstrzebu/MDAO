%% Unit Checks

structNames = ["aircraft.fuselage.diameter";
    "aircraft.fuselage.length";
    "aircraft.wing.c";
    "aircraft.wing.b";
    "aircraft.tail.horizontal.d_tail";
    "aircraft.tail.horizontal.b";
    "aircraft.tail.horizontal.c";
    "aircraft.tail.vertical.b";
    "aircraft.tail.vertical.c"; 
    "aircraft.fuselage.protrusion"];

desiredUnits = ["in";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in"];

[aircraft, ~] = conv_aircraft_units(aircraft, 0, structNames, desiredUnits);

% inputs: 
% tailType = 'Conventional';
tailType = aircraft.tail.config.value;

if strcmp(tailType(1), 'C')
%% Fuselage

%D = 5; % diameter of fuselage
D = aircraft.fuselage.diameter.value;

% Define cylinder parameters
radius = D./2;
fuselage_length = aircraft.fuselage.length.value;

% Define the center of the cylinder
center_x = fuselage_length./2 - aircraft.fuselage.protrusion.value;
center_y = 0;
center_z = 0;

% Define the length boundaries
min_x = center_x - fuselage_length/2;
max_x = center_x + fuselage_length/2;

% Define the size of the 3D matrix
sz = 2.*max_x + 1; % The matrix will be sz x sz x sz. sz = 2*max_x + 1 is just large enough to fully accomodate the fuselage in most realistic cases
cylinder_matrix = zeros(sz+1, sz+1, sz+1);

% Create coordinate grids
[X, Y, Z] = meshgrid((-sz/2):(sz/2), (-sz/2):(sz/2), (-sz/2):(sz/2));

% Calculate the squared distance from the center axis for each point
dist_sq = (Y - center_y).^2 + (Z - center_z).^2;

% Create the logical mask for the cylinder
is_inside_cylinder = (dist_sq <= radius^2) & (X >= min_x) & (X <= max_x);

% Assign the mask to the matrix
cylinder_matrix(is_inside_cylinder) = 1;

% Visualize the cylinder
figure;
isosurface(X, Y, Z, cylinder_matrix, 0.5);
axis equal;
title(sprintf('%s'), aircraft.title.value);
xlabel('X (in)');
ylabel('Y (in)');
zlabel('Z (in)');
grid on;
view(3);

%% Wing
% --- Wing Dimensions ---
chord = aircraft.wing.c.value;    % Length of the wing (chord) in the x-direction
b = aircraft.wing.b.value;
width = b./2;    % Width of the wing (half-span) in the y-direction

% interactively obtain lifting surface thickness from airfoil name
eval(sprintf('thicknessMultiplier = 0.%s;', aircraft.wing.airfoil_name(8:9)))
thickness = thicknessMultiplier.*chord; % Thickness of the wing in the z-direction

assumptions(end+1).name = "Wing Attachment Z Coordinate";
assumptions(end+1).description = "Assume the bottom z coordinate of wing attachment is approximately 85% of the way toward the top half of the fuselage";
assumptions(end+1).rationale = "hand calcs based on SolidWorks fuselage model 'Fuselage with structure.SLDASM' located in folder Airframe-20251013T130855Z-1-001. Model was downloaded at 1215 EST 13 October 2025, at which point it had been last modified October 8. Hand calcs may be found in 'Hand Calcs for Wing Attachment Z Coordinate Assumption.txt.'";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

vertical_wing_center = 0.85*radius; % put the wing 4/5 of the way toward the top half of the fuselage


% --- Define Vertices (corners of the prism) ---
% A rectangular wing is a prism. There are 8 vertices in total.
% Vertex matrix: each row is a vertex, each column is a coordinate (x, y, z).
% Vertices are ordered for easier face definition.
% Vertex numbers:
%   1-----2     (Bottom face)
%  /|    /|
% 4-----3 |
% | 5---|-6    (Top face)
% |/    |/
% 8-----7
V = [
    0, -width, vertical_wing_center-thickness/2; % 1: Bottom left front
    chord, -width, vertical_wing_center-thickness/2; % 2: Bottom right front
    chord, width, vertical_wing_center-thickness/2;  % 3: Bottom right back
    0, width, vertical_wing_center-thickness/2;      % 4: Bottom left back
    0, -width, vertical_wing_center+thickness/2;      % 5: Top left front
    chord, -width, vertical_wing_center+thickness/2; % 6: Top right front
    chord, width, vertical_wing_center+thickness/2;  % 7: Top right back
    0, width, vertical_wing_center+thickness/2       % 8: Top left back
];

x_coords = V(:, 1);
y_coords = V(:, 2);
z_coords = V(:, 3);

% --- Define Faces ---
% The Faces matrix defines how the vertices are connected to form the faces.
% Each row of the Faces matrix specifies the vertices for one face.
F = [
    1, 2, 3, 4;   % Bottom face
    5, 6, 7, 8;   % Top face
    1, 2, 6, 5;   % Front face
    4, 3, 7, 8;   % Back face
    2, 3, 7, 6;   % Right face (wingtip)
    1, 4, 8, 5    % Left face (wing root)
];

% --- Plotting the wing ---
%figure; % Create a new figure window
patch('Vertices', V, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]); % Draw the wing

% --- Plot Customization ---
% xlabel('chord (x)');
% ylabel('Span (y)');
% zlabel('Thickness (z)');
%title('3D Rectangular Aircraft Wing');

% % Set the view angle and ensure proper scaling
% view(3); % Set to a 3D view
% axis equal; % Maintain aspect ratio
% grid on;

%% Tail
% --- Horizontal Tail Dimensions ---
d_tail = aircraft.tail.horizontal.d_tail.value; % distance from LE of wing (origin) to LE of tail
chord_HT = aircraft.tail.horizontal.c.value;    % Length of the HT (chord) in the x-direction
b_HT = aircraft.tail.horizontal.b.value;
width_HT = b_HT./2;    % Width of the HT (half-span) in the y-direction

% interactively obtain lifting surface thickness from airfoil name
eval(sprintf('thicknessMultiplier_HT = 0.%s;', aircraft.tail.horizontal.airfoil_name(8:9)))
thickness_HT = thicknessMultiplier_HT.*chord_HT; % Thickness of the HT in the z-direction

% assumptions.aircraft.wing_placement = "assume the z coordinate of wing attachment is approximately 4/5 of the way toward the top half of the fuselage";
horizontal_tail_z_center = radius; % put the HT 4/5 of the way toward the top half of the fuselage


% --- Define Vertices (corners of the prism) ---
% A rectangular wing is a prism. There are 8 vertices in total.
% Vertex matrix: each row is a vertex, each column is a coordinate (x, y, z).
% Vertices are ordered for easier face definition.
% Vertex numbers:
%   1-----2     (Bottom face)
%  /|    /|
% 4-----3 |
% | 5---|-6    (Top face)
% |/    |/
% 8-----7
V = [
    d_tail, -width_HT, horizontal_tail_z_center-thickness_HT/2; % 1: Bottom left front
    d_tail+chord_HT, -width_HT, horizontal_tail_z_center-thickness_HT/2; % 2: Bottom right front
    d_tail+chord_HT, width_HT, horizontal_tail_z_center-thickness_HT/2;  % 3: Bottom right back
    d_tail, width_HT, horizontal_tail_z_center-thickness_HT/2;      % 4: Bottom left back
    d_tail, -width_HT, horizontal_tail_z_center+thickness_HT/2;      % 5: Top left front
    d_tail + chord_HT, -width_HT, horizontal_tail_z_center+thickness_HT/2; % 6: Top right front
    d_tail + chord_HT, width_HT, horizontal_tail_z_center+thickness_HT/2;  % 7: Top right back
    d_tail, width_HT, horizontal_tail_z_center+thickness_HT/2       % 8: Top left back
];

x_coords = V(:, 1);
y_coords = V(:, 2);
z_coords = V(:, 3);

% --- Define Faces ---
% The Faces matrix defines how the vertices are connected to form the faces.
% Each row of the Faces matrix specifies the vertices for one face.
F = [
    1, 2, 3, 4;   % Bottom face
    5, 6, 7, 8;   % Top face
    1, 2, 6, 5;   % Front face
    4, 3, 7, 8;   % Back face
    2, 3, 7, 6;   % Right face (wingtip)
    1, 4, 8, 5    % Left face (wing root)
];

% --- Plotting the wing ---
%figure; % Create a new figure window
patch('Vertices', V, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]); % Draw the wing

% --- Plot Customization ---
% xlabel('chord (x)');
% ylabel('Span (y)');
% zlabel('Thickness (z)');
%title('3D Rectangular Aircraft Wing');

% % Set the view angle and ensure proper scaling
% view(3); % Set to a 3D view
% axis equal; % Maintain aspect ratio
% grid on;


% --- Vertical Tail Dimensions ---
chord_VT = aircraft.tail.vertical.c.value;    % Length of the VT (chord) in the x-direction
b_VT = aircraft.tail.vertical.b.value;
width_VT = b_VT./2;    % Width of the VT (half-span) in the z-direction

% interactively obtain lifting surface thickness from airfoil name
eval(sprintf('thicknessMultiplier_VT = 0.%s;', aircraft.tail.vertical.airfoil_name(8:9)))
thickness_VT = thicknessMultiplier_VT.*chord_VT; % Thickness of the VT in the y-direction

%assumptions.aircraft.wing_placement = "assume the z coordinate of wing attachment is approximately 4/5 of the way toward the top half of the fuselage";
vertical_tail_y_center = 0; % put the VT in the center of the aircraft
vertical_tail_z_bottom = radius;

% --- Define Vertices (corners of the prism) ---
% A rectangular wing is a prism. There are 8 vertices in total.
% Vertex matrix: each row is a vertex, each column is a coordinate (x, y, z).
% Vertices are ordered for easier face definition.
% Vertex numbers:
%   1-----2     (Bottom face)
%  /|    /|
% 4-----3 |
% | 5---|-6    (Top face)
% |/    |/
% 8-----7
V = [
    d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom; % 1: Bottom left front
    d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom; % 2: Bottom right front
    d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;  % 3: Bottom right back
    d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;      % 4: Bottom left back
    d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;      % 5: Top left front
    d_tail + chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom; % 6: Top right front
    d_tail + chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT;  % 7: Top right back
    d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT       % 8: Top left back
];

x_coords = V(:, 1);
y_coords = V(:, 2);
z_coords = V(:, 3);

% --- Define Faces ---
% The Faces matrix defines how the vertices are connected to form the faces.
% Each row of the Faces matrix specifies the vertices for one face.
F = [
    1, 2, 3, 4;   % Bottom face
    5, 6, 7, 8;   % Top face
    1, 2, 6, 5;   % Front face
    4, 3, 7, 8;   % Back face
    2, 3, 7, 6;   % Right face (wingtip)
    1, 4, 8, 5    % Left face (wing root)
];

% --- Plotting the wing ---
%figure; % Create a new figure window
patch('Vertices', V, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]); % Draw the wing

% --- Plot Customization ---
% xlabel('chord (x)');
% ylabel('Span (y)');
% zlabel('Thickness (z)');
%title('3D Rectangular Aircraft Wing');

% % Set the view angle and ensure proper scaling
% view(3); % Set to a 3D view
% axis equal; % Maintain aspect ratio
% grid on;

%% Fuselage Sanity Checks
% if fuselage is too far forward, then rear (max) X coord of fuselage will
% be less than front (min) X coord of HT (i.e. less than d_tail)
% 
% if fuselage is too far back, then front (min) X coord of fuselage will be
% behind the wing LE (i.e. greater than 0, as the origin is at the wing LE)
 
% rearTolerance = -chord/2;
if max_x < d_tail - chord_HT % ensure HT fully attached to fuselage
    error('Floating tail: fuselage too far forward.')
elseif aircraft.fuselage.protrusion.value < 0 % ensure wing fully attached to fuselage
    error('Floating wing: fuselage too far backward.')
end

else
    error('displayAircraft.m must be rewritten to support nonconventional (T or U shaped) tails.');
end