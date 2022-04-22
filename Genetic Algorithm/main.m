clear;
clc;
close all;
global gNumber;

%% Set file names
fireDatasheet = '../data-manipulation/northeast-samples.xlsx';
sheetName = 'sheet7';
trialName = 'trial1';
regionName = 'northeast';
outputExcelName = strcat(trialName,'-', regionName, '-', 'data', '.xlsx');
outputToursName = strcat(trialName, '-', regionName, '-', 'tours', '.png');
outputBestToursName = strcat(trialName, '-', regionName, '-', 'best-tour', '.png');

%% Problem Preparation

tStart = tic;
droneNum = 5;
environment.fires = generateCities(fireDatasheet, sheetName);
[drones] = createDrones(environment.fires, droneNum);
environment.netFireSum = sum(environment.fires.intensity);
drones.netDroneExtSum = sum(drones.capac);
bestPathSoFar = Inf; 
[graph] = createGraph(environment.fires.loc(1,:), environment.fires.loc(2,:)...
    , environment.fires.loc(3,:));

%% Initial Parameters
% Calculating distances between cities according to created city locations.
distances = calculateDistance(environment.fires.loc);
drones.popSize = 100;
drones.crossoverProbability = 0.9;
drones.mutationProbability = 0.05;
generationNumber = 50;
drones.cluster = [];
drones.allUsedNodes = [];
% 
% for d = 1: droneNum
%     % Generate population with random paths.
%     drones.cluster = population(drones.popSize, environment.fires.intensity, drones.allUsedNodes...
%         , d, drones.capac(d), drones.cluster);
%     %nextGeneration = zeros(popSize,numberOfCities);
% end


bestFitness = Inf;

%Keeping track of minimum paths through every iteration.
%minPathes = zeros(generationNumber,1);
blockedPaths = [];
% Genetic algorithm itself.
for d = 1: droneNum
    drones.cluster = population(drones.popSize, environment.fires.intensity, drones.allUsedNodes...
        , d, drones.capac(d), drones.cluster);
    gN = 1;
    bestFitness = Inf;
    isConverged = 0;
    while (gN < generationNumber && isConverged ~= 3)
        for k = 1: drones.popSize
            drones.cluster(d).pop(k).fireFitness = fireFitnessFunction(...
                drones.cluster(d).pop(k), drones.capac(d), droneNum, ...
                length(environment.fires.intensity));
        end
        tournamentSize=4;
        for k=1: drones.popSize
            % Choosing parents for crossover operation bu using tournament approach.
            tournamentPopFitnesses=zeros( tournamentSize,1);
            for j = 1:tournamentSize
                randomRow = randi(drones.popSize);
                tournamentPopFitnesses(j,1) = drones.cluster(d).pop(randomRow).fireFitness;
            end
            parent1  = min(tournamentPopFitnesses);
            
            %following line necessary as the array of structures isn't
            %conducive to the find command
            tempStorage = struct2table(drones.cluster(d).pop);
            [parent1X,parent1Y] = find(tempStorage.fireFitness == parent1, 1,...
                'first');
            
            parent1Path = drones.cluster(d).pop(parent1X).tour;
            x = 9;
            for j = 1: tournamentSize;
                randomRow = randi(drones.popSize);
                tournamentPopFitnesses(j,1) = drones.cluster(d).pop(randomRow).fireFitness;
            end

            parent2  = min(tournamentPopFitnesses);
            
            %following line necessary as the array of structures isn't
            %conducive to the find command
            [parent2X,parent2Y] = find(tempStorage.fireFitness == parent2, 1,...
                'first');
            parent2Path = drones.cluster(d).pop(parent2X).tour;
            childPath = crossover(parent1Path, parent2Path, drones.crossoverProbability, ...
                drones, environment.fires, d);
            childPath = mutate(childPath, drones.mutationProbability);
            
            
            nextGeneration{k,:} = childPath(1,:);
            nextGenPathInts = [];
            
            %create array that I can then embed into the cell
            %keeps the data structue usage consistent
            for m = 1: length(childPath)
                nextGenPathInts = [nextGenPathInts, environment.fires.intensity(childPath(m))];
            end
            
            %this enables for fire intensity arrays to be stored
            nextGenPathIntCell{k,:} = nextGenPathInts(1,:);
        end
