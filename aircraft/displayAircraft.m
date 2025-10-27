%% Unit Checks
structNames = ["aircraft.fuselage.diameter";
    "aircraft.fuselage.length";
    "aircraft.wing.c";
    "aircraft.wing.b";
    "aircraft.tail.d_tail";
    "aircraft.tail.horizontal.b";
    "aircraft.tail.horizontal.c";
    "aircraft.tail.vertical.b";
    "aircraft.tail.vertical.c"; 
    "aircraft.fuselage.protrusion";
    "aircraft.fuselage.thickness";
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
aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits);

% inputs: 
tailType = aircraft.tail.config.value;

%% Fuselage
D = aircraft.fuselage.diameter.value;
radius_outer = D/2;
fuselage_length = aircraft.fuselage.length.value;

center_x = fuselage_length/2 - aircraft.fuselage.protrusion.value;
center_y = 0;
center_z = 0;

if displayToggle

min_x = center_x - fuselage_length/2;
max_x = center_x + fuselage_length/2;

sz = 2*max_x + 1;
cylinder_matrix = zeros(sz+1, sz+1, sz+1);

[X, Y, Z] = meshgrid((-sz/2):(sz/2), (-sz/2):(sz/2), (-sz/2):(sz/2));
dist_sq = (Y - center_y).^2 + (Z - center_z).^2;
is_inside_cylinder = (dist_sq <= radius_outer^2) & (X >= min_x) & (X <= max_x);
cylinder_matrix(is_inside_cylinder) = 1;

figure;
hold on;
isosurface(X, Y, Z, cylinder_matrix, 0.5);
axis equal;
%title(sprintf('%s', aircraft.title.value));
xlabel('X (in)');
ylabel('Y (in)');
zlabel('Z (in)');
grid on;
view(3);

end

%% Wing
chord = aircraft.wing.c.value;
b = aircraft.wing.b.value;
width = b/2;
%eval(sprintf('thicknessMultiplier = 0.%s;', aircraft.wing.airfoil_name(8:9)))
[~, thicknessMultiplier] = airfoil_thickness('MH 114.dat');
thickness_wing = thicknessMultiplier*chord;
vertical_wing_center = 0.85*radius_outer + thickness_wing/2;

assumptions(end+1).name = "Wing Attachment Z Coordinate";
assumptions(end+1).description = "Assume the bottom z coordinate of wing attachment is approximately 85% of the way toward the top half of the fuselage";
assumptions(end+1).rationale = "hand calcs based on SolidWorks fuselage model 'Fuselage with structure.SLDASM' located in folder Airframe-20251013T130855Z-1-001. Model was downloaded at 1215 EST 13 October 2025, at which point it had been last modified October 8. Hand calcs may be found in 'Hand Calcs for Wing Attachment Z Coordinate Assumption.txt.'";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

if displayToggle
V = [
    0, -width, vertical_wing_center-thickness_wing/2;
    chord, -width, vertical_wing_center-thickness_wing/2;
    chord, width, vertical_wing_center-thickness_wing/2;
    0, width, vertical_wing_center-thickness_wing/2;
    0, -width, vertical_wing_center+thickness_wing/2;
    chord, -width, vertical_wing_center+thickness_wing/2;
    chord, width, vertical_wing_center+thickness_wing/2;
    0, width, vertical_wing_center+thickness_wing/2
];
F = [
    1, 2, 3, 4;
    5, 6, 7, 8;
    1, 2, 6, 5;
    4, 3, 7, 8;
    2, 3, 7, 6;
    1, 4, 8, 5
];
patch('Vertices', V, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);
end

%% Tail
d_tail = aircraft.tail.d_tail.value;
chord_HT = aircraft.tail.horizontal.c.value;
b_HT = aircraft.tail.horizontal.b.value;
width_HT = b_HT/2;
eval(sprintf('thicknessMultiplier_HT = 0.%s;', aircraft.tail.horizontal.airfoil_name(8:9)))
thickness_HT = thicknessMultiplier_HT*chord_HT;


aircraft.tail.horizontal.skin.XYZ_CG.units = 'in';
aircraft.tail.horizontal.skin.XYZ_CG.type = "length";
aircraft.tail.horizontal.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for horizontal tail skin CG";
aircraft.tail.vertical.skin.XYZ_CG.units = 'in';
aircraft.tail.vertical.skin.XYZ_CG.type = "length";
aircraft.tail.vertical.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for vertical tail skin CG";

