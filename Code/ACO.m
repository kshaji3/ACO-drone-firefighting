clear all
close all
clc
tic; %start the program timer

%% Set File Names
trashDatasheet = '../data-manipulation/northeast-samples.xlsx';
sheetName = 'sheet9';
trialName = 'trial1';
regionName = 'northeast';
outputExcelName = strcat(trialName,'-', regionName, '-', 'data', '.xlsx');
outputToursName = strcat(trialName, '-', regionName, '-', 'tours', '.png');
outputBestToursName = strcat(trialName, '-', regionName, '-', 'best-tour', '.png');

%% Problem Preparation
%get the trashs and drones

environment.trashs = createtrashs(trashDatasheet, sheetName);
droneNo = 5; %agents in CVRP
[drones] = createDrones(environment.trashs, droneNo);
environment.nettrashSum = sum(environment.trashs.intensity);
drones.netDroneExtSum = sum(drones.capac);

%Create the graph
[graph] = createGraph(environment.trashs.locX, environment.trashs.locY, environment.trashs.locZ);

%Draw the graph
graphFigures.fig1 = figure('Position', get(0, 'Screensize'));
subplot(2, 4, 1)
drawGraph(graph);
subplot(2, 4, 2);
drawGraphWithDrones(graph, drones);

%% Initial Parameters
environment.maxIter = 10; %1
drones.antNo = 50; %5

drones.tau0 = 10 * 1 / (graph.n * mean(graph.edges(:) ) );
graph.eta = 1 ./ graph.edges; %edge desirability

%Start the process of creating a 3D tau matrix
drones.tau = drones.tau0 * ones(graph.n, graph.n);
for t = 1: droneNo - 1
    drones.tau(:,:,t + 1) = drones.tau0 * ones(graph.n, graph.n);
end

environment.rho = 0.5; % Evaporation rate 
environment.alpha = 1;  % Pheromone exponential parameters 
environment.beta = 1;  % Desirability exponetial parameter

%initial base conditions: extreme ones which the program will obviously
%beat
%purpose is to initialize all of the variables
drones.besttrashFitness = inf(1, droneNo);
drones.besttrashDist = zeros(1, droneNo); %best trash's distance

%stores individual trash fitness values
drones.besttrashFit1 = zeros(1, droneNo);
drones.besttrashFit2 = zeros(1, droneNo);
drones.besttrashFit3 = zeros(1, droneNo);
bestTour = {};
drones.colony = [];
drones.bestOverallFitness = zeros(1, droneNo); %datapoint that shows overall how ideal the whole solution is
drones.allUsedNodes = []; %keeps track of all the nodes that are visited
drones.bestSolutionsFound = zeros(1, droneNo); %check if best solutions are found



%% Main Loop of ACO


t = 1; %fenceposting

for d = 1: droneNo
    %create ants
    while t <= environment.maxIter && drones.bestSolutionsFound(d) ~= 1
        drones.colony = createColonies(t, graph, environment.trashs.intensity, drones.capac(d), ...
            d, drones.colony, drones.antNo, drones.tau(:,:,d), graph.eta, environment.alpha, environment.beta, drones.allUsedNodes);
        for k = 1: drones.antNo 
            %calculate fitnesses of all ants in a specific drone ant colony
            drones.colony(d).ant(k).distFitness = distFitnessFunction(drones, d, drones.colony(d).ant(k).tour,  graph);
            [trashOverall, trashFit1, trashFit2, trashFit3] = trashFitnessFunction(drones.colony(d).ant(k), drones.capac(d), droneNo, length(environment.trashs.locX));
            
            %stores variables into the colony struct.
            drones.colony(d).ant(k).trashFitness = trashOverall;
            drones.colony(d).ant(k).trashTotDiff = trashFit1;
            drones.colony(d).ant(k).trashEq = trashFit2;
            drones.colony(d).ant(k).trashInt = trashFit3;
        end
        
        %check if any of the ants offer a better solution than the ones
        %found already
        for k = 1: 1: drones.antNo
            if drones.besttrashFitness(1, d) > drones.colony(d).ant(k).trashFitness
                drones.besttrashFitness(1, d) = drones.colony(d).ant(k).trashFitness;
                bestTour{d} = drones.colony(d).ant(k).tour;
                drones.besttrashDist(1, d) = drones.colony(d).ant(k).distFitness;
                drones.besttrashFit1(1, d) = drones.colony(d).ant(k).trashTotDiff;
                drones.besttrashFit2(1, d) = drones.colony(d).ant(k).trashEq;
                drones.besttrashFit3(1, d) = drones.colony(d).ant(k).trashInt;
            else
            end
        end
    
        %Find the best ant of this colony
        drones.colony(d).queen.tour = bestTour{d};
        drones.colony(d).queen.trashTotDiff = drones.besttrashFit1(1, d);
        drones.colony(d).queen.trashEq = drones.besttrashFit2(1, d);
        drones.colony(d).queen.trashInt = drones.besttrashFit3(1, d);
        drones.colony(d).queen.trashFitness = drones.besttrashFitness(1, d);