%         fprintf('Minimum path in %d. generation: %f \n', gN, minPath);
        gNumber = gN;
        for k = 1: drones.popSize
            drones.cluster(d).pop(k).tour = cell2mat(nextGeneration(k));
            drones.cluster(d).pop(k).fires = cell2mat(nextGenPathIntCell(k));
            drones.cluster(d).pop(k).fireSum = sum(drones.cluster(d).pop(k).fires);
        end
        [bestTour{d}, indexBest(d)] = findBestTour(drones.cluster(d), drones.popSize);
        bestFitness1 = drones.cluster(d).pop(indexBest(d)).fireFitness;
        if (bestFitness == bestFitness1)
            isConverged = isConverged + 1;
        else
            isConverged = 0;
        end
        bestFitness = bestFitness1;
    end
    for k = 1: drones.popSize
        drones.cluster(d).pop(k).fireFitness = fireFitnessFunction(...
            drones.cluster(d).pop(k), drones.capac(d), droneNum, ...
            length(environment.fires.intensity));
    end
    [bestTour{d}, indexBest(d)] = findBestTour(drones.cluster(d), drones.popSize);
    remainingFireExtinguisher(d) = drones.capac(d) - drones.cluster(d).pop(indexBest(d)).fireSum;
    drones.allUsedNodes = [drones.allUsedNodes, bestTour{d}];
end


%% Cooperative Search Part to Target Untargeted trashs

drones.allUnusedNodes = zeros(1, length(environment.fires.intensity) - length(drones.allUsedNodes));
uCounter = 1;

%variable that denotes if less than 5 drones have been used for the
%particular problem
drones.actualNumberDronesUsed = length(bestTour);

%records all the nodes that have not been used, which is used for the
%cooperative solution finding
for i = 1: length(environment.fires.intensity)
    if ~(ismembertol(i, drones.allUsedNodes))
        drones.allUnusedNodes(1, uCounter) = i;
        uCounter = uCounter + 1;
    else
    end
end

droneInd = 1;
environment.fires.uIntensity = zeros(1, length(drones.allUnusedNodes));
%records intensity of the trashs in the unused nodes
for i = 1: length(drones.allUnusedNodes)
    environment.fires.uIntensity(1, i) = environment.fires.intensity(drones.allUnusedNodes(1, i));
end

%needs work from here - 4/15
for i = 1: length(drones.allUnusedNodes)
    while (~(droneInd > droneNum) && environment.fires.uIntensity(1, i) ~= 0)
        %drones with no trash extinguisher are not rerouted
        indTotDiff(droneInd) = drones.capac(droneInd) - drones.cluster(droneInd).pop(indexBest(droneInd)).fireSum;
        if (indTotDiff(droneInd) <= 0.05)
            droneInd = droneInd + 1;
        %routing drones and setting new trash values for trashs that require
        %the drone to expend all of its trash extinguisher
        elseif (environment.fires.uIntensity(1, i) - indTotDiff >= 0)    
            environment.fires.uIntensity(1, i) = environment.fires.uIntensity(1, i) - indTotDiff(droneInd);
            drones.cluster(droneInd).pop(indexBest(droneInd)).tour = ...
                [drones.cluster(droneInd).pop(indexBest(droneInd)).tour, drones.allUnusedNodes(1, i)];
            bestTour{droneInd} = [bestTour{droneInd}, drones.allUnusedNodes(1, i) ...
                + indTotDiff(droneInd) / environment.fires.intensity(drones.allUnusedNodes(1, i))];
            indTotDiff(droneInd) = 0;
            droneInd = droneInd + 1;
        %if the drone has trash extinguisher left after fighting one trash
        else
            if (environment.fires.uIntensity(1, i) == environment.fires.intensity(drones.allUnusedNodes(1, i)))
                bestTour{droneInd} = [bestTour{droneInd}, drones.allUnusedNodes(1, i)];
            else
                bestTour{droneInd} = [bestTour{droneInd}, drones.allUnusedNodes(1, i)...
                    + environment.fires.uIntensity(1, i) / environment.fires.intensity(drones.allUnusedNodes(1, i))]; %+ drones.colony(droneNumber).queen.trashTotDiff / environment.trashs.intensity(drones.allUnusedNodes(1, i))];
            end
            indTotDiff(droneInd) = indTotDiff(droneInd) - environment.fires.uIntensity(1, i);
            environment.fires.uIntensity(1, i) = 0;
            drones.cluster(droneInd).pop(indexBest(droneInd)).tour = [drones.cluster(droneInd).pop(indexBest(droneInd)).tour, drones.allUnusedNodes(1, i)];
        end
    end
end

%% Graph the Best Tour as a separate figure

%graph best tours
graphFigures.fig2 = figure('Position', get(0, 'Screensize'));

%Graph best tours for all drones that were used
for d = 1: drones.actualNumberDronesUsed
    drawBestTour(bestTour{d}, drones, d, graph);
end
title('Best Overall Tour of All Iterations')
