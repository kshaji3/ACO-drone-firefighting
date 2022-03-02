clc;
clear all;
close all;

%Get file names
regionNames = {'northwest', 'northeast', 'pascascades', 'southpuget', 'southeast'};
fileStoreLoc = '../data-manipulation/';
fireDataSheet = strcat(fileStoreLoc, regionNames, '-samples', '.xlsx');
numTrialsPerRegion = 10;
for i = 1: numTrialsPerRegion
    sheetName{i} = strcat('sheet', num2str(i - 1));
end


for i = 1: length(regionNames)
    for j = 1: numTrialsPerRegion
        environment.fires{i, j} = createFires(fireDataSheet{i}, sheetName{j});
        graph{i, j} = createGraph(environment.fires{i, j}.locX, environment.fires{i, j}.locY, environment.fires{i, j}.locZ);
    end
end
droneNo = 5;
%% Cycle through for 50 fires
for i = 1: length(regionNames)
    for j = 1: numTrialsPerRegion
        time(i, j) = greedySolver(graph{i, j}, environment.fires{i, j}, droneNo, i, j);
    end
end

