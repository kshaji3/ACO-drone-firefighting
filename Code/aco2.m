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
for i = 1: length(regionNames)
    for j = 1: numTrialsPerRegion
        environment.fires{i, j} = createFires(fireDataSheet{i}, sheetName{j});
        graph{i, j} = createGraph(environment.fires{i, j}.locX, environment.fires{i, j}.locY, environment.fires{i, j}.locZ);
    end
end
% [drones] = createDrones(environment.fires{1, 1}, droneNo);


%% Initial Parameters


environment.maxIter = 10; %1
iterations = 5;
for i = 1: iterations
    %cycle through for 10 - 50 ants
    
    droneNo = 5; %agents in CVRP
    for k = 1: length(regionNames)
        for j = 1: numTrialsPerRegion
            environment.fires{k, j} = createFires(fireDataSheet{k}, sheetName{j});
            graph{k, j} = createGraph(environment.fires{k, j}.locX, environment.fires{k, j}.locY, environment.fires{k, j}.locZ);
        end
    end
    for j = 1: length(regionNames)
        for k = 1: numTrialsPerRegion
            time(j, k) = aco3(graph{j, k}, environment, droneNo, 10 * i, j, k);
        end
    end
    tavg{i} = mean(time(:));
end



%% Format data output and store as excel files

%Convert to tables so we can set labels for row and columns
outputTable.droneColNames = string([1, droneNo]);
for i = 1: length(bestTour)
    colName = "Drone #" + num2str(i);
    outputTable.droneColNames(1, i) = colName;
end

outputTable.tourTable = cell2table(bestTour, 'VariableNames', outputTable.droneColNames);
outputTable.droneIntensityTable = array2table(drones.capac, 'VariableNames', outputTable.droneColNames);
outputTable.overallFitnessTable = array2table(drones.bestOverallFitness, 'VariableNames', outputTable.droneColNames);

%format the tables so we can save them in an excel file with multiple
%sheets
outputTable.fireColNames = string([1, length(environment.fires.locX)]);
for i = 1: length(environment.fires.locX)
    colName = "Fire #" + num2str(i);
    outputTable.fireColNames(1, i) = colName;
end
outputTable.fireIntensityTable = array2table(environment.fires.intensity, 'VariableNames', outputTable.fireColNames);
outputTable.rowName = "Time Elapsed";
outputTable.timeElapsedTable = array2table(timeElapsed, 'RowNames', outputTable.rowName);
outputTable.fileName = outputExcelName;
outputTable.sheetName = trialName;

writetable(outputTable.tourTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A1');
writetable(outputTable.droneIntensityTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A4');
writetable(outputTable.overallFitnessTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A7');
writetable(outputTable.fireIntensityTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A10');
writetable(outputTable.timeElapsedTable, outputTable.fileName, 'Sheet', outputTable.sheetName, 'Range', 'A13');

