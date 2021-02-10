clear all
close all
clc
%% Problem Preparation
%get the fires and drones
[ fires ] = createFires();
[ drones ] = createDrones();

%Create the graph
[ graph ] = createGraph();

%Draw the graph
figure
subplot(1, 3, 1)
drawGraph(graph);
%% ACO Algorithm

%% Initial Parameters
maxIter = 10;
antNo = 10;
droneNo = 5;
tau0 = zeros(0, droneNo);
tau = zeros(0, droneNo);
eta = zeros(0, droneNo);
for i = 1:1:droneNo
    tau0(droneNo) = 10 * 1 / (graph.n * mean(graph.edges(:) ) );
end
rho = 0.5; % Evaporation rate 
alpha = 1;  % Phromone exponential parameters 
beta = 1;  % Desirability exponetial paramter
%% Main Loop of ACO
bestFitness = inf;
bestTour = [];
colony = zeros(0, droneNo);
allAntsFitness = zeros(0, droneNo);
for i = 1: maxIter
    %create ants
    for j = 1: droneNo
        colony(droneNo) = createColonies(graph, colony, droneNo, antNo, tau, eta, alpha, beta) %placeholder
        for i = 1: antNo %calculate fitnesses
            colony(0, droneNo).ant(i).fitness = fitnessFunction(); %placeholder
        end
        allAntsFitness = [colony.ant(:).fitness];
        [minVal, minIndex] = min(allAntsFitness);
        if minVal < bestFitness
            bestFitness = colony.ant(minIndex).fitness;
            bestTour = colony.ant(minIndex).tour;
        end
        colony.queen.tour = bestTour;
        colony.queen.fitness = bestFitness;
        tau = updatePheromone(tau, colony);
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
