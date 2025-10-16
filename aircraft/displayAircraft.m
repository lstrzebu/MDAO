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
    "aircraft.fuselage.protrusion";
    "aircraft.fuselage.hull.thickness";
    "aircraft.propulsion.motor.length";
    "aircraft.propulsion.motor.diameter_outer"];

desiredUnits = ["in";
    "in";
    "in";
    "in";
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
radius_outer = D./2;
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
is_inside_cylinder = (dist_sq <= radius_outer^2) & (X >= min_x) & (X <= max_x);

% Assign the mask to the matrix
cylinder_matrix(is_inside_cylinder) = 1;

% Visualize the cylinder
figure;
hold on;
isosurface(X, Y, Z, cylinder_matrix, 0.5);
% alpha(gca, 0.5); % transparency to see CG later
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
thickness_wing = thicknessMultiplier.*chord; % Thickness of the wing in the z-direction

assumptions(end+1).name = "Wing Attachment Z Coordinate";
assumptions(end+1).description = "Assume the bottom z coordinate of wing attachment is approximately 85% of the way toward the top half of the fuselage";
assumptions(end+1).rationale = "hand calcs based on SolidWorks fuselage model 'Fuselage with structure.SLDASM' located in folder Airframe-20251013T130855Z-1-001. Model was downloaded at 1215 EST 13 October 2025, at which point it had been last modified October 8. Hand calcs may be found in 'Hand Calcs for Wing Attachment Z Coordinate Assumption.txt.'";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

vertical_wing_center = 0.85*radius_outer + thickness_wing/2; % put the wing 4/5 of the way toward the top half of the fuselage


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
    0, -width, vertical_wing_center-thickness_wing/2; % 1: Bottom left front
    chord, -width, vertical_wing_center-thickness_wing/2; % 2: Bottom right front
    chord, width, vertical_wing_center-thickness_wing/2;  % 3: Bottom right back
    0, width, vertical_wing_center-thickness_wing/2;      % 4: Bottom left back
    0, -width, vertical_wing_center+thickness_wing/2;      % 5: Top left front
    chord, -width, vertical_wing_center+thickness_wing/2; % 6: Top right front
    chord, width, vertical_wing_center+thickness_wing/2;  % 7: Top right back
    0, width, vertical_wing_center+thickness_wing/2       % 8: Top left back
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
horizontal_tail_z_center = radius_outer; % put the HT 4/5 of the way toward the top half of the fuselage


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
vertical_tail_z_bottom = radius_outer;

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

%% CG Calculation

assumptions(end+1).name = "Foam Density";
assumptions(end+1).description = "Assume a foam density of approximately zero. Will want to weigh in lab and replace this assumption in future";
assumptions(end+1).rationale = "No access to foam to weigh at the moment and no knowledge of what type of foam we're using";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.skin.density.value = mean([1.15 2.25]);
aircraft.wing.skin.density.units = 'g/cm^3';
aircraft.wing.skin.density.type = "density";
aircraft.wing.skin.density.description = "Mass density of composite used for wing skin";

assumptions(end+1).name = "Wing Carbon Fiber Density";
assumptions(end+1).description = sprintf("Assume an average carbon fiber density over the wing of approximately %.2f %s", aircraft.wing.skin.density.value, aircraft.wing.skin.density.units);
assumptions(end+1).rationale = "No access to carbon fiber to weigh at the moment and no knowledge of what type of carbon fiber or plexiglass we're using. Averaging limits found online here: https://goodwinds.com/composite-resources/carbon-vs-fiberglass-2/#:~:text=Density,in%20tight%20tolerance%20composites%20machining. Will want to change this later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.horizontal.skin.density.value = aircraft.wing.skin.density.value;
aircraft.tail.horizontal.skin.density.units = aircraft.wing.skin.density.units;
aircraft.tail.horizontal.skin.density.type = "density";
aircraft.tail.horizontal.skin.density.description = "Mass density of composite used for horizontal tail skin";

assumptions(end+1).name = "Horizontal Tail Carbon Fiber Density";
assumptions(end+1).description = sprintf("Assume an average carbon fiber density over the horizontal tail of approximately %.2f %s", aircraft.wing.skin.density.value, aircraft.wing.skin.density.units);
assumptions(end+1).rationale = "No access to carbon fiber to weigh at the moment and no knowledge of what type of carbon fiber or plexiglass we're using. Averaging limits found online here: https://goodwinds.com/composite-resources/carbon-vs-fiberglass-2/#:~:text=Density,in%20tight%20tolerance%20composites%20machining. Will want to change this later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.vertical.skin.density.value = aircraft.wing.skin.density.value;
aircraft.tail.vertical.skin.density.units = aircraft.wing.skin.density.units;
aircraft.tail.vertical.skin.density.type = "density";
aircraft.tail.vertical.skin.density.description = "Mass density of composite used for vertical tail skin";

assumptions(end+1).name = "Vertical Tail Carbon Fiber Density";
assumptions(end+1).description = sprintf("Assume an average carbon fiber density over the vertical tail of approximately %.2f %s", aircraft.wing.skin.density.value, aircraft.wing.skin.density.units);
assumptions(end+1).rationale = "No access to carbon fiber to weigh at the moment and no knowledge of what type of carbon fiber or plexiglass we're using. Averaging limits found online here: https://goodwinds.com/composite-resources/carbon-vs-fiberglass-2/#:~:text=Density,in%20tight%20tolerance%20composites%20machining. Will want to change this later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.skin.thickness.value = 0.2/1000;
aircraft.wing.skin.thickness.units = 'm';
aircraft.wing.skin.thickness.type = "length";
aircraft.wing.skin.thickness.description = "Thickness of composite wing skin (i.e. the thickness of a single layer of skin, which wraps around both sides of lifting surface)";

assumptions(end+1).name = "Composite Wing Skin Thickness";
assumptions(end+1).description = sprintf("Assume a wing skin thickness of approximately %.2f %s", aircraft.wing.skin.thickness.value, aircraft.wing.skin.thickness.units);
assumptions(end+1).rationale = "Unknown";
assumptions(end+1).responsible_engineer = "Sam Prochnau";

aircraft.tail.horizontal.skin.thickness.value = aircraft.wing.skin.thickness.value;
aircraft.tail.horizontal.skin.thickness.units = aircraft.wing.skin.thickness.units;
aircraft.tail.horizontal.skin.thickness.type = "length";
aircraft.tail.horizontal.skin.thickness.description = "Thickness of composite horizontal tail skin (i.e. the thickness of a single layer of skin, which wraps around both sides of lifting surface)";

assumptions(end+1).name = "Composite Horizontal Tail Skin Thickness";
assumptions(end+1).description = "Assume wing and horizontal tail have similar composite skin thicknesses";
assumptions(end+1).rationale = "Ease of manufacturing, simplicity of calculation in MDAO - can be refined later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.vertical.skin.thickness.value = aircraft.wing.skin.thickness.value;
aircraft.tail.vertical.skin.thickness.units = aircraft.wing.skin.thickness.units;
aircraft.tail.vertical.skin.thickness.type = "length";
aircraft.tail.vertical.skin.thickness.description = "Thickness of composite vertical tail skin (i.e. the thickness of a single layer of skin, which wraps around both sides of lifting surface)";

assumptions(end+1).name = "Composite vertical Tail Skin Thickness";
assumptions(end+1).description = "Assume wing and vertical tail have similar composite skin thicknesses";
assumptions(end+1).rationale = "Ease of manufacturing, simplicity of calculation in MDAO - can be refined later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.spar.outer_diameter.value = 0.75*0.0254; 
aircraft.wing.spar.outer_diameter.units = 'm';
aircraft.wing.spar.outer_diameter.type = "length";
aircraft.wing.spar.outer_diameter.description = "outer diameter of wing spar";

aircraft.wing.spar.outer_radius.value = aircraft.wing.spar.outer_diameter.value./2;
aircraft.wing.spar.outer_radius.units = aircraft.wing.spar.outer_diameter.units;
aircraft.wing.spar.outer_radius.type = "length";
aircraft.wing.spar.outer_radius.description = "outer radius of wing spar";

aircraft.wing.spar.thickness.value = (1/16)*0.0254;
aircraft.wing.spar.thickness.units = 'm';
aircraft.wing.spar.thickness.type = "length";
aircraft.wing.spar.thickness.description = "Difference between inner and outer radius of wing spar";

aircraft.wing.spar.inner_radius.value = aircraft.wing.spar.outer_radius.value - aircraft.wing.spar.thickness.value;
aircraft.wing.spar.inner_radius.units = 'm';
aircraft.wing.spar.inner_radius.type = "length";
aircraft.wing.spar.inner_radius.description = "Inner radius of wing spar";

assumptions(end+1).name = "Number of Wing Spars";
assumptions(end+1).description = "Assume a single wing spar";
assumptions(end+1).rationale = "Temporary assumption, change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

assumptions(end+1).name = "Wing Spar X Coordinate";
assumptions(end+1).description = "Assume wing spar is located at 50% of the chord length";
assumptions(end+1).rationale = "Temporary assumption, change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

assumptions(end+1).name = "Wing Spar Z Coordinate";
assumptions(end+1).description = "Assume wing spar is located at 50% of the wing thickness";
assumptions(end+1).rationale = "Temporary assumption, change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.spar.XYZ_CG.value = [0.5.*aircraft.wing.c.value, 0, vertical_wing_center];
aircraft.wing.spar.XYZ_CG.units = aircraft.wing.c.units; % vertical_wing_center also has units of inches, like the wing chord (if units check has been done correctly)
aircraft.wing.spar.XYZ_CG.type = "length";
aircraft.wing.spar.XYZ_CG.description = "vector of X, Y, Z coordinates for wing spar center of gravity";

% assume spar weight
aircraft.wing.spar.weight.value = 0.5;
aircraft.wing.spar.weight.units = 'lbf';
aircraft.wing.spar.weight.type = "force";
aircraft.wing.spar.weight.description = "weight of wing spar";

assumptions(end+1).name = "Wing Spar Weight";
assumptions(end+1).description = sprintf("Assume wing spar weighs %.2f %s", aircraft.wing.spar.weight.value, aircraft.wing.spar.weight.units);
assumptions(end+1).rationale = "Temporary assumption, change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.fuselage.hull.XYZ_CG.value = [center_x, center_y, center_z];
aircraft.fuselage.hull.XYZ_CG.units = 'in';
aircraft.fuselage.hull.XYZ_CG.type = "length";
aircraft.fuselage.hull.XYZ_CG.description = "vector of X, Y, Z coordinates of fuselage CG";

assumptions(end+1).name = "Fuselage Weight";
assumptions(end+1).description = "Neglect structural bulkheads; only consider fuselage as a cylinder with a given length, diameter, and thickness.";
assumptions(end+1).rationale = "Simplicity of calculation. Change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

assumptions(end+1).name = "Fuselage Material";
assumptions(end+1).description = "Assume fuselage made of composite material";
assumptions(end+1).rationale = "Lightweight yet durable";
assumptions(end+1).responsible_engineer = "Eric Stout";

assumptions(end+1).name = "Fuselage Material Again";
assumptions(end+1).description = "Assume fuselage made of same composite material as wing";
assumptions(end+1).rationale = "Simplicity of calculations for first pass";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.fuselage.hull.density.value = aircraft.wing.skin.density.value;
aircraft.fuselage.hull.density.units = aircraft.wing.skin.density.units;
aircraft.fuselage.hull.density.type = "density";
aircraft.fuselage.hull.density.description = "density of composite material used in fuselage layup";

radius_inner = radius_outer - aircraft.fuselage.hull.thickness.value; % inner radius of fuselage in inches

aircraft.fuselage.hull.cross_sectional_area.value = pi*(radius_outer^2 - radius_inner^2);
aircraft.fuselage.hull.cross_sectional_area.units = 'in^2';
aircraft.fuselage.hull.cross_sectional_area.type = "area";
aircraft.fuselage.hull.cross_sectional_area.description = "cross sectional area of cylindrical fuselage occupied by hull material";

aircraft.fuselage.hull.solid_volume.value = aircraft.fuselage.hull.cross_sectional_area.value.*fuselage_length;
aircraft.fuselage.hull.solid_volume.units = 'in^3';
aircraft.fuselage.hull.solid_volume.type = "vol"; % volume unit type
aircraft.fuselage.hull.solid_volume.description = "volume of space occupied by fuselage hull material";

% density in g/cm^3 and volume in in^3

if strcmp(string(aircraft.fuselage.hull.density.units), "g/cm^3") && strcmp(string(aircraft.fuselage.hull.solid_volume.units), "in^3")
    [aircraft, ~] = conv_aircraft_units(aircraft, 0, "aircraft.fuselage.hull.solid_volume", "cm^3");
    if strcmp(string(aircraft.fuselage.hull.solid_volume.units), "cm^3")
        aircraft.fuselage.hull.mass.value = aircraft.fuselage.hull.density.value.*aircraft.fuselage.hull.solid_volume.value;
        aircraft.fuselage.hull.mass.units = 'g';
        aircraft.fuselage.hull.mass.type = "mass";
        aircraft.fuselage.hull.mass.description = "mass of fuselage hull (not including structural bulkheads)";
    else
        error('Unit mismatch: computation of fuselage mass not possible.')
    end
    else
    error('Unit mismatch: computation of fuselage mass is not possible.')
end

if strcmp(string(aircraft.fuselage.hull.mass.units), "g")
    aircraft.fuselage.hull.mass.value = aircraft.fuselage.hull.mass.value * 10^(-3);
    aircraft.fuselage.hull.mass.units = 'kg';
else
    error('Unit mismatch: computation of fuselage weight is not possible.')
end

% if g is in imperial units, convert to metric
if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

if strcmp(string(aircraft.fuselage.hull.mass.units), "kg") && strcmp(string(constants.g.units), "m/s^2")
    aircraft.fuselage.hull.weight.value = aircraft.fuselage.hull.mass.value.*constants.g.value;
    aircraft.fuselage.hull.weight.units = 'N';
    aircraft.fuselage.hull.weight.type = "force";
    aircraft.fuselage.hull.weight.description = "weight of fuselage hull (not including structural bulkheads)";
else
    error('Unit mismatch: computation of fuselage weight is not possible.')
end

% wing skin weight and CG 

aircraft.wing.skin.total_thickness.value = aircraft.wing.skin.thickness.value.*2;
aircraft.wing.skin.total_thickness.units = aircraft.wing.skin.thickness.units;
aircraft.wing.skin.total_thickness.type = "length";
aircraft.wing.skin.total_thickness.description = "total thickness of both top and bottom surfaces of wing skin";

if strcmp(string(aircraft.wing.skin.thickness.units), "m")
    aircraft.wing.skin.thickness.value = aircraft.wing.skin.thickness.value.*10^2;
    aircraft.wing.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of wing mass per unit area is not possible.')
end

if strcmp(string(aircraft.wing.skin.density.units), "g/cm^3") && strcmp(string(aircraft.wing.skin.thickness.units), "cm")
aircraft.wing.skin.mass_per_unit_area.value = aircraft.wing.skin.density.value.*aircraft.wing.skin.thickness.value;
aircraft.wing.skin.mass_per_unit_area.units = 'g/cm^2';
aircraft.wing.skin.mass_per_unit_area.description = "mass per unit area of the wing skin";
else
    error('Unit mismatch: computation of wing mass is not possible.');
end

% convert planform area to cm^2
if strcmp(string(aircraft.wing.S.units), "ft^2")
    % convert ft^2 to m^2
    [aircraft, ~] = conv_aircraft_units(aircraft, 0, "aircraft.wing.S", "m^2");

    % convert m^2 to cm^2
    aircraft.wing.S.value = 10000.*aircraft.wing.S.value;
    aircraft.wing.S.units = 'cm^2';
else
    error('Unit mismatch: computation of wing skin mass is not possible.')
end

if strcmp(string(aircraft.wing.S.units), "cm^2")
aircraft.wing.skin.mass.value = aircraft.wing.skin.mass_per_unit_area.value.*aircraft.wing.S.value;
aircraft.wing.skin.mass.units = 'g';
aircraft.wing.skin.mass.type = "mass";
aircraft.wing.skin.mass.description = "mass of composite wing skin (not including spar, foam, or anything else)";

% convert to kg
aircraft.wing.skin.mass.value = aircraft.wing.skin.mass.value.*10^(-3);
aircraft.wing.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of wing skin mass is not possible.')
end

% if g is in imperial units, convert to metric
if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.wing.skin.weight.value = aircraft.wing.skin.mass.value.*constants.g.value;
aircraft.wing.skin.weight.units = 'N';
aircraft.wing.skin.weight.type = "force";
aircraft.wing.skin.weight.description = "weight of composite wing skin (not including spar, foam, or anything else)";

aircraft.wing.skin.XYZ_CG.value = [chord/2, 0, vertical_wing_center+thickness_wing/2];
aircraft.wing.skin.XYZ_CG.units = 'in';
aircraft.wing.skin.XYZ_CG.type = "length";
aircraft.wing.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for wing skin CG";

% vertical tail skin weight and CG

aircraft.tail.horizontal.skin.total_thickness.value = aircraft.tail.horizontal.skin.thickness.value.*2;
aircraft.tail.horizontal.skin.total_thickness.units = aircraft.tail.horizontal.skin.thickness.units;
aircraft.tail.horizontal.skin.total_thickness.type = "length";
aircraft.tail.horizontal.skin.total_thickness.description = "total thickness of both top and bottom surfaces of horizontal tail skin";

if strcmp(string(aircraft.tail.horizontal.skin.thickness.units), "m")
    aircraft.tail.horizontal.skin.thickness.value = aircraft.tail.horizontal.skin.thickness.value.*10^2;
    aircraft.tail.horizontal.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of horizontal tail mass per unit area is not possible.')
end

if strcmp(string(aircraft.tail.horizontal.skin.density.units), "g/cm^3") && strcmp(string(aircraft.tail.horizontal.skin.thickness.units), "cm")
aircraft.tail.horizontal.skin.mass_per_unit_area.value = aircraft.tail.horizontal.skin.density.value.*aircraft.tail.horizontal.skin.thickness.value;
aircraft.tail.horizontal.skin.mass_per_unit_area.units = 'g/cm^2';
aircraft.tail.horizontal.skin.mass_per_unit_area.description = "mass per unit area of the horizontal tail skin";
else
    error('Unit mismatch: computation of tail.horizontal mass is not possible.');
end

% convert planform area to cm^2
if strcmp(string(aircraft.tail.horizontal.S.units), "ft^2")
    % convert ft^2 to m^2
    [aircraft, ~] = conv_aircraft_units(aircraft, 0, "aircraft.tail.horizontal.S", "m^2");

    % convert m^2 to cm^2
    aircraft.tail.horizontal.S.value = 10000.*aircraft.tail.horizontal.S.value;
    aircraft.tail.horizontal.S.units = 'cm^2';
else
    error('Unit mismatch: computation of horizontal tail skin mass is not possible.')
end

if strcmp(string(aircraft.tail.horizontal.S.units), "cm^2")
aircraft.tail.horizontal.skin.mass.value = aircraft.tail.horizontal.skin.mass_per_unit_area.value.*aircraft.tail.horizontal.S.value;
aircraft.tail.horizontal.skin.mass.units = 'g';
aircraft.tail.horizontal.skin.mass.type = "mass";
aircraft.tail.horizontal.skin.mass.description = "mass of composite horizontal tail skin (not including spar, foam, or anything else)";

% convert to kg
aircraft.tail.horizontal.skin.mass.value = aircraft.tail.horizontal.skin.mass.value.*10^(-3);
aircraft.tail.horizontal.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of horizontal tail skin mass is not possible.')
end

% if g is in imperial units, convert to metric
if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.tail.horizontal.skin.weight.value = aircraft.tail.horizontal.skin.mass.value.*constants.g.value;
aircraft.tail.horizontal.skin.weight.units = 'N';
aircraft.tail.horizontal.skin.weight.type = "force";
aircraft.tail.horizontal.skin.weight.description = "weight of composite horizontal tail skin (not including spar, foam, or anything else)";

aircraft.tail.horizontal.skin.XYZ_CG.value = [d_tail + chord_HT/2, 0, radius_outer+thickness_HT/2];
aircraft.tail.horizontal.skin.XYZ_CG.units = 'in';
aircraft.tail.horizontal.skin.XYZ_CG.type = "length";
aircraft.tail.horizontal.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for horizontal tail skin CG";

% vertical tail skin CG and weight

aircraft.tail.vertical.skin.total_thickness.value = aircraft.tail.vertical.skin.thickness.value.*2;
aircraft.tail.vertical.skin.total_thickness.units = aircraft.tail.vertical.skin.thickness.units;
aircraft.tail.vertical.skin.total_thickness.type = "length";
aircraft.tail.vertical.skin.total_thickness.description = "total thickness of both top and bottom surfaces of vertical tail skin";

if strcmp(string(aircraft.tail.vertical.skin.thickness.units), "m")
    aircraft.tail.vertical.skin.thickness.value = aircraft.tail.vertical.skin.thickness.value.*10^2;
    aircraft.tail.vertical.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of vertical tail mass per unit area is not possible.')
end

if strcmp(string(aircraft.tail.vertical.skin.density.units), "g/cm^3") && strcmp(string(aircraft.tail.vertical.skin.thickness.units), "cm")
aircraft.tail.vertical.skin.mass_per_unit_area.value = aircraft.tail.vertical.skin.density.value.*aircraft.tail.vertical.skin.thickness.value;
aircraft.tail.vertical.skin.mass_per_unit_area.units = 'g/cm^2';
aircraft.tail.vertical.skin.mass_per_unit_area.description = "mass per unit area of the vertical tail skin";
else
    error('Unit mismatch: computation of tail.vertical mass is not possible.');
end

% convert planform area to cm^2
if strcmp(string(aircraft.tail.vertical.S.units), "ft^2")
    % convert ft^2 to m^2
    [aircraft, ~] = conv_aircraft_units(aircraft, 0, "aircraft.tail.vertical.S", "m^2");

    % convert m^2 to cm^2
    aircraft.tail.vertical.S.value = 10000.*aircraft.tail.vertical.S.value;
    aircraft.tail.vertical.S.units = 'cm^2';
else
    error('Unit mismatch: computation of vertical tail skin mass is not possible.')
end

if strcmp(string(aircraft.tail.vertical.S.units), "cm^2")
aircraft.tail.vertical.skin.mass.value = aircraft.tail.vertical.skin.mass_per_unit_area.value.*aircraft.tail.vertical.S.value./2; % divide by 2 for vertical tail as only half of the vertical tail span is manufactured
aircraft.tail.vertical.skin.mass.units = 'g';
aircraft.tail.vertical.skin.mass.type = "mass";
aircraft.tail.vertical.skin.mass.description = "mass of composite vertical tail skin (not including spar, foam, or anything else)";

% convert to kg
aircraft.tail.vertical.skin.mass.value = aircraft.tail.vertical.skin.mass.value.*10^(-3);
aircraft.tail.vertical.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of vertical tail skin mass is not possible.')
end

% if g is in imperial units, convert to metric
if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.tail.vertical.skin.weight.value = aircraft.tail.vertical.skin.mass.value.*constants.g.value;
aircraft.tail.vertical.skin.weight.units = 'N';
aircraft.tail.vertical.skin.weight.type = "force";
aircraft.tail.vertical.skin.weight.description = "weight of composite vertical tail skin (not including spar, foam, or anything else)";

aircraft.tail.vertical.skin.XYZ_CG.value = [d_tail + chord_VT/2, 0, radius_outer+width_VT/2];
aircraft.tail.vertical.skin.XYZ_CG.units = 'in';
aircraft.tail.vertical.skin.XYZ_CG.type = "length";
aircraft.tail.vertical.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for vertical tail skin CG";

assumptions(end+1).name = "Motor CG Location";
assumptions(end+1).description = "Model motor as a uniform density cylinder whose frontmost surface is flush with the nose of the aircraft and whose centerline lies along the centerline of the fuselage";
assumptions(end+1).rationale = "Simplicity of calculations for first pass. The uniform density parts seems reasonable as motors are designed to be balanced.";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.propulsion.motor.XYZ_CG.value = [-aircraft.fuselage.protrusion.value+aircraft.propulsion.motor.length.value/2, 0, 0];
aircraft.propulsion.motor.XYZ_CG.units = 'in';
aircraft.propulsion.motor.XYZ_CG.type = "length";
aircraft.propulsion.motor.XYZ_CG.description = "vector of X, Y, Z coordinates for the motor CG";

assumptions(end+1).name = "ESC CG Location";
assumptions(end+1).description = "Model ESC as a point mass that sits 5 inches behind the rear of the motor";
assumptions(end+1).rationale = "Arbitrary, could vary as needed by human engineering judgment or consider iterating through computationally";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.propulsion.ESC.XYZ_CG.value = [-aircraft.fuselage.protrusion.value + aircraft.propulsion.motor.length.value + 5, 0, 0];
aircraft.propulsion.ESC.XYZ_CG.units = 'in';
aircraft.propulsion.ESC.XYZ_CG.type = "length";
aircraft.propulsion.ESC.XYZ_CG.description = "vector of X, Y, Z coordinates for the ESC CG";

assumptions(end+1).name = "Propeller CG Location";
assumptions(end+1).description = "Assume propeller is balanced such that its CG lies exactly in the center of its volume. Furthermore, assume this propeller sits at the nose of the aircraft";
assumptions(end+1).rationale = "Propellers must be designed to balanced to avoid wobble or providing additional torque on the shaft... however this is still an assumption";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.propulsion.propeller.XYZ_CG.value = [-aircraft.fuselage.protrusion.value, 0, 0];
aircraft.propulsion.propeller.XYZ_CG.units = 'in';
aircraft.propulsion.propeller.XYZ_CG.type = "length";
aircraft.propulsion.propeller.XYZ_CG.description = "vector of X, Y, Z coordinates for the propeller CG";

assumptions(end+1).name = "Battery CG Location";
assumptions(end+1).description = "Assume battery CG sits 5 inches behind the rear of the motor";
assumptions(end+1).rationale = "Propellers must be designed to balanced to avoid wobble or providing additional torque on the shaft... however this is still an assumption";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.propulsion.battery.XYZ_CG.value = [-aircraft.fuselage.protrusion.value + aircraft.propulsion.motor.length.value + 5, 0, 0];
aircraft.propulsion.battery.XYZ_CG.units = 'in';
aircraft.propulsion.battery.XYZ_CG.type = "length";
aircraft.propulsion.battery.XYZ_CG.description = "vector of X, Y, Z coordinates for the battery CG";

assumptions(end+1).name = "Servo Contribution to Aircraft CG";
assumptions(end+1).description = "Neglect weight and location of all servos";
assumptions(end+1).rationale = "Need MDAO done fast, plus this is variable. In the future I want a number of servos with coordinate systems and their CGs tracked";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

assumptions(end+1).name = "Landing Gear Contribution to Aircraft CG";
assumptions(end+1).description = "Neglect weight and location of landing gear";
assumptions(end+1).rationale = "Need MDAO done fast";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

structNames = ["aircraft.fuselage.hull.weight";
    "aircraft.tail.horizontal.skin.weight";
    "aircraft.tail.vertical.skin.weight";
    "aircraft.propulsion.motor.weight";
    "aircraft.propulsion.ESC.weight";
    "aircraft.propulsion.propeller.weight";
    "aircraft.propulsion.battery.weight";
    "aircraft.fuselage.hull.XYZ_CG";
    "aircraft.tail.horizontal.skin.XYZ_CG";
    "aircraft.tail.vertical.skin.XYZ_CG";
    "aircraft.propulsion.motor.XYZ_CG";
    "aircraft.propulsion.ESC.XYZ_CG";
    "aircraft.propulsion.propeller.XYZ_CG";
    "aircraft.propulsion.battery.XYZ_CG"];
desiredUnits = ["N";
    "N";
    "N";
    "N";
    "N";
    "N";
    "N";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in";
    "in"];
[aircraft, ~] = conv_aircraft_units(aircraft, 0, structNames, desiredUnits);

part_weights = [aircraft.fuselage.hull.weight.value;
    aircraft.tail.horizontal.skin.weight.value;
    aircraft.tail.vertical.skin.weight.value;
    aircraft.propulsion.motor.weight.value;
    aircraft.propulsion.ESC.weight.value;
    aircraft.propulsion.propeller.weight.value;
    aircraft.propulsion.battery.weight.value];
part_cgs = [aircraft.fuselage.hull.XYZ_CG.value;
    aircraft.tail.horizontal.skin.XYZ_CG.value;
    aircraft.tail.vertical.skin.XYZ_CG.value;
    aircraft.propulsion.motor.XYZ_CG.value;
    aircraft.propulsion.ESC.XYZ_CG.value;
    aircraft.propulsion.propeller.XYZ_CG.value;
    aircraft.propulsion.battery.XYZ_CG.value];

aircraft.weight.unloaded.value = sum(part_weights);
aircraft.weight.unloaded.units = 'N';
aircraft.weight.unloaded.type = "force";
aircraft.weight.unloaded.description = "Weight of aircraft with no payload (no ducks, pucks, or banner)";

aircraft.unloaded.XYZ_CG.value = composite_cg(part_weights, part_cgs);
aircraft.unloaded.XYZ_CG.units = 'in';
aircraft.unloaded.XYZ_CG.type = "length";
aircraft.unloaded.XYZ_CG.description = "vector of X, Y, Z coordinates for empty aircraft CG. That is, the CG of the system including the: fuselage skin, wing spar, horizontal tail skin, vertical tail skin, motor, ESC, propeller, and battery.";

alpha(gca, 0.5);
plot3(aircraft.unloaded.XYZ_CG.value(1), aircraft.unloaded.XYZ_CG.value(2), aircraft.unloaded.XYZ_CG.value(3), 'ro', 'MarkerSize', 15, 'LineWidth', 2, ...
          'MarkerEdgeColor', 'r', 'DisplayName', 'CG');

else
    error('displayAircraft.m must be rewritten to support nonconventional (T or U shaped) tails.');
end