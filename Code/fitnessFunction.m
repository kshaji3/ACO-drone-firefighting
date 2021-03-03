function [ fitness ] = fitnessFunction ( tour , fireSum, droneCapac, graph)
    fitness = zeros(1, 2);
    for i = 1 : 1: length(tour) - 1
    
        currentNode = tour(i);
        nextNode = tour(i+1);
        fitness(1, 1) = fitness(1) + graph.edges( currentNode ,  nextNode );
    
    end
    fitness(1, 2) = abs(droneCapac - fireSum);
end
