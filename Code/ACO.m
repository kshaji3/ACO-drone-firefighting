clear all
clc
%% Problem Preparation
%get the fires and drones
fires = createFires();
[drones] = createDrones();

%Create the graph
[graph] = createGraph(fires.locX, fires.locY);

%Draw the graph
figure
subplot(2, 4, 1)
drawGraph(graph);
subplot(2, 4, 2);
drawGraphWithDrones(graph, drones);

%% Initial Parameters
maxIter = 10; %1
antNo = 10; %5
droneNo = 5; %agents in CVRP

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
bestTour = {};
colony = [];
bestOverallFitness = inf;
t = 1;
while t <= maxIter && bestOverallFitness ~= (0.01 * droneNo)
    tempFitness = 0;
    %create ants
%     d = 1;
%     while d <= droneNo
    for d = 1: droneNo
        colony = createColonies(graph, fires.intensity, drones.capac(d), d, colony, antNo, tau(:,:,d), eta, alpha, beta);
        for k = 1: antNo 
            %calculate fitnesses of all ants in a specific drone ant colony
            colony(d).ant(k).distFitness = distFitnessFunction(drones, d, colony(d).ant(k).tour,  graph);
            colony(d).ant(k).fireFitness = fireFitnessFunction(colony(d).ant(k), drones.capac(d), droneNo, length(fires.locX));
        end
        for k = 1: 1: antNo
            if bestFireFitness(1, d) > colony(d).ant(k).fireFitness
                bestFireFitness(1, d) = colony(d).ant(k).fireFitness;
                bestTour{d} = colony(d).ant(k).tour;
                bestFireDist(1, d) = colony(d).ant(k).distFitness;
            else
            end
        end
    
        %Find the best ant of this colony
        colony(d).queen.tour = bestTour{d};
        colony(d).queen.fireFitness = bestFireFitness(1, d);
%         
        %Update pheromone matrix
        tau(:, :, d) = updatePheromone(tau(:, :, d), colony(d));
        
        %Evaporation
        tau(:, :, d) = (1 - rho) .* tau(:, :, d);
        outmsg = ['Iteration #', num2str(t), 'Drone #' , num2str(d), 'Fitness # ', num2str(colony(d).queen.fireFitness(1, 1)) ];
        disp(outmsg)
        subplot(2, 4, 1)
        title(['Iteration #' , num2str((t-1) * 5 + d) ])
        subplot(2, 4, 3)
%         cla
        
        %Visualize best tour and pheromone concentration
        drawBestTour(colony(d), drones, d, graph);
        subplot(2, 4, 4)
%         cla
%         drawPheromone(tau(:, :, d), graph);
%         drawnow
        tempFitness = tempFitness + colony(d).queen.fireFitness;
        subplot(2, 4, 5)
        if colony(d).queen.fireFitness == 0.01
           drawBestTour(colony(d), drones, d, graph);
        else
        end
%         d = d + 1;
    end
    if t ~= maxIter
       cla(subplot(2, 4, 3))
    else
    end
    
    
    t = t + 1;
end
