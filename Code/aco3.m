function [time] = aco3(graph, environment, droneNo, antNo, indVert, indHoriz)


%% Problem Preparation
%get the fires and drones
timeStart = tic;
[drones] = createDrones(environment.fires{indVert, indHoriz}, droneNo);

%% Initial Parameters
environment.maxIter = 50; %1
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
drones.bestFireFitness = inf(1, droneNo);
drones.bestFireDist = zeros(1, droneNo); %best fire's distance

%stores individual fire fitness values
drones.bestFireFit1 = zeros(1, droneNo);
drones.bestFireFit2 = zeros(1, droneNo);
drones.bestFireFit3 = zeros(1, droneNo);
bestTour = {};
drones.colony = [];
drones.bestOverallFitness = zeros(1, droneNo); %datapoint that shows overall how ideal the whole solution is
drones.allUsedNodes = []; %keeps track of all the nodes that are visited
drones.bestSolutionsFound = zeros(1, droneNo); %check if best solutions are found



%% Main Loop of ACO

t = 1; %fenceposting

for d = 1: droneNo
    %create ants
    while t <= environment.maxIter && drones.bestSolutionsFound(d) ~= 3
        drones.colony = createColonies(t, graph, environment.fires{indVert, indHoriz}.intensity, drones.capac(d), ...
            d, drones.colony, antNo, drones.tau(:,:,d), graph.eta, environment.alpha, environment.beta, drones.allUsedNodes);
        for k = 1: antNo 
            %calculate fitnesses of all ants in a specific drone ant colony
            drones.colony(d).ant(k).distFitness = distFitnessFunction(drones, d, drones.colony(d).ant(k).tour,  graph);
            [fireOverall, fireFit1, fireFit2, fireFit3] = fireFitnessFunction(drones.colony(d).ant(k), drones.capac(d), droneNo, length(environment.fires{indVert, indHoriz}.locX));
            
            %stores variables into the colony struct.
            drones.colony(d).ant(k).fireFitness = fireOverall;
            drones.colony(d).ant(k).fireTotDiff = fireFit1;
            drones.colony(d).ant(k).fireEq = fireFit2;
            drones.colony(d).ant(k).fireInt = fireFit3;
        end
       if t > 1
        oldBest = bestTour{d};
       else
       end
        %check if any of the ants offer a better solution than the ones
        %found already
        for k = 1: 1: antNo
            if drones.bestFireFitness(1, d) > drones.colony(d).ant(k).fireFitness
                drones.bestFireFitness(1, d) = drones.colony(d).ant(k).fireFitness;
                bestTour{d} = drones.colony(d).ant(k).tour;
                drones.bestFireDist(1, d) = drones.colony(d).ant(k).distFitness;
                drones.bestFireFit1(1, d) = drones.colony(d).ant(k).fireTotDiff;
                drones.bestFireFit2(1, d) = drones.colony(d).ant(k).fireEq;
                drones.bestFireFit3(1, d) = drones.colony(d).ant(k).fireInt;
            else
            end
        end
    
        %Find the best ant of this colony
        drones.colony(d).queen.tour = bestTour{d};
        drones.colony(d).queen.fireTotDiff = drones.bestFireFit1(1, d);
        drones.colony(d).queen.fireEq = drones.bestFireFit2(1, d);
        drones.colony(d).queen.fireInt = drones.bestFireFit3(1, d);
        drones.colony(d).queen.fireFitness = drones.bestFireFitness(1, d);
%         
        %Update pheromone matrix
        drones.tau(:, :, d) = updatePheromone(drones.tau(:, :, d), drones.colony(d));
        
        %Evaporation
        drones.tau(:, :, d) = (1 - environment.rho) .* drones.tau(:, :, d);
        
        if t > 1 && isequal(cell2mat(bestTour(d)), oldBest)
            drones.bestSolutionsFound(d) = drones.bestSolutionsFound(d) + 1;      
        else
            drones.bestSolutionsFound(d) = 1;
        end
        t = t + 1;
    end
    
    %converts all the bestTour nodes to a matrix that denotes all the nodes
    %visited, which is used later
    drones.allUsedNodes = cell2mat(bestTour);
    t = 1;
    if length(drones.allUsedNodes) == length(environment.fires{indVert, indHoriz}.locX)
        break
    else
    end
