clear all
close all
clc
tic; %start the program timer

%% Set File Names

regionNames = {'northwest', 'northeast', 'pascascades', 'southpuget', 'southeast'};
fileStoreLoc = '../data-manipulation/';
fireDataSheet = strcat(fileStoreLoc, regionNames, '-samples', '.xlsx');
numTrialsPerRegion = 10;
for i = 1: numTrialsPerRegion
    sheetName{i} = strcat('sheet', num2str(i - 1));
end

%% Problem Preparation
%get the fires and drones

droneNo = 5; %agents in CVRP

%% Initial Parameters

environment.maxIter = 10; %1
mutationProb = 0.05;
iterations = 5;
popSize = 10;
for i = 1: iterations
    %cycle through for 10 - 50 ants
%     popSize = 10 * i;
    mutationProb = 0.05 * i;
    droneNo = 5; %agents in CVRP
    for k = 1: length(regionNames)
        for j = 1: numTrialsPerRegion
            environment.fires{k, j} = generateCities(fireDataSheet{k}, sheetName{j});
            graph{k, j} = createGraph(environment.fires{k, j}.loc(1,:), ...
                environment.fires{k, j}.loc(2,:), environment.fires{k, j}.loc(3,:));
        end
    end
    for j = 1: length(regionNames)
        for k = 1: numTrialsPerRegion
            time(j, k) = fncGA(graph{j, k}, environment, droneNo, popSize, ...
                environment.maxIter, mutationProb, j, k);
        end
    end
    totalTimeTable{i} = time;
    tavg{i} = mean(time(:));
end



%% Format data output and store as excel files
sheetNames = {'0.05 mutProb', '0.10 mutProb', '0.15 mutProb', '0.20 mutProb', ...
    '0.25 mutProb'}
outputFileName = '../Data-Analysis/50-fires-ga-mutProb.xlsx';

% outputFileName = '../Data-Analysis/50-fires-ga-pop.xlsx';
% sheetNames = {'10 pop', '20 pop', '30 pop', '40 pop', '50 pop'}


for i = 1: iterations
    writematrix(totalTimeTable{i},outputFileName,'Sheet', sheetNames{i}, 'Range', 'A1');
end
