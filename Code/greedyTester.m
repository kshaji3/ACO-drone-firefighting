clear all
close all
clc
tic; %start the program timer

%% Set File Names
fireDatasheet = '../data-manipulation/northeast-samples.xlsx';
sheetName = 'sheet9';
trialName = 'trial10';
regionName = 'northeast';

%% Set up parameters
environment.fires = createFires(fireDatasheet, sheetName);
droneNo = 5; %agents in CVRP
[drones] = createDrones(environment.fires, droneNo);
environment.netFireSum = sum(environment.fires.intensity);
drones.netDroneExtSum = sum(drones.capac);

%Create the graph
[graph] = createGraph(environment.fires.locX, environment.fires.locY, environment.fires.locZ);

%Draw the graph
graphFigures.fig1 = figure('Position', get(0, 'Screensize'));
subplot(2, 4, 1)
drawGraph(graph);
subplot(2, 4, 2);
drawGraphWithDrones(graph, drones);
bestTour = cell(1, droneNo);

%% Programming the algorithm

drones.uCapac = drones.capac;    
environment.fires.uIntensity = environment.fires.intensity;
droneIndex = 1;
environment.fires.uIntensity = environment.fires.intensity;
for i = 1: length(environment.fires.intensity)
    while (environment.fires.uIntensity(1, i) ~= 0)
        %drones with no fire extinguisher are not rerouted
        if (drones.uCapac <= 0.05)
            droneIndex = droneIndex + 1;
            %routing drones and setting new fire values for environment.fires that require
            %the drone to expend all of its fire extinguisher
            
        elseif (environment.fires.uIntensity(1, i) - drones.uCapac(1, droneIndex) > 0)
            bestTour{droneIndex} = [bestTour{droneIndex}, i + drones.uCapac(1, droneIndex)...
                / environment.fires.uIntensity(1, i)];
            environment.fires.uIntensity(1, i) = environment.fires.uIntensity(1, i) - drones.uCapac(1, droneIndex);
            drones.uCapac(1, droneIndex)  = 0;
            droneIndex = droneIndex + 1;
            
        %if the drone has fire extinguisher left after fighting one fire
        else
            drones.uCapac(1, droneIndex) = drones.uCapac(1, droneIndex) - environment.fires.uIntensity(1, i);
            if (environment.fires.intensity(1, i) == environment.fires.uIntensity(1, i))
                bestTour{droneIndex} = [bestTour{droneIndex}, i];
            else
                bestTour{droneIndex} = [bestTour{droneIndex}, i + environment.fires.uIntensity(1, i)...
                    / environment.fires.intensity(1, i)];
            end
            environment.fires.uIntensity(1, i) = 0;
        end
    end
end
figure;
for i = 1: droneNo
    drawGreedyBestTour(bestTour{1, i}, drones, i, graph);
end