end

%% Cooperative Search Part to Target Untargeted Fires

drones.allUnusedNodes = zeros(1, length(environment.fires{indVert, indHoriz}.intensity) - length(drones.allUsedNodes));
uCounter = 1;

%variable that denotes if less than 5 drones have been used for the
%particular problem
drones.actualNumberDronesUsed = length(bestTour);

%records all the nodes that have not been used, which is used for the
%cooperative solution finding
for i = 1: length(environment.fires{indVert, indHoriz}.intensity)
    if ~(ismembertol(i, drones.allUsedNodes))
        drones.allUnusedNodes(1, uCounter) = i;
        uCounter = uCounter + 1;
    else
    end
end

droneNumber = 1;
environment.fires{indVert, indHoriz}.uIntensity = zeros(1, length(drones.allUnusedNodes));
%records intensity of the fires in the unused nodes
for i = 1: length(drones.allUnusedNodes)
    environment.fires{indVert, indHoriz}.uIntensity(1, i) = environment.fires{indVert, indHoriz}.intensity(drones.allUnusedNodes(1, i));
end


for i = 1: length(drones.allUnusedNodes)
    while (~(droneNumber > droneNo) && environment.fires{indVert, indHoriz}.uIntensity(1, i) ~= 0)
        %drones with no fire extinguisher are not rerouted
        if (drones.colony(droneNumber).queen.fireTotDiff <= 0.05)
            droneNumber = droneNumber + 1;
        %routing drones and setting new fire values for fires that require
        %the drone to expend all of its fire extinguisher
        elseif (environment.fires{indVert, indHoriz}.uIntensity(1, i) - drones.colony(droneNumber).queen.fireTotDiff >= 0)    
            environment.fires{indVert, indHoriz}.uIntensity(1, i) = environment.fires{indVert, indHoriz}.uIntensity(1, i) - drones.colony(droneNumber).queen.fireTotDiff;
            drones.colony(droneNumber).queen.tour = [drones.colony(droneNumber).queen.tour, drones.allUnusedNodes(1, i)];
            bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i) + drones.colony(droneNumber).queen.fireTotDiff / environment.fires{indVert, indHoriz}.intensity(drones.allUnusedNodes(1, i))];
            drones.colony(droneNumber).queen.fireTotDiff = 0;
            droneNumber = droneNumber + 1;
        %if the drone has fire extinguisher left after fighting one fire
        else
            if (environment.fires{indVert, indHoriz}.uIntensity(1, i) == environment.fires{indVert, indHoriz}.intensity(drones.allUnusedNodes(1, i)))
                bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i)];
            else
                bestTour{droneNumber} = [bestTour{droneNumber}, drones.allUnusedNodes(1, i)+ environment.fires{indVert, indHoriz}.uIntensity(1, i) / environment.fires{indVert, indHoriz}.intensity(drones.allUnusedNodes(1, i))]; %+ drones.colony(droneNumber).queen.fireTotDiff / environment.fires.intensity(drones.allUnusedNodes(1, i))];
            end
            drones.colony(droneNumber).queen.fireTotDiff = drones.colony(droneNumber).queen.fireTotDiff - environment.fires{indVert, indHoriz}.uIntensity(1, i);
            environment.fires{indVert, indHoriz}.uIntensity(1, i) = 0;
            drones.colony(droneNumber).queen.tour = [drones.colony(droneNumber).queen.tour, drones.allUnusedNodes(1, i)];
        end
    end
end
time = toc(timeStart);

end
