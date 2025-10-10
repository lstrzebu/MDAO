% Retrieve the battery capacities of all available batteries being sampled
% for MDAO
% Liam Trzebunia
% 10 October 2025
function opts = getBattCapOptions(numBatt)
% numBatt is the number of batteries considered 

opts = zeros([1 numBatt]); % preallocate

for batteryIndx = 1:numBatt
    % Read Battery Spreadsheet
    batteryTable = readmatrix('6S Battery Data Condensed');
    opts(batteryIndx) = batteryTable(batteryIndx, 7);
end

end