if strcmp(tailType(1), 'C')
    % Conventional Tail
    horizontal_tail_z_center = radius_outer;
    V_HT = [
        d_tail, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center+thickness_HT/2
    ];
    patch('Vertices', V_HT, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);

    chord_VT = aircraft.tail.vertical.c.value;
    b_VT = aircraft.tail.vertical.b.value;
    width_VT = b_VT/2;
    eval(sprintf('thicknessMultiplier_VT = 0.%s;', aircraft.tail.vertical.airfoil_name(8:9)))
    thickness_VT = thicknessMultiplier_VT*chord_VT;
    vertical_tail_y_center = 0;
    vertical_tail_z_bottom = radius_outer;

    if displayToggle
    V_VT = [
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT
    ];
    patch('Vertices', V_VT, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);
end
    
    aircraft.tail.horizontal.skin.XYZ_CG.value = [d_tail + chord_HT/2, 0, radius_outer+thickness_HT/2];
    aircraft.tail.vertical.skin.XYZ_CG.value = [d_tail + chord_VT/2, 0, radius_outer+width_VT/2];

elseif strcmp(tailType(1), 'T')
    % T-Tail: Horizontal tail at top of vertical tail
    chord_VT = aircraft.tail.vertical.c.value;
    b_VT = aircraft.tail.vertical.b.value;
    width_VT = b_VT/2;
    eval(sprintf('thicknessMultiplier_VT = 0.%s;', aircraft.tail.vertical.airfoil_name(8:9)))
    thickness_VT = thicknessMultiplier_VT*chord_VT;
    vertical_tail_y_center = 0;
    vertical_tail_z_bottom = radius_outer;
    horizontal_tail_z_center = vertical_tail_z_bottom + width_VT;

    if displayToggle
    V_VT = [
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT
    ];
    patch('Vertices', V_VT, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);

    V_HT = [
        d_tail, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center+thickness_HT/2
    ];
    patch('Vertices', V_HT, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);
    end

    aircraft.tail.horizontal.skin.XYZ_CG.value = [d_tail + chord_HT/2, 0, horizontal_tail_z_center+thickness_HT/2];
    aircraft.tail.vertical.skin.XYZ_CG.value = [d_tail + chord_VT/2, 0, vertical_tail_z_bottom+width_VT/2];

elseif strcmp(tailType(1), 'U')
    % U-Tail: Two vertical tails at tips of horizontal tail
    horizontal_tail_z_center = radius_outer;
    V_HT = [
        d_tail, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center-thickness_HT/2;
        d_tail, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, -width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail+chord_HT, width_HT, horizontal_tail_z_center+thickness_HT/2;
        d_tail, width_HT, horizontal_tail_z_center+thickness_HT/2
    ];
    patch('Vertices', V_HT, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);

    chord_VT = aircraft.tail.vertical.c.value;
    b_VT = aircraft.tail.vertical.b.value;
    width_VT = b_VT/2;
    eval(sprintf('thicknessMultiplier_VT = 0.%s;', aircraft.tail.vertical.airfoil_name(8:9)))
    thickness_VT = thicknessMultiplier_VT*chord_VT;
    
    if displayToggle

    % Left vertical tail (at y = -width_HT)
    vertical_tail_y_center = -width_HT;
    vertical_tail_z_bottom = radius_outer;
    V_VT1 = [
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT
    ];
    patch('Vertices', V_VT1, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);

    % Right vertical tail (at y = +width_HT)
    vertical_tail_y_center = width_HT;
    V_VT2 = [
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center-thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom;
        d_tail+chord_VT, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT;
        d_tail, vertical_tail_y_center+thickness_VT/2, vertical_tail_z_bottom+width_VT
    ];
    
    patch('Vertices', V_VT2, 'Faces', F, 'FaceColor', [0.7, 0.7, 0.7]);

    end
    
    % For CG, assume vertical tail mass is split equally between two vertical tails
    aircraft.tail.vertical.skin.XYZ_CG.value = [d_tail + chord_VT/2, 0, radius_outer+width_VT/2];
    aircraft.tail.horizontal.skin.XYZ_CG.value = [d_tail + chord_HT/2, 0, radius_outer+thickness_HT/2];
else
    error('Invalid tailType: must be Conventional, T, or U.');
end

if displayToggle
% Fuselage Sanity Checks
if max_x < d_tail - chord_HT
    error('Floating tail: fuselage too far forward.')
elseif aircraft.fuselage.protrusion.value < 0
    error('Floating wing: fuselage too far backward.')
