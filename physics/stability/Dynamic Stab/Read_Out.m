% function [X_NP,C_L0,C_D0,alpha_trim_FRL,C_Zw,C_Yw,C_lw,C_mw,C_nw,C_Zv,C_Yv,C_lv,C_mv,C_nv,C_Zp,C_Yp,C_lp,C_mp,C_np,C_Zq,C_Yq,C_lq,C_mq,C_nq,C_Zr,C_Yr,C_lr,C_mr,C_nr,efficiency_factor, fileExistence] = Read_Out(file_name)
%READ_OUT Reads your balsa.out file and produces the stability derivatives
%from it.

if isfile(sprintf('%s.out', file_name))
    fileExistence = true;

ID = fopen(sprintf('%s.out',file_name), "r");

bog = textscan(ID,'%s',Delimiter='\n');
bog = bog{1};


% Closes the file for reading
fclose(ID);



list_dervs = zeros(1,25);

% Reads the first part of the output file

% Finds the location of the stability-axis derivative output
Stab_index = find(strcmp(bog,'Stability-axis derivatives...'));

% Moves the index up by 4. Otherwise, it would start by scanning the title
% and fancy formatting
Stab_index = Stab_index + 4;

for i = Stab_index:(Stab_index + 4)

    current_dervs = textscan(bog{i},'%s','Delimiter',{' = ','    '});
    current_dervs = rmmissing(str2double(current_dervs{1}));

    list_dervs(2*(i - Stab_index) + 1) = current_dervs(1);
    list_dervs(2*(i - Stab_index) + 2) = current_dervs(2);

end

% Finds the index of the latest item added to list_dervs
final_bog_index = 2*i - 2*Stab_index + 2;

% Moves the Stab_index to start at the next set of derivatives
Stab_index = Stab_index + 8;

% Reads the second part of the output file
for j = Stab_index:Stab_index + 4

    current_dervs = textscan(bog{j},'%s','Delimiter',{' = ','    '});
    current_dervs = rmmissing(str2double(current_dervs{1}));

    list_dervs(final_bog_index + 3*(j-Stab_index) + 1) = current_dervs(1);
    list_dervs(final_bog_index + 3*(j-Stab_index) + 2) = current_dervs(2);
    list_dervs(final_bog_index + 3*(j-Stab_index) + 3) = current_dervs(3);

end

C_Zw = list_dervs(1);
C_Zv = list_dervs(2) * (180/pi); % converted to 1/radians

C_Yw = list_dervs(3) * (180/pi); % converted to 1/radians
C_Yv = list_dervs(4) * (180/pi); % converted to 1/radians

C_lw = list_dervs(5) * (180/pi); % converted to 1/radians
C_lv = list_dervs(6) * (180/pi); % converted to 1/radians

C_mw = list_dervs(7);
C_mv = list_dervs(8) * (180/pi); % converted to 1/radians

C_nw = list_dervs(9) * (180/pi); % converted to 1/radians
C_nv = list_dervs(10) * (180/pi); % converted to 1/radians

C_Zp = list_dervs(11) * (180/pi); % converted to 1/radians
C_Zq = list_dervs(12) * (180/pi); % converted to 1/radians
C_Zr = list_dervs(13) * (180/pi); % converted to 1/radians

C_Yp = list_dervs(14) * (180/pi); % converted to 1/radians
C_Yq = list_dervs(15) * (180/pi); % converted to 1/radians
C_Yr = list_dervs(16) * (180/pi); % converted to 1/radians

C_lp = list_dervs(17) * (180/pi); % converted to 1/radians
C_lq = list_dervs(18) * (180/pi); % converted to 1/radians
C_lr = list_dervs(19) * (180/pi); % converted to 1/radians

C_mp = list_dervs(20) * (180/pi); % converted to 1/radians
C_mq = list_dervs(21) * (180/pi); % converted to 1/radians
C_mr = list_dervs(22) * (180/pi); % converted to 1/radians

C_np = list_dervs(23) * (180/pi); % converted to 1/radians
C_nq = list_dervs(24) * (180/pi); % converted to 1/radians
C_nr = list_dervs(25) * (180/pi); % converted to 1/radians

C_L0_line = textscan(bog{contains(bog,'CLtot')},'%s','Delimiter',{' = ','    '});
C_L0 = str2double(C_L0_line{1}{2});
aircraft.missions.mission(missionNumber).CL_trim.value(iii) = C_L0; 
thisS = S(iii); % m^2
thisRho = aircraft.missions.mission(missionNumber).weather.air_density.value(iii); % kg/m^3
thisW = mass(iii)*9.81; % convert mass to weight
aircraft.missions.mission(missionNumber).v_trim.value(iii) = sqrt((2*thisW)/(thisRho*thisS*C_L0)); % m/s

C_D0_line = textscan(bog{contains(bog,'CDtot')},'%s','Delimiter',{' = ','    '});
C_D0 = str2double(C_D0_line{1}{2});

e_line = textscan(bog{contains(bog,' e =')},'%s','Delimiter',{' = ','    '});
Effe = rmmissing(str2double(e_line{1}));
efficiency_factor = Effe(2);

a_line = textscan(bog{contains(bog,'Alpha =')},'%s','Delimiter',{' = ','    '});
alfaf = rmmissing(str2double(a_line{1}));
alpha_trim_FRL = alfaf(1); % degrees according to online search
aircraft.missions.mission(missionNumber).alpha_trim.value(iii) = alpha_trim_FRL;

X_NP_line = textscan(bog{contains(bog,'Xnp =')},'%s','Delimiter',{' = ','    '});
X_NP = rmmissing(str2double(X_NP_line{1}));
else
    fileExistence = false; % likely due to an overly large angle of trim

end

% end

