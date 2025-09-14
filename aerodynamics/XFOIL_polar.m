function [pol, foil] = xfoil_polar(datFilename) 
% Generate aerodynamic polars programmatically using Louis Edelman's Xfoil
% Interface Updated
% (https://www.mathworks.com/matlabcentral/fileexchange/49706-xfoil-interface-updated)
% Created 0730 EST 17 August 2025 by Liam Trzebunia

airfoil_path = sprintf('airfoil_files/%s', datFilename);

% % change folder
% folder_name = 'aerodynamics';
% app_name = 'XFOIL6.99';
% eval(sprintf('cd %s/%s', folder_name, app_name)) 
[pol, foil] = xfoil(sprintf('../%s', airfoil_path), -5:0.25:10, 50000, 0.1);
% 
% system('.\xfoil'); % open xfoil 
% airfoil_path = sprintf('airfoil_files/%s', datFilename);
% eval(sprintf('load ../%s', airfoil_path));



%addpath C:\Users\liamt\OneDrive\Organized\Backups\Organized - Backup (July 2024)\Engineering\NCSU\Spring 2024\MAE 252\MAE 252 project\XFOIL 6.99 Win