end
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
aircraft.wing.skin.thickness.description = "Thickness of composite wing skin";

assumptions(end+1).name = "Composite Wing Skin Thickness";
assumptions(end+1).description = sprintf("Assume a wing skin thickness of approximately %.2f %s", aircraft.wing.skin.thickness.value, aircraft.wing.skin.thickness.units);
assumptions(end+1).rationale = "Unknown";
assumptions(end+1).responsible_engineer = "Sam Prochnau";

aircraft.tail.horizontal.skin.thickness.value = aircraft.wing.skin.thickness.value;
aircraft.tail.horizontal.skin.thickness.units = aircraft.wing.skin.thickness.units;
aircraft.tail.horizontal.skin.thickness.type = "length";
aircraft.tail.horizontal.skin.thickness.description = "Thickness of composite horizontal tail skin";

assumptions(end+1).name = "Composite Horizontal Tail Skin Thickness";
assumptions(end+1).description = "Assume wing and horizontal tail have similar composite skin thicknesses";
assumptions(end+1).rationale = "Ease of manufacturing, simplicity of calculation in MDAO - can be refined later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.tail.vertical.skin.thickness.value = aircraft.wing.skin.thickness.value;
aircraft.tail.vertical.skin.thickness.units = aircraft.wing.skin.thickness.units;
aircraft.tail.vertical.skin.thickness.type = "length";
aircraft.tail.vertical.skin.thickness.description = "Thickness of composite vertical tail skin";

assumptions(end+1).name = "Composite vertical Tail Skin Thickness";
assumptions(end+1).description = "Assume wing and vertical tail have similar composite skin thicknesses";
assumptions(end+1).rationale = "Ease of manufacturing, simplicity of calculation in MDAO - can be refined later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

aircraft.wing.spar.outer_diameter.value = 0.75*0.0254;
aircraft.wing.spar.outer_diameter.units = 'm';
aircraft.wing.spar.outer_diameter.type = "length";
aircraft.wing.spar.outer_diameter.description = "outer diameter of wing spar";

aircraft.wing.spar.outer_radius.value = aircraft.wing.spar.outer_diameter.value/2;
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

aircraft.wing.spar.XYZ_CG.value = [0.5*aircraft.wing.c.value, 0, vertical_wing_center];
aircraft.wing.spar.XYZ_CG.units = aircraft.wing.c.units;
aircraft.wing.spar.XYZ_CG.type = "length";
aircraft.wing.spar.XYZ_CG.description = "vector of X, Y, Z coordinates for wing spar center of gravity";

aircraft.wing.spar.weight.value = 0.5;
aircraft.wing.spar.weight.units = 'lbf';
aircraft.wing.spar.weight.type = "force";
aircraft.wing.spar.weight.description = "weight of wing spar";

assumptions(end+1).name = "Wing Spar Weight";
assumptions(end+1).description = sprintf("Assume wing spar weighs %.2f %s", aircraft.wing.spar.weight.value, aircraft.wing.spar.weight.units);
assumptions(end+1).rationale = "Temporary assumption, change later";
assumptions(end+1).responsible_engineer = "Liam Trzebunia";

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
% 
% aircraft.fuselage.density.value = aircraft.wing.skin.density.value;
% aircraft.fuselage.density.units = aircraft.wing.skin.density.units;
% aircraft.fuselage.density.type = "density";
% aircraft.fuselage.density.description = "density of composite material used in fuselage layup";

radius_inner = radius_outer - aircraft.fuselage.thickness.value;
aircraft.fuselage.cross_sectional_area.value = pi*(radius_outer^2 - radius_inner^2);
aircraft.fuselage.cross_sectional_area.units = 'in^2';
aircraft.fuselage.cross_sectional_area.type = "area";
aircraft.fuselage.cross_sectional_area.description = "cross sectional area of cylindrical fuselage occupied by hull material";

% aircraft.fuselage.solid_volume.value = aircraft.fuselage.cross_sectional_area.value*fuselage_length;
% aircraft.fuselage.solid_volume.units = 'in^3';
% aircraft.fuselage.solid_volume.type = "vol";
% aircraft.fuselage.solid_volume.description = "volume of space occupied by fuselage hull material";
% 
% if strcmp(string(aircraft.fuselage.density.units), "g/cm^3") && strcmp(string(aircraft.fuselage.solid_volume.units), "in^3")
%     aircraft = conv_aircraft_units(aircraft, missionIteration, "aircraft.fuselage.solid_volume", "cm^3");
%     if strcmp(string(aircraft.fuselage.solid_volume.units), "cm^3")
%         aircraft.fuselage.mass.value = aircraft.fuselage.density.value*aircraft.fuselage.solid_volume.value;
%         aircraft.fuselage.mass.units = 'g';
%         aircraft.fuselage.mass.type = "mass";
%         aircraft.fuselage.mass.description = "mass of fuselage hull (not including structural bulkheads)";
%     else
%         error('Unit mismatch: computation of fuselage mass not possible.')
%     end
% else
%     error('Unit mismatch: computation of fuselage mass is not possible.')
% end

