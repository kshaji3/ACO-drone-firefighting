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

%% Initial Parameters
maxIter = 1;
antNo = 10;
droneNo = 5; %agents in CVRP

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
        for k = 1: antNo 
            %calculate fitnesses of all ants in a specific drone ant colony
            colony(j).ant(k).fitness = fitnessFunction(colony(j).ant(k).tour , graph);
        end
        allAntsFitness = [colony(j).ant(:).fitness];
        [minVal, minIndex] = min(allAntsFitness);
        if minVal < bestFitness
            bestFitness = colony(j).ant(minIndex).fitness;
            bestTour = colony(j).ant(minIndex).tour;
        end
        %Find the best ant of this colony
        colony(j).queen.tour = bestTour;
        colony(j).queen.fitness = bestFitness;
        
        %Update pheromone matrix
        tau = updatePheromone(tau, j, colony);
        
        %Evaporation
        tau(:, :, j) = (1 - rho) .* tau(:, :, 1);
        outmsg = ['Iteration #' , num2str(i), ' Shortest Length = ' , num2str(colony(j).queen.fitness) ];
        disp(outmsg)
        subplot(1, 4, 1)
        title(['Iteration #' , num2str(i) ])
        subplot(1, 4, 3)
        cla
        
        %Visualize best tour and pheromone concentration
        drawBestTour(colony(j), graph);
        subplot(1, 4, 4)
        cla
        drawPheromone(tau(:, :, j), graph);
        drawnow
    end
end
