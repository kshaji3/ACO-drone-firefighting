clc;
clear all;
close all;

sheetNamesRhoInput = {'0.4 rho', '0.5 rho', '0.6 rho', '0.7 rho', '0.8 rho'};
sheetNamesRhoOutput = {'0.4-rho', '0.5-rho', '0.6-rho', '0.7-rho', '0.8-rho'};
fileExt = '.xlsx';
fileName = '10-fires-aco-rho';

full_fileName = strcat(fileName, fileExt);
outputFileName = strcat(fileName, '-output', fileExt);
numRows = 5;
numCols = 10;

for i = 1: length(sheetNamesRhoInput)
    %category = zeros(numRows * numCols, 1);
    category = [];
    value = zeros(numRows * numCols, 1);
    t = table2array(readtable(full_fileName, 'sheet', sheetNamesRhoInput{i}, ...
            'Range', 'A1:J5'));
    for j = 1: numRows
        for k = 1: numCols
            category{(j - 1) * 10 + k, 1} = [sheetNamesRhoOutput{i}];
            value((j - 1) * 10 + k, 1) = t(j, k);
        end    
    end
    resTable = table(category, value);
    resTable(1, :) = [];
    if (i == 1)
        resTable2 = resTable;
    else
        resTable2 = [resTable2; resTable];
    end
    writetable(resTable, outputFileName,'Sheet', sheetNamesRhoOutput{i}, 'Range', 'A1');
end
writetable(resTable2, outputFileName,'Sheet', 'combined-output', 'Range', 'A1');




sheetNamesRhoInput = {'0.05 mutProb', '0.10 mutProb', '0.15 mutProb', '0.20 mutProb', '0.25 mutProb'};
sheetNamesRhoOutput = {'0.05-mutProb', '0.10-mutProb', '0.15-mutProb', '0.20-mutProb', '0.25-mutProb'};
fileExt = '.xlsx';
fileName = '10-fires-ga-mutProb';

full_fileName = strcat(fileName, fileExt);
outputFileName = strcat(fileName, '-output', fileExt);
numRows = 5;
numCols = 10;

for i = 1: length(sheetNamesRhoInput)
    %category = zeros(numRows * numCols, 1);
    category = [];
    value = zeros(numRows * numCols, 1);
    t = table2array(readtable(full_fileName, 'sheet', sheetNamesRhoInput{i}, ...
            'Range', 'A1:J5'));
    for j = 1: numRows
        for k = 1: numCols
            category{(j - 1) * 10 + k, 1} = [sheetNamesRhoOutput{i}];
            value((j - 1) * 10 + k, 1) = t(j, k);
        end    
    end
    resTable = table(category, value);
    resTable(1, :) = [];
    if (i == 1)
        resTable2 = resTable;
    else
        resTable2 = [resTable2; resTable];
    end
    writetable(resTable, outputFileName,'Sheet', sheetNamesRhoOutput{i}, 'Range', 'A1');
end
writetable(resTable2, outputFileName,'Sheet', 'combined-output', 'Range', 'A1');
