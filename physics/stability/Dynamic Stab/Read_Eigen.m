function [Phugoid,Dutch_roll,SPO,Spiral,Roll,failure] = Read_Eigen(file_name)
%EIGENANALYSIS Summary of this function goes here
%
%
%OUTPUTS
%
%   Phugoid     -   The phugoid mode, in the form of {A + Bi}
%
%   Dutch_roll  -   The Dutch Roll mode, in the form of {A + Bi}
%   
%   SPO         -   The SPO mode, in the form of {A + Bi}
%   
%   Spiral      -   The spiral mode, in the form of {A}
%   
%   Rolling     -   The rolling mode, in the form of {A}
%
%   Failure     -   Boolean 1 or 0 value determining whether the dynamic
%                   modes are behaving unpredictably, indicating a
%                   dynamically unstable aircraft

ID = fopen(sprintf('%s.eig',file_name), "r");

% Scans the eigenvalue document and stores the lines into a cell array
brog = textscan(ID,'%s',Delimiter='\n');
brog = brog{1};

fclose(ID);


% Removes all of the non-eigenvalues from the cell array
eigenvalues = brog(~contains(brog,'#'));

% Preallocates a vector to store all of the eigenvalues
total_eigenvalues = zeros(numel(eigenvalues),2);

% For loop runs through the cell array of eigenvalues and converts it to a
% char array
for i = 1:numel(eigenvalues)

    % Breaks the current line into three parts, using spaces as delimiter
    current_eigenvalue = textscan(eigenvalues{i},'%s',Delimiter=' ');

    % Removes 0x0 cell arrays generated from textscan
    current_eigenvalue = rmmissing(current_eigenvalue{1});

    % The first element of the cell array just reads "1", and it is
    % irrelevant to the eigenvalues. This gets rid of it
    current_eigenvalue = current_eigenvalue(2:end);

    % Stores the resulting real and imaginary parts into total_eigenvalues
    total_eigenvalues(i,1) = str2double(current_eigenvalue{1});
    total_eigenvalues(i,2) = str2double(current_eigenvalue{2});

end % End of for loop

non_oscillating_eigenvalues = total_eigenvalues(total_eigenvalues(:,2)==0);

oscillating_eigenvalues     = total_eigenvalues(~(total_eigenvalues(:,2)==0),:);


% Removing the repeating values of the eigenvalues (+- i)
unique_osc_eigenvalues(:,1) = unique(oscillating_eigenvalues(:,1),'stable');
unique_osc_eigenvalues(:,2) = unique(abs(oscillating_eigenvalues(:,2)),'stable');

oscillating_eigenvalues = unique_osc_eigenvalues;


% Tests if the modes make sense
if numel(non_oscillating_eigenvalues)==2 && numel(oscillating_eigenvalues)==6

    failure = false;

    % Finds the phugoid mode. The phugoid will always have the smallest
    % imaginary value magnitude
    Phugoid_index   = abs(oscillating_eigenvalues(:,2))==min(abs(oscillating_eigenvalues(:,2)));
    Phugoid = oscillating_eigenvalues(Phugoid_index,:);
    
    % Finds the SPO mode. The SPO will always have the largest real value
    % magnitude
    SPO_index       = abs(oscillating_eigenvalues(:,1))==max(abs(oscillating_eigenvalues(:,1)));
    SPO     = oscillating_eigenvalues(SPO_index,:);
    
    % Finds the Dutch Roll mode. The Dutch roll is selected by method of
    % elimination
    Dutch_roll_index = ~(Phugoid_index + SPO_index);
    Dutch_roll = oscillating_eigenvalues(Dutch_roll_index,:);
    
    % Finds the Spiral mode. Spiral mode has the smallest magnitude of the
    % non-oscillatory modes
    Spiral_index = abs(non_oscillating_eigenvalues)==min(abs(non_oscillating_eigenvalues));
    Spiral = non_oscillating_eigenvalues(Spiral_index);
    
    % Finds the rolling mode. The rolling mode will always have the largest
    % magnitude of the non-oscillatory modes
    Roll_index = abs(non_oscillating_eigenvalues)==max(abs(non_oscillating_eigenvalues));
    Roll = non_oscillating_eigenvalues(Roll_index);

else % If the modes do not make sense
    
    failure = true;

    Phugoid = 0;

    SPO = 0;

    Dutch_roll = 0;

    Spiral = 0;

    Roll = 0;

end % End of if statement

end % End of function

