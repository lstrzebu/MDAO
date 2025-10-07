function [] = WriteBatchFile(file_name)
%WRITEBATCHFILE Summary of this function goes here
%   Detailed explanation goes here


% Creates .avl file
fileID = fopen(sprintf("%s.bat",file_name), "wt");

% General properties
fprintf(fileID,'@echo off\n');
fprintf(fileID,'del %s.out\n',file_name);
fprintf(fileID,'del %s.eig\n',file_name);
fprintf(fileID,'avl < %s.run',file_name);

fclose(fileID);

% Creates run file
fileID2 = fopen(sprintf("%s.run",file_name), "wt");

% Writing the run file
fprintf(fileID2,'LOAD\n');
fprintf(fileID2,'%s.avl\n',file_name);
fprintf(fileID2,'MASS\n');
fprintf(fileID2,'%s.mass\n',file_name);

fprintf(fileID2,'MSET\n0\nOPER\nA PM 0\nX\nst\n');

fprintf(fileID2,'%s.out\n',file_name);

fprintf(fileID2,'c1\n\n\n');


fprintf(fileID2,'MODE\n');
fprintf(fileID2,'n\n');
fprintf(fileID2,'w\n');
fprintf(fileID2,'%s.eig\n\n',file_name);
fprintf(fileID2,'quit');

fclose(fileID2);


end