% if strcmp(string(aircraft.fuselage.mass.units), "g")
%     aircraft.fuselage.mass.value = aircraft.fuselage.mass.value * 10^(-3);
%     aircraft.fuselage.mass.units = 'kg';
% else
%     error('Unit mismatch: computation of fuselage weight is not possible.')
% end
% 
% if ~strcmp(string(constants.g.units), "m/s^2")
%     constants.g.value = 9.81;
%     constants.g.units = 'm/s^2';
% end
% 
% if strcmp(string(aircraft.fuselage.mass.units), "kg") && strcmp(string(constants.g.units), "m/s^2")
%     aircraft.fuselage.weight.value = aircraft.fuselage.mass.value*constants.g.value;
%     aircraft.fuselage.weight.units = 'N';
%     aircraft.fuselage.weight.type = "force";
%     aircraft.fuselage.weight.description = "weight of fuselage hull (not including structural bulkheads)";
% else
%     error('Unit mismatch: computation of fuselage weight is not possible.')
% end

aircraft.wing.skin.total_thickness.value = aircraft.wing.skin.thickness.value*2;
aircraft.wing.skin.total_thickness.units = aircraft.wing.skin.thickness.units;
aircraft.wing.skin.total_thickness.type = "length";
aircraft.wing.skin.total_thickness.description = "total thickness of both top and bottom surfaces of wing skin";

if strcmp(string(aircraft.wing.skin.thickness.units), "m")
    aircraft.wing.skin.thickness.value = aircraft.wing.skin.thickness.value*10^2;
    aircraft.wing.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of wing mass per unit area is not possible.')
end

if strcmp(string(aircraft.wing.skin.density.units), "g/cm^3") && strcmp(string(aircraft.wing.skin.thickness.units), "cm")
    aircraft.wing.skin.mass_per_unit_area.value = aircraft.wing.skin.density.value*aircraft.wing.skin.thickness.value;
    aircraft.wing.skin.mass_per_unit_area.units = 'g/cm^2';
    aircraft.wing.skin.mass_per_unit_area.description = "mass per unit area of the wing skin";
else
    error('Unit mismatch: computation of wing mass is not possible.');
end

if strcmp(string(aircraft.wing.S.units), "ft^2") || strcmp(string(aircraft.wing.S.units), "in^2")
    aircraft = conv_aircraft_units(aircraft, missionIteration, "aircraft.wing.S", "m^2");
    aircraft.wing.S.value = 10000*aircraft.wing.S.value;
    aircraft.wing.S.units = 'cm^2';
else
    error('Unit mismatch: computation of wing skin mass is not possible.')
end

if strcmp(string(aircraft.wing.S.units), "cm^2")
    aircraft.wing.skin.mass.value = aircraft.wing.skin.mass_per_unit_area.value*aircraft.wing.S.value;
    aircraft.wing.skin.mass.units = 'g';
    aircraft.wing.skin.mass.type = "mass";
    aircraft.wing.skin.mass.description = "mass of composite wing skin (not including spar, foam, or anything else)";
    aircraft.wing.skin.mass.value = aircraft.wing.skin.mass.value*10^(-3);
    aircraft.wing.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of wing skin mass is not possible.')
end

if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.wing.skin.weight.value = aircraft.wing.skin.mass.value*constants.g.value;
aircraft.wing.skin.weight.units = 'N';
aircraft.wing.skin.weight.type = "force";
aircraft.wing.skin.weight.description = "weight of composite wing skin (not including spar, foam, or anything else)";
aircraft.wing.skin.XYZ_CG.value = [chord/2, 0, vertical_wing_center+thickness_wing/2];
aircraft.wing.skin.XYZ_CG.units = 'in';
aircraft.wing.skin.XYZ_CG.type = "length";
aircraft.wing.skin.XYZ_CG.description = "vector of X, Y, Z coordinates for wing skin CG";

