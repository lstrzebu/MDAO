fprintf('Generating Mission 2 variables from rules... ');
% declare Ip1, Ip2, Ic1, Ic2, Ce, Cp, Cc
M2_given_params = readcell("rules\M2_given_params.xlsx");
varNames = M2_given_params(:, 2);
varSyms = M2_given_params(:, 3);
[thisVar, ~] = size(M2_given_params);
for i = 1:thisVar
    eval(sprintf("%s = %d;", varNames{i}, varSyms{i}));
end
fprintf('done \n');