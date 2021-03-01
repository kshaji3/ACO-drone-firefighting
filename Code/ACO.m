clear all
close all
clc
%% Problem Preparation
%get the fires and drones
[fireIntensity, fireLocX, fireLocY] = createFires();
[droneCapac, droneLocX, droneLocY] = createDrones();
%Create the graph
[graph] = createGraph(fireLocX, fireLocY);
%Draw the graph
figure
subplot(1, 4, 1)
drawGraph(graph);
subplot(1, 4, 2);
drawGraphWithDrones(graph, droneLocX, droneLocY);
%% ACO Algorithm

%% Initial Parameters
maxIter = 1;
antNo = 10;
droneNo = 5;

tau0 = 10 * 1 / (graph.n * mean(graph.edges(:) ) );
eta = 1 ./ graph.edges; %edge desirability

%Start the process of creating a 3D tau matrix
tau = tau0 * ones(graph.n, graph.n);
for i = 1: 1: droneNo - 1
    tau(:,:,i + 1) = tau0 * ones(graph.n, graph.n);
end

rho = 0.5; % Evaporation rate 
alpha = 1;  % Pheromone exponential parameters 
beta = 1;  % Desirability exponetial paramter
%% Main Loop of ACO

%initial base conditions
bestFitness = inf;
bestTour = [];
colony = [];
%colony = zeros(0, droneNo);
allAntsFitness = zeros(0, droneNo);
for i = 1: maxIter
    %create ants
    for j = 1: droneNo
        
        colony = createColonies(graph, j, colony, antNo, tau(:,:,j), eta, alpha, beta) %works
        for i = 1: antNo %calculate fitnesses
            colony.ant(j).fitness = fitnessFunction(colony.ant(j).tour , graph);
        end
        allAntsFitness = [colony.ant(:).fitness];
        [minVal, minIndex] = min(allAntsFitness);
        if minVal < bestFitness
            bestFitness = colony.ant(minIndex).fitness;
            bestTour = colony.ant(minIndex).tour;
        end
        colony.queen.tour = bestTour;
        colony.queen.fitness = bestFitness;
        tau = updatePheromone(tau, j, colony);
        tau = (1 - rho) .* tau;
        outmsg = ['Iteration #' , num2str(t), ' Shortest Length = ' , num2str(colony.queen.fitness) ];
        disp(outmsg)
        subplot(1, 3, 1)
        title(['Iteration #' , num2str(t) ])
        subplot(1, 3, 2)
        cla
        drawBestTour(colony, graph);
        subplot(1, 3, 3)
        cla
        drawPheromone(tau, graph);
        drawnow
    end
end