aircraft.tail.horizontal.skin.total_thickness.value = aircraft.tail.horizontal.skin.thickness.value*2;
aircraft.tail.horizontal.skin.total_thickness.units = aircraft.tail.horizontal.skin.thickness.units;
aircraft.tail.horizontal.skin.total_thickness.type = "length";
aircraft.tail.horizontal.skin.total_thickness.description = "total thickness of both top and bottom surfaces of horizontal tail skin";

if strcmp(string(aircraft.tail.horizontal.skin.thickness.units), "m")
    aircraft.tail.horizontal.skin.thickness.value = aircraft.tail.horizontal.skin.thickness.value*10^2;
    aircraft.tail.horizontal.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of horizontal tail mass per unit area is not possible.')
end

if strcmp(string(aircraft.tail.horizontal.skin.density.units), "g/cm^3") && strcmp(string(aircraft.tail.horizontal.skin.thickness.units), "cm")
    aircraft.tail.horizontal.skin.mass_per_unit_area.value = aircraft.tail.horizontal.skin.density.value*aircraft.tail.horizontal.skin.thickness.value;
    aircraft.tail.horizontal.skin.mass_per_unit_area.units = 'g/cm^2';
    aircraft.tail.horizontal.skin.mass_per_unit_area.description = "mass per unit area of the horizontal tail skin";
else
    error('Unit mismatch: computation of tail.horizontal mass is not possible.');
end

if strcmp(string(aircraft.tail.horizontal.S.units), "ft^2")
    aircraft = conv_aircraft_units(aircraft, missionIteration, "aircraft.tail.horizontal.S", "m^2");
    aircraft.tail.horizontal.S.value = 10000*aircraft.tail.horizontal.S.value;
    aircraft.tail.horizontal.S.units = 'cm^2';
else
    error('Unit mismatch: computation of horizontal tail skin mass is not possible.')
end

if strcmp(string(aircraft.tail.horizontal.S.units), "cm^2")
    aircraft.tail.horizontal.skin.mass.value = aircraft.tail.horizontal.skin.mass_per_unit_area.value*aircraft.tail.horizontal.S.value;
    aircraft.tail.horizontal.skin.mass.units = 'g';
    aircraft.tail.horizontal.skin.mass.type = "mass";
    aircraft.tail.horizontal.skin.mass.description = "mass of composite horizontal tail skin (not including spar, foam, or anything else)";
    aircraft.tail.horizontal.skin.mass.value = aircraft.tail.horizontal.skin.mass.value*10^(-3);
    aircraft.tail.horizontal.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of horizontal tail skin mass is not possible.')
end

if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.tail.horizontal.skin.weight.value = aircraft.tail.horizontal.skin.mass.value*constants.g.value;
aircraft.tail.horizontal.skin.weight.units = 'N';
aircraft.tail.horizontal.skin.weight.type = "force";
aircraft.tail.horizontal.skin.weight.description = "weight of composite horizontal tail skin (not including spar, foam, or anything else)";

aircraft.tail.vertical.skin.total_thickness.value = aircraft.tail.vertical.skin.thickness.value*2;
aircraft.tail.vertical.skin.total_thickness.units = aircraft.tail.vertical.skin.thickness.units;
aircraft.tail.vertical.skin.total_thickness.type = "length";
aircraft.tail.vertical.skin.total_thickness.description = "total thickness of both top and bottom surfaces of vertical tail skin";

if strcmp(string(aircraft.tail.vertical.skin.thickness.units), "m")
    aircraft.tail.vertical.skin.thickness.value = aircraft.tail.vertical.skin.thickness.value*10^2;
    aircraft.tail.vertical.skin.thickness.units = 'cm';
else
    error('Unit mismatch: computation of vertical tail mass per unit area is not possible.')
end

if strcmp(string(aircraft.tail.vertical.skin.density.units), "g/cm^3") && strcmp(string(aircraft.tail.vertical.skin.thickness.units), "cm")
    aircraft.tail.vertical.skin.mass_per_unit_area.value = aircraft.tail.vertical.skin.density.value*aircraft.tail.vertical.skin.thickness.value;
    aircraft.tail.vertical.skin.mass_per_unit_area.units = 'g/cm^2';
    aircraft.tail.vertical.skin.mass_per_unit_area.description = "mass per unit area of the vertical tail skin";
else
    error('Unit mismatch: computation of tail.vertical mass is not possible.');
end

