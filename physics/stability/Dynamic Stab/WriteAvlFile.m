function [] = WriteAvlFile(title,file_name,airfoil_file,Htail_airfoil_file,Vtail_airfoil_file,duplicate_Vtail,x_cm,y_cm,z_cm,M,S_ref,C_ref,b,section_chord,section_alpha,section_x,section_y,section_z,tail_incidence,Htail_location,Htail_section_chord,Htail_section_alpha,Htail_section_x,Htail_section_y,Htail_section_z,Vtail_location,Vtail_section_chord,Vtail_section_x,Vtail_section_y,Vtail_section_z)
%WRITEAVLFILE   Takes all of the required inputs and writes an AVL file. 
%               This function is not vectorizable, as only one AVL file can
%               be generated at a time.
%             
%
%   - INPUTS:
%
%       title               -   The name of the input design. Will appear
%                               on plots and graphs
%                               (STRING OR CHAR)
%
%       file_name           -   The name of the AVL file generated from
%                               this function 
%                               (STRING OR CHAR)
%
%       airfoil_file        -   The file of the airfoil you want to use for
%                               the wing
%                               (STRING OR CHAR)
%
%       Htail_airfoil_file  -   The file of the airfoil you want to use for
%                               the horizontal tail
%                               (STRING OR CHAR)
%
%       Vtail_airfoil_file  -   The file of the airfoil you want to use for
%                               the vertical tail
%                               (STRING OR CHAR)
%
%       duplicate_Vtail     -   Whether you want to mirror the Vtail about
%                               the y-axis. Used for U-tails and V-tails
%                               (true OR false)
%
%       x_cm                -   x location of the Center of Mass
%                               (DOUBLE)
%
%       y_cm                -   y location of the Center of Mass
%                               (DOUBLE)
%
%       z_cm                -   z location of the Center of Mass
%                               (DOUBLE)
%
%       M                   -   Mach Number
%                               (DOUBLE)
%
%       S_ref               -   Reference wing area 
%                               (DOUBLE)
%
%       C_ref               -   Reference chord of entire wing 
%                               (DOUBLE)
%
%       b                   -   Wingspan 
%                               (DOUBLE)
%
%       section_chord       -   Vector containing the chords of each wing
%                               section. Minimum of 2 elements. First 
%                               element is the root chord and second 
%                               element is the tip chord
%                               (DOUBLE ARRAY)
%                               
%       section_alpha       -   Vector containing the angle of attack of
%                               each section_chord. Must have same number
%                               of elements as section_chord
%                               (DOUBLE ARRAY)
%
%       section_x           -   Vector containing the x positions of the
%                               leading edges of each section_chord. Must
%                               have same number of elements as
%                               section_chord
%                               (DOUBLE ARRAY)
%
%       section_y           -   Vector containing the y positions of the
%                               leading edges of each section_chord. Must
%                               have same number of elements as
%                               section_chord
%                               (DOUBLE ARRAY)
%
%       section_z           -   Vector containing the z positions of the
%                               leading edges of each section_chord. Must
%                               have same number of elements as
%                               section_chord
%                               (DOUBLE ARRAY)
%
%       tail_incidence      -   Incidence angle of the entire tail.
%                               Positive angle is CW rotation.
%                               (DOUBLE)
%
%       tail_location       -   3D vector containing the x,y,z position of
%                               the leading edge of the tail
%                               (DOUBLE ARRAY)
%


%% Creating the avl file

% % Deletes the current file with the given filename so that a new one will
% % replace it
% delete(file_name)

% Creates .avl file
fileID = fopen(sprintf("%s.avl",file_name), "wt");

% Defines the title of the AVL file
fprintf(fileID,'%s\n',title);

% General properties
fprintf(fileID,'%7f                            !   Mach\n',M);
fprintf(fileID,'%d           %d           %d           !   iYsym  iZsym  Zsym\n',0,0,0);
fprintf(fileID,'%7f    %7f    %7f    !   Sref   Cref   Bref   reference area, chord, span\n',S_ref,C_ref,b);
fprintf(fileID,'%7f    %7f   %7f    !   Xref   Yref   Zref   moment reference location (arb.)\n',x_cm,y_cm,z_cm);

% Predefined wing properties. Won't change with MDAO
fprintf(fileID,'\n#\n#=======wing=======================================================\n#\nSURFACE\nWing\n');
fprintf(fileID,'10  0.1  22  1.0   ! Nchord   Cspace   Nspan  Sspace\n#\n# reflect image wing about y=0 plane\nYDUPLICATE\n');
fprintf(fileID,'     0.00000\n\n');

fprintf(fileID,'#\n# x,y,z bias for whole surface\nTRANSLATE\n   0.000     0.000     0.00000\n');

%% Defining the number of sections of the wing

sections = strings(numel(section_chord),1);

% For loop names all of the section chords
for i = 1:numel(sections)

    if i < 10

        % Labels the section, for one-digit numbers
        sections(i) = sprintf('C%d--',i);

    elseif i >= 10

        % Labels the section, for two-digit numbers
        sections(i) = sprintf('C%d-',i);

    end

end % End of for loop

sections(1) = "root";
sections(end) = "tip-";


%% Writing out the wing sections

