function [I_tot,m_tot,cg_tot] = InertiaCalc(CG_locations,masses,I_matrices)
%INERTIACALC - Finds the total center of mass and collective moment of
%              inertia of a list of parts
%   - INPUTS:
%
%       CG_locations        -   Location of the CG of each part [x;y;z]
%                               (CELL ARRAY)
%
%       masses              -   Mass of each part
%                               (CELL ARRAY)
%
%       I_matrices          -   Cell array containing the Inertia Matrix
%                               for each part
%                               (CELL ARRAY)
%


% Defines an initial point to start from. This allows the loop to run
% consistently every time.
P_cm_assem  = [0;0;0];

I_assem     = [0,0,0;0,0,0;0,0,0];

m_assem     = 0;


% For loop takes a current assembly, adds one of the I, CG, and mass values
% from inputs, and then defines a new assembly with I, CG, and mass value.
% Repeats for every element in I_matrices
for i = 1:numel(I_matrices)

    % Defines the properties of the current part
    P_cm_part   = CG_locations{i};
    [~,c] = size(P_cm_part);
    if c == length(P_cm_part)
        P_cm_part = P_cm_part'; % CG is inputted from main MDAO framework as a row vector, but this script expects it as a column vector. Transposing outside the function is not trivial due to cell array mechanics. 
    end
    I_part      = I_matrices{i};
    m_part      = masses{i};

    % Finds the mass of the combined part + assembly
    m_new       = m_assem + m_part;


    % Finds the cg location of the combined part + assembly
    P_cm_new    = ((P_cm_assem.*m_assem) + (P_cm_part.*m_part))./m_new;


    % Finds the change in location when assembly is moved to new CG
    delta_assem = P_cm_new - P_cm_assem;

    % Finds the change in location when assembly is moved to new CG
    delta_part  = P_cm_new - P_cm_part;


    % Uses the parallel axis theorem to define moments of inertia at new CG
    I_trans_assem = I_assem + m_assem.*(dot(delta_assem,delta_assem) * eye(3) - (delta_assem * delta_assem.'));
    I_trans_part  = I_part + m_part.*(dot(delta_part,delta_part) * eye(3) - (delta_part * delta_part.'));


    % Defines the new assembly to include the part, effictively absorbing
    % the part into the assembly
    P_cm_assem  = P_cm_new;
    I_assem     = I_trans_assem + I_trans_part;
    m_assem     = m_new;


    % The iteration of the loop has now completed. An assembly and part
    % were combined into a new assembly with its own I, CM, and mass. The
    % loop will run once for each part inputted to the function. On the
    % first iteration, the assembly starts empty and finishes containing 1
    % part

end % End of for loop


% Since the assem values are not going to be iterated any further, they are
% equal to the final values output by this function

% NOTE: The inertia matrix calculated here containes the negatives of the
% product moments of inertia (Ixy,Iyz,Ixz). This is because, for stability,
% Ixz is defined as the positive integral of xy dm, while the elements in
% the inertia tensor are defined as the negative integral.

% EXAMPLE: Ixy = -1 * I_tot(1,2)
I_tot  = I_assem;

m_tot  = m_assem;
cg_tot = P_cm_assem;


end

