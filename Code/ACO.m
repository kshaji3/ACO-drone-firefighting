clear all
clc
%% Problem Preparation
%get the fires and drones
fires = createFires();
droneNo = 5; %agents in CVRP
[drones] = createDrones(fires, droneNo);
netFireSum = sum(fires.intensity);
netDroneExtSum = sum(drones.capac);

%Create the graph
[graph] = createGraph(fires.locX, fires.locY, fires.locZ);

%Draw the graph
figure
subplot(2, 4, 1)
drawGraph(graph);
subplot(2, 4, 2);
drawGraphWithDrones(graph, drones);

%% Initial Parameters
maxIter = 10; %1
antNo = 50; %5

tau0 = 10 * 1 / (graph.n * mean(graph.edges(:) ) );
eta = 1 ./ graph.edges; %edge desirability

%Start the process of creating a 3D tau matrix
tau = tau0 * ones(graph.n, graph.n);
for t = 1: 1: droneNo - 1
    tau(:,:,t + 1) = tau0 * ones(graph.n, graph.n);
end

rho = 0.5; % Evaporation rate 
alpha = 1;  % Pheromone exponential parameters 
beta = 1;  % Desirability exponetial paramter
%% Main Loop of ACO

%initial base conditions
bestFireFitness = inf(1, droneNo);
bestFireDist = zeros(1, droneNo); %best fire's distance
bestFireFit1 = zeros(1, droneNo);
bestFireFit2 = zeros(1, droneNo);
bestFireFit3 = zeros(1, droneNo);

bestTour = {};
colony = [];
bestOverallFitness = 0;
t = 1;
allUsedNodes = [];
bestSolutionsFound = zeros(1, droneNo) %check if best solutions are found
% && bestOverallFitness ~= (0.01 * droneNo)
actualNumberDronesUsed = 0;
for d = 1: droneNo

    tempFitness = 0;
    %create ants
    while t <= maxIter && bestSolutionsFound(d) ~= 1
        colony = createColonies(t, graph, fires.intensity, drones.capac(d), d, colony, antNo, tau(:,:,d), eta, alpha, beta, allUsedNodes);
        for k = 1: antNo 
            %calculate fitnesses of all ants in a specific drone ant colony
            colony(d).ant(k).distFitness = distFitnessFunction(drones, d, colony(d).ant(k).tour,  graph);
            [fireOverall, fireFit1, fireFit2, fireFit3] = fireFitnessFunction(colony(d).ant(k), drones.capac(d), droneNo, length(fires.locX));
            colony(d).ant(k).fireFitness = fireOverall;
            colony(d).ant(k).fireTotDiff = fireFit1;
            colony(d).ant(k).fireEq = fireFit2;
            colony(d).ant(k).fireInt = fireFit3;
        end
        for k = 1: 1: antNo
            if bestFireFitness(1, d) > colony(d).ant(k).fireFitness
                bestFireFitness(1, d) = colony(d).ant(k).fireFitness;
                bestTour{d} = colony(d).ant(k).tour;
                bestFireDist(1, d) = colony(d).ant(k).distFitness;
                bestFireFit1(1, d) = colony(d).ant(k).fireTotDiff;
                bestFireFit2(1, d) = colony(d).ant(k).fireEq;
                bestFireFit3(1, d) = colony(d).ant(k).fireInt;
            else
            end
        end
    
        %Find the best ant of this colony
        colony(d).queen.tour = bestTour{d};
        colony(d).queen.fireTotDiff = bestFireFit1(1, d);
        colony(d).queen.fireEq = bestFireFit2(1, d);
        colony(d).queen.fireInt = bestFireFit3(1, d);
        colony(d).queen.fireFitness = bestFireFitness(1, d);
%         
        %Update pheromone matrix
        tau(:, :, d) = updatePheromone(tau(:, :, d), colony(d));
        
        %Evaporation
        tau(:, :, d) = (1 - rho) .* tau(:, :, d);
        outmsg = ['Iteration = #', num2str(t), ' Drone = #' , num2str(d), ' Fitness = # ', num2str(colony(d).queen.fireFitness(1, 1)) ];
        disp(outmsg)
        subplot(2, 4, 3)
        drawBestTour(colony(d), drones, d, graph);
        title('Best Tour of Iteration # ', num2str(t))
%         cla
        
        %Visualize best tour and pheromone concentration
        if (d < 5)
            subplot(2, 4, d + 4);
            cla
            drawPheromone(tau(:, :, d), graph);
            drawnow
            title('Pheromones of Drone # ', num2str(d))
        else
        end
            
        tempFitness = tempFitness + colony(d).queen.fireFitness;
        if colony(d).queen.fireFitness == 0.01 && bestSolutionsFound(d) == 0
           bestOverallFitness = bestOverallFitness + 0.01;
           bestSolutionsFound(d) = 1;      
        else
        end
        if t ~= maxIter
            cla(subplot(2, 4, 3))
        else
        end
        t = t + 1;
    end
    allUsedNodes = cell2mat(bestTour);
    t = 1;
    if length(allUsedNodes) == length(fires.locX)
        break
    else
    end
    actualNumberDronesUsed = actualNumberDronesUsed + 1;
end
allUnusedNodes = zeros(1, length(fires.intensity) - length(allUsedNodes));
uCounter = 1;
for i = 1: length(fires.intensity)
    if ~(ismembertol(i, allUsedNodes))
        allUnusedNodes(1, uCounter) = i;
        uCounter = uCounter + 1;
    else
    end
end
droneNumber = 1;
uIntensity = zeros(1, length(allUnusedNodes));
for i = 1: length(allUnusedNodes)
    uIntensity(1, i) = fires.intensity(allUnusedNodes(1, i));
end
for i = 1: length(allUnusedNodes)
    while (~(droneNumber > droneNo) && uIntensity(1, i) ~= 0)
        if (uIntensity(1, i) - colony(droneNumber).queen.fireTotDiff >= 0)    
            uIntensity(1, i) = uIntensity(1, i) - colony(droneNumber).queen.fireTotDiff;
            colony(droneNumber).queen.tour = [colony(droneNumber).queen.tour, allUnusedNodes(1, i)];
            bestTour{droneNumber} = [bestTour{droneNumber}, allUnusedNodes(1, i) + colony(droneNumber).queen.fireTotDiff / fires.intensity(allUnusedNodes(1, i))];
            colony(droneNumber).queen.fireTotDiff = 0;
            droneNumber = droneNumber + 1;
        else
            bestTour{droneNumber} = [bestTour{droneNumber}, allUnusedNodes(1, i) + colony(droneNumber).queen.fireTotDiff / fires.intensity(allUnusedNodes(1, i))];
            colony(droneNumber).queen.fireTotDiff = colony(droneNumber).queen.fireTotDiff - uIntensity(1, i);
            uIntensity(1, i) = 0;
            colony(droneNumber).queen.tour = [colony(droneNumber).queen.tour, allUnusedNodes(1, i)];
        end
    end
end
subplot(2, 4, 4)
%graph best tours
for d = 1: actualNumberDronesUsed
    drawBestTour(colony(d), drones, d, graph);
    bestOverallFitness = bestOverallFitness + 0.01;
end
title('Best Overall Tour of All Iterations')