if strcmp(string(aircraft.tail.vertical.S.units), "ft^2")
    aircraft = conv_aircraft_units(aircraft, missionIteration, "aircraft.tail.vertical.S", "m^2");
    aircraft.tail.vertical.S.value = 10000*aircraft.tail.vertical.S.value;
    aircraft.tail.vertical.S.units = 'cm^2';
else
    error('Unit mismatch: computation of vertical tail skin mass is not possible.')
end

if strcmp(string(aircraft.tail.vertical.S.units), "cm^2")
    if strcmp(tailType(1), 'U')
        % For U-tail, two vertical tails, so total mass is doubled
        aircraft.tail.vertical.skin.mass.value = aircraft.tail.vertical.skin.mass_per_unit_area.value*aircraft.tail.vertical.S.value;
    else
        % For Conventional and T-tail, single vertical tail
        aircraft.tail.vertical.skin.mass.value = aircraft.tail.vertical.skin.mass_per_unit_area.value*aircraft.tail.vertical.S.value/2;
    end
    aircraft.tail.vertical.skin.mass.units = 'g';
    aircraft.tail.vertical.skin.mass.type = "mass";
    aircraft.tail.vertical.skin.mass.description = "mass of composite vertical tail skin (not including spar, foam, or anything else)";
    aircraft.tail.vertical.skin.mass.value = aircraft.tail.vertical.skin.mass.value*10^(-3);
    aircraft.tail.vertical.skin.mass.units = 'kg';
else
    error('Unit mismatch: computation of vertical tail skin mass is not possible.')
end

if ~strcmp(string(constants.g.units), "m/s^2")
    constants.g.value = 9.81;
    constants.g.units = 'm/s^2';
end

aircraft.tail.vertical.skin.weight.value = aircraft.tail.vertical.skin.mass.value*constants.g.value;
aircraft.tail.vertical.skin.weight.units = 'N';
aircraft.tail.vertical.skin.weight.type = "force";
aircraft.tail.vertical.skin.weight.description = "weight of composite vertical tail skin (not including spar, foam, or anything else)";

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

structNames = ["aircraft.fuselage.weight";
    "aircraft.wing.skin.weight";
    "aircraft.tail.horizontal.skin.weight";
    "aircraft.tail.vertical.skin.weight";
    "aircraft.propulsion.motor.weight";
    "aircraft.propulsion.ESC.weight";
    "aircraft.propulsion.battery.weight";
    "aircraft.fuselage.XYZ_CG";
    "aircraft.wing.skin.XYZ_CG";
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
    "in";
    "in"];
aircraft = conv_aircraft_units(aircraft, missionIteration, structNames, desiredUnits);

part_weights = [aircraft.fuselage.weight.value;
    aircraft.wing.skin.weight.value;
    aircraft.tail.horizontal.skin.weight.value;
    aircraft.tail.vertical.skin.weight.value;
    aircraft.propulsion.motor.weight.value;
    aircraft.propulsion.ESC.weight.value;
    aircraft.propulsion.battery.weight.value];
part_cgs = [aircraft.fuselage.XYZ_CG.value;
    aircraft.wing.skin.XYZ_CG.value;
    aircraft.tail.horizontal.skin.XYZ_CG.value;
    aircraft.tail.vertical.skin.XYZ_CG.value;
    aircraft.propulsion.motor.XYZ_CG.value;
    aircraft.propulsion.ESC.XYZ_CG.value;
    aircraft.propulsion.battery.XYZ_CG.value];

aircraft.unloaded.weight.value = sum(part_weights);
aircraft.unloaded.weight.units = 'N';
aircraft.unloaded.weight.type = "force";
aircraft.unloaded.weight.description = "Weight of aircraft with no payload (no ducks, pucks, banner, or propeller)";

aircraft.unloaded.XYZ_CG.value = composite_cg(part_weights, part_cgs);
aircraft.unloaded.XYZ_CG.units = 'in';
aircraft.unloaded.XYZ_CG.type = "length";
aircraft.unloaded.XYZ_CG.description = "vector of X, Y, Z coordinates for empty aircraft CG. That is, the CG of the system including the: fuselage skin, wing spar, horizontal tail skin, vertical tail skin, motor, ESC, and battery.";

if displayToggle
alpha(gca, 0.5);
plot3(aircraft.unloaded.XYZ_CG.value(1), aircraft.unloaded.XYZ_CG.value(2), aircraft.unloaded.XYZ_CG.value(3), 'ro', 'MarkerSize', 15, 'LineWidth', 2, ...
      'MarkerEdgeColor', 'r', 'DisplayName', 'CG');
end