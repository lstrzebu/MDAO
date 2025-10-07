function [] = WriteMassFile(file_name,Length_unit,Mass_unit,Time_unit,g,air_density,mass,x_cm,y_cm,z_cm,I_matrix)
%WRITEAVLFILE   Takes all of the required inputs and writes a mass file. 
%               This function is not vectorizable, as only one mass file can
%               be generated at a time.
%             
%
%   - INPUTS:
%
%       file_name           -   The name of the AVL file generated from
%                               this function 
%                               (STRING OR CHAR)
%
%       Length_unit         -   The unit of length that AVL shall use (EX:
%                               m, in, ft)
%                               (STRING OR CHAR)
%
%       Mass_unit           -   The unit of length that AVL shall use (EX:
%                               kg, slug, lbm)
%                               (STRING OR CHAR)
%
%       Time_unit           -   The unit of length that AVL shall use (EX:
%                               s, min, hour)
%                               (STRING OR CHAR)
%
%       g                   -   Gravitational acceleration in
%                               Length_unit/Time_unit^2
%                               (DOUBLE)
%
%       air_density         -   Density of the air in
%                               Mass_unit/Length_unit^3
%                               (DOUBLE)
%
%       mass                -   Mass of your aircraft in Mass_unit
%                               (DOUBLE)
%
%       x_cm                -   x location of the Center of Mass in
%                               Length_unit
%                               (DOUBLE)
%
%       y_cm                -   y location of the Center of Mass in
%                               Length_unit
%                               (DOUBLE)
%
%       z_cm                -   z location of the Center of Mass in
%                               Length_unit
%                               (DOUBLE)
%
%       I_matrix            -   Matrix containing Ixx, Iyy, Izz, Ixy, Iyz,
%                               and Ixz in Mass_unit*Length_unit^2 about
%                               aircraft CG. For most symmetric aircraft,
%                               Ixy and Iyz are 0
%                               (3x3 DOUBLE)

%% Finding the I values

% I     =   |   I_xx    I_xy    I_xz    |
%           |   I_xy    I_yy    I_yz    |
%           |   I_xz    I_yz    I_zz    |

I_xx = I_matrix(1,1);
I_yy = I_matrix(2,2);
I_zz = I_matrix(3,3);

I_xy = I_matrix(1,2);
I_xz = I_matrix(1,3);
I_yz = I_matrix(2,3);

%% Creating the mass file

% Creates .mass file
fileID = fopen(sprintf("%s.mass",file_name), "wt");

fprintf(fileID,"#-------------------------------------------------\n");
fprintf(fileID,"#  SuperGee \n");
fprintf(fileID,"#\n");
fprintf(fileID,"#  Dimensional unit and parameter data.\n");
fprintf(fileID,"#  Mass & Inertia breakdown.\n");
fprintf(fileID,"#-------------------------------------------------\n\n");

fprintf(fileID,"#  Names and scalings for units to be used for trim and eigenmode calculations.\n");
fprintf(fileID,"#  The Lunit and Munit values scale the mass, xyz, and inertia table data below.\n");
fprintf(fileID,"#  Lunit value will also scale all lengths and areas in the AVL input file.\n");
fprintf(fileID,"Lunit = 1  %s\n",Length_unit);
fprintf(fileID,"Munit = 1  %s\n",Mass_unit);
fprintf(fileID,"Tunit = 1.0    %s\n\n",Time_unit);

fprintf(fileID,"#------------------------- \n");
fprintf(fileID,"#  Gravity and density to be used as default values in trim setup (saves runtime typing).\n");
fprintf(fileID,"#  Must be in the unit names given above (m,kg,s).\n");
fprintf(fileID,"g   = %f\n",g);
fprintf(fileID,"rho = %f\n\n",air_density);

fprintf(fileID,"#-------------------------\n");
fprintf(fileID,"#  Mass & Inertia breakdown.\n");
fprintf(fileID,"#  x y z  is location of item's own CG.\n");
fprintf(fileID,"#  Ixx... are item's inertias about item's own CG.\n");
fprintf(fileID,"#\n");
fprintf(fileID,"#  x,y,z system here must be exactly the same one used in the .avl input file\n");
fprintf(fileID,"#     (same orientation, same origin location, same length units)\n");
fprintf(fileID,"#\n");
fprintf(fileID,"#  mass                 x    y     z        Ixx        Iyy        Izz     Ixy     Ixz     Iyz\n");
fprintf(fileID,"#\n");
fprintf(fileID,"   %f  %f  %f  %f  %f  %f  %f  %f  %f  %f! Entire plane",mass,x_cm,y_cm,z_cm,I_xx,I_yy,I_zz,I_xy,I_xz,I_yz);

% Closes the .mass file
fclose(fileID);

end

