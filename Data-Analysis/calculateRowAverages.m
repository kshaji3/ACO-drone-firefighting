clc;
clear all;
close all;

fileExt = '.xlsx';
%fileName = '10-fires-aco-rho';
%sheetNames = {'0.4 rho', '0.5 rho', '0.6 rho', '0.7 rho', '0.8 rho'};
%fileName = '10-fires-ga-pop';
%sheetNames = {'10 pop', '20 pop', '30 pop'}

sheetNames = {'0.05 mutProb', '0.10 mutProb', '0.15 mutProb', '0.20 mutProb', '0.25 mutProb'};
fileName = '10-fires-ga-mutProb';

full_fileName = strcat(fileName, fileExt);

numFiles = 5;
for j = 1: numFiles
    for i = 1: length(sheetNames)
        t = table2array(readtable(full_fileName, 'sheet', sheetNames{i}, ...
            'Range', 'A1:J5'));
        netNumVals = length(t(1,:)) * length(t(:, 1)) - 1;
        averages{j, i} = (sum(t(:)) - t(1,1)) / netNumVals;
    end
    full_fileName = strrep(full_fileName, num2str(j), num2str(j + 1));
    
end
