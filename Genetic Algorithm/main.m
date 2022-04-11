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

%% Initial Parameters
% Calculating distances between cities according to created city locations.
distances = calculateDistance(environment.fires.loc);
drones.popSize = 100;
drones.crossoverProbability = 0.9;
drones.mutationProbability = 0.05;
generationNumber = 10;
drones.cluster = [];
drones.allUsedNodes = [];
% 
% for d = 1: droneNum
%     % Generate population with random paths.
%     drones.cluster = population(drones.popSize, environment.fires.intensity, drones.allUsedNodes...
%         , d, drones.capac(d), drones.cluster);
%     %nextGeneration = zeros(popSize,numberOfCities);
% end




%Keeping track of minimum paths through every iteration.
%minPathes = zeros(generationNumber,1);
blockedPaths = [];
% Genetic algorithm itself.
for d = 1: droneNum
    drones.cluster = population(drones.popSize, environment.fires.intensity, drones.allUsedNodes...
        , d, drones.capac(d), drones.cluster);
    for gN = 1: generationNumber
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
                drones, environment, d);
            childPath = mutate(childPath, drones.mutationProbability);
            nextGeneration{k,:} = childPath(1,:);
%             minPaths(gN,1) = minPath; 
        end
%         fprintf('Minimum path in %d. generation: %f \n', gN, minPath);
        gNumber = gN;
        for k = 1: drones.popSize
            drones.cluster(d).pop(k).tour = cell2mat(nextGeneration(k));
        end
    end
    [bestTour{d}, indexBest] = findBestTour(drones.cluster(d), drones.popSize);
    remainingFireExtinguisher(d) = drones.capac(d) - drones.cluster(d).pop(indexBest).fireSum;
    drones.allUsedNodes = [drones.allUsedNodes, bestTour{d}];
end