% For loop writes out each section properties in AVL
for i = 1:numel(sections)

    fprintf(fileID,"\n\n#\n");
    fprintf(fileID,"#---------%s----------------------------------------------------\n",sections(i));
    fprintf(fileID,"#   Xle         Yle         Zle         chord       angle\n");
    fprintf(fileID,"SECTION\n");
    fprintf(fileID,'    %7f    %7f    %7f    %7f    %7f\n\n',section_x(i),section_y(i),section_z(i),section_chord(i),section_alpha(i));

    fprintf(fileID,'AFIL\n');
    fprintf(fileID,"%s\n",airfoil_file);

end % End of for loop

%% Horizontal Tail

fprintf(fileID,"\n#\n");
fprintf(fileID,"#========H-Stab======================================================\n");
fprintf(fileID,"#\n\n");

fprintf(fileID,"SURFACE\n");
fprintf(fileID,"H-Stab\n");
fprintf(fileID,"8  1.0  5  1.0  !  Nchord   Cspace   Nspan  Sspace\n");
fprintf(fileID,"#\n");
fprintf(fileID,"# reflect image wing about y=0 plane\n");
fprintf(fileID,"YDUPLICATE\n");
fprintf(fileID,"     0.00000 \n");
fprintf(fileID,"#\n");
fprintf(fileID,"# twist angle bias for whole surface\n");
fprintf(fileID,"ANGLE\n");
fprintf(fileID,"     %7f\n",tail_incidence.*-1);

fprintf(fileID,"#\n");
fprintf(fileID,"# x,y,z bias for whole surface\n");
fprintf(fileID,"TRANSLATE\n");
fprintf(fileID,"    %7f    %7f    %7f\n",Htail_location(1),Htail_location(2),Htail_location(3));

%% Defining the number of sections of the tail

Htail_sections = strings(numel(Htail_section_chord),1);

% For loop names all of the section chords
for i = 1:numel(Htail_sections)

    if i < 10

        % Labels the section, for one-digit numbers
        Htail_sections(i) = sprintf('C%d--',i);

    elseif i >= 10

        % Labels the section, for two-digit numbers
        Htail_sections(i) = sprintf('C%d-',i);

    end

end % End of for loop

Htail_sections(1) = "root";
Htail_sections(end) = "tip-";

%% Defining the Tail C values


% For loop writes out each section properties in AVL
for i = 1:numel(Htail_sections)

    fprintf(fileID,"\n\n#\n");
    fprintf(fileID,"#---------%s----------------------------------------------------\n",Htail_sections(i));
    fprintf(fileID,"#   Xle         Yle         Zle         chord       angle\n");
    fprintf(fileID,"SECTION\n");
    fprintf(fileID,'    %7f    %7f    %7f    %7f    %7f\n\n',Htail_section_x(i),Htail_section_y(i),Htail_section_z(i),Htail_section_chord(i),Htail_section_alpha(i));

    fprintf(fileID,'AFIL\n');
    fprintf(fileID,"%s\n",Htail_airfoil_file);

end % End of for loop

%% Vertical Tail

fprintf(fileID,"\n#\n");
fprintf(fileID,"#========V-Stab======================================================\n");
fprintf(fileID,"#\n\n");

fprintf(fileID,"SURFACE\n");
fprintf(fileID,"V-Stab\n");
fprintf(fileID,"8  1.0  14  0.75  !  Nchord   Cspace   Nspan  Sspace\n");

% If the user would like to duplicate the Vertical Tail about the y-axis
% (used for U and V configurations)
if duplicate_Vtail

    fprintf(fileID,"# reflect image wing about y=0 plane\n");
    fprintf(fileID,"YDUPLICATE\n");
    fprintf(fileID,"     0.00000 \n");

end % end of If Statement

fprintf(fileID,"#\n");
fprintf(fileID,"# x,y,z bias for whole surface\n");
fprintf(fileID,"TRANSLATE\n");
fprintf(fileID,"    %7f    %7f    %7f\n",Vtail_location(1),Vtail_location(2),Vtail_location(3));

%% Defining the number of sections of the vertical tail

Vtail_sections = strings(numel(Htail_section_chord),1);

% For loop names all of the section chords
for i = 1:numel(Vtail_sections)

    if i < 10

        % Labels the section, for one-digit numbers
        Vtail_sections(i) = sprintf('C%d--',i);

    elseif i >= 10

        % Labels the section, for two-digit numbers
        Vtail_sections(i) = sprintf('C%d-',i);

    end

end % End of for loop

Vtail_sections(1) = "root";
Vtail_sections(end) = "tip-";

%% Defining the vertical Tail C values


% For loop writes out each section properties in AVL
for i = 1:numel(Htail_sections)

    fprintf(fileID,"\n\n#\n");
    fprintf(fileID,"#---------%s----------------------------------------------------\n",Vtail_sections(i));
    fprintf(fileID,"#   Xle         Yle         Zle         chord       angle\n");
    fprintf(fileID,"SECTION\n");
    fprintf(fileID,'    %7f    %7f    %7f    %7f    %7f\n\n',Vtail_section_x(i),Vtail_section_y(i),Vtail_section_z(i),Vtail_section_chord(i),0);

    fprintf(fileID,'AFIL\n');
    fprintf(fileID,"%s\n",Vtail_airfoil_file);

end % End of for loop


% #
% # reflect image wing about y=0 plane
% YDUPLICATE
%      0.00000    
% ')
%1.25  0  0     	    !   Xref   Yref   Zref   moment reference location (arb.)

%% Closing the avl file
fclose(fileID);
end