%         
        %Update pheromone matrix
        drones.tau(:, :, d) = updatePheromone(drones.tau(:, :, d), drones.colony(d));
        
        %Evaporation
        drones.tau(:, :, d) = (1 - environment.rho) .* drones.tau(:, :, d);
        outmsg = ['Iteration = #', num2str(t), ' Drone = #' , num2str(d), ' Fitness = # ', num2str(drones.colony(d).queen.trashFitness(1, 1)) ];
        %enables for tracking of progress by displaying output.
        disp(outmsg)
        subplot(2, 4, 3)
        drawBestTour(drones.colony(d), drones, d, graph);
        title('Best Tour of Iteration # ', num2str(t))
        
        %Visualize best tour and pheromone concentration (for five drones)
        if (d < 6)
            subplot(2, 4, d + 3)
            cla
            drawPheromone(drones.tau(:, :, d), graph);
            drawnow
            title('Pheromones of Drone # ', num2str(d))
        else
        end
        
        %serves if the ultra ideal solution is found so that the code stops
        %iterating
        if drones.colony(d).queen.trashFitness == 0.01 && drones.bestSolutionsFound(d) == 0
           drones.bestSolutionsFound(d) = 1;      
        else
        end
        
        %another progress checking mechanism that gets cleared after every
        %iteration, with the final one for the last drone being the one
        %saved
        if t ~= environment.maxIter
            cla(subplot(2, 4, 3))
        else
        end
        t = t + 1;
    end
    
    %converts all the bestTour nodes to a matrix that denotes all the nodes
    %visited, which is used later
    drones.allUsedNodes = cell2mat(bestTour);
    t = 1;
    if length(drones.allUsedNodes) == length(environment.trashs.locX)
        break
    else
    end
end

%% Cooperative Search Part to Target Untargeted trashs

drones.allUnusedNodes = zeros(1, length(environment.trashs.intensity) - length(drones.allUsedNodes));
uCounter = 1;

%variable that denotes if less than 5 drones have been used for the
%particular problem
drones.actualNumberDronesUsed = length(bestTour);

%records all the nodes that have not been used, which is used for the
%cooperative solution finding
for i = 1: length(environment.trashs.intensity)
    if ~(ismembertol(i, drones.allUsedNodes))
        drones.allUnusedNodes(1, uCounter) = i;
        uCounter = uCounter + 1;
    else
    end
end

droneNumber = 1;
environment.trashs.uIntensity = zeros(1, length(drones.allUnusedNodes));
%records intensity of the trashs in the unused nodes
for i = 1: length(drones.allUnusedNodes)
    environment.trashs.uIntensity(1, i) = environment.trashs.intensity(drones.allUnusedNodes(1, i));
end


for i = 1: length(drones.allUnusedNodes)
    while (~(droneNumber > droneNo) && environment.trashs.uIntensity(1, i) ~= 0)
        %drones with no trash extinguisher are not rerouted
        if (drones.colony(droneNumber).queen.trashTotDiff <= 0.05)
            droneNumber = droneNumber + 1;
        %routing drones and setting new trash values for trashs that require
        %the drone to expend all of its trash extinguisher
        elseif (environment.trashs.uIntensity(1, i) - drones.colony(droneNumber).queen.trashTotDiff >= 0)    
            environment.trashs.uIntensity(1, i) = environment.trashs.uIntensity(1, i) - drones.colony(droneNumber).queen.trashTotDiff;
            drones.colony(droneNumber).queen.tour = [drones.colony(droneNumber).queen.tour, drones.allUnusedNodes(1, i)];
            bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i) + drones.colony(droneNumber).queen.trashTotDiff / environment.trashs.intensity(drones.allUnusedNodes(1, i))];
            drones.colony(droneNumber).queen.trashTotDiff = 0;
            droneNumber = droneNumber + 1;
        %if the drone has trash extinguisher left after fighting one trash
        else
            if (environment.trashs.uIntensity(1, i) == environment.trashs.intensity(drones.allUnusedNodes(1, i)))
                bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i)];
            else
                bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i)+ environment.trashs.uIntensity(1, i) / environment.trashs.intensity(drones.allUnusedNodes(1, i))]; %+ drones.colony(droneNumber).queen.trashTotDiff / environment.trashs.intensity(drones.allUnusedNodes(1, i))];
            end
            drones.colony(droneNumber).queen.trashTotDiff = drones.colony(droneNumber).queen.trashTotDiff - environment.trashs.uIntensity(1, i);
            environment.trashs.uIntensity(1, i) = 0;
            drones.colony(droneNumber).queen.tour = [drones.colony(droneNumber).queen.tour, drones.allUnusedNodes(1, i)];
        end
    end
end
subplot(2, 4, 4)
timeElapsed = toc;


%% Graph the Best Tour as a separate figure

%graph best tours
graphFigures.fig2 = figure('Position', get(0, 'Screensize'));

%Graph best tours for all drones that were used
for d = 1: drones.actualNumberDronesUsed
    drawBestTour(drones.colony(d), drones, d, graph);
    drones.bestOverallFitness(1, d) = drones.colony(d).queen.trashFitness;
end
title('Best Overall Tour of All Iterations')

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
outputTable.trashColNames = string([1, length(environment.trashs.locX)]);
for i = 1: length(environment.trashs.locX)
    colName = "trash #" + num2str(i);
    outputTable.trashColNames(1, i) = colName;
end
outputTable.trashIntensityTable = array2table(environment.trashs.intensity, 'VariableNames', outputTable.trashColNames);
outputTable.rowName = "Time Elapsed";
outputTable.timeElapsedTable = array2table(timeElapsed, 'RowNames', outputTable.rowName);
outputTable.fileName = outputExcelName;
outputTable.sheetName = trialName;

writetable(outputTable.tourTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A1');
writetable(outputTable.droneIntensityTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A4');
writetable(outputTable.overallFitnessTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A7');
writetable(outputTable.trashIntensityTable,outputTable.fileName,'Sheet', outputTable.sheetName, 'Range', 'A10');
writetable(outputTable.timeElapsedTable, outputTable.fileName, 'Sheet', outputTable.sheetName, 'Range', 'A13');

%save the figures used as png files in the project folder
saveas(graphFigures.fig1, outputToursName,'png');
saveas(graphFigures.fig2, outputBestToursName,'png');

