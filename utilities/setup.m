% Execute one-time actions (e.g., reading motor table data) at the
% beginning of MDAO, prior to loops
% Liam Trzebunia
% 12 October 2025

constants.g.value = 9.81;
constants.g.units = 'm/s^2';
constants.g.description = "approximate gravitational acceleration at surface of Earth";

constants.wing.max_num_fasteners.value = 14;
constants.wing.max_num_fasteners.units = '';
constants.wing.max_num_fasteners.type = "non";
constants.wing.max_num_fasteners.description = "maximum number of fasteners we are willing to consider (otherwise, over a large number of guesses and checks, MDAO might optimize by finding the one constraint we didn't set (i.e. fasteners) and maxxing it out)";

cd .\output
filename = "rejected_missions.csv";
fid = fopen(filename, 'w');
column_titles = ["Aircraft Designator (Design Number)";
    "Passengers (Ducks)";
    "Cargo (Pucks)"; 
    "Laps";
    "Banner Length (inches)";
    "Battery"; 
    "Failure Message";
    "Propeller"];
fprintf(fid, '%s,', column_titles);
fclose(fid);

filename = "accepted_missions.csv";
fid = fopen(filename, 'w');
column_titles = ["Aircraft Designator (Design Number)";
    "Passengers (Ducks)";
    "Cargo (Pucks)"; 
    "Laps";
    "Banner Length (inches)";
    "Battery"; 
    "Projected Overall Competition Score";
    "Propeller"];
fprintf(fid, '%s,', column_titles);
fclose(fid);
cd ..
