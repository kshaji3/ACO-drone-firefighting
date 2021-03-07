function [ distFitness ] = distFitnessFunction ( drones, droneNo, tour , graph)
    distFitness = 0;
    x1 = drones.locX(droneNo);
    y1 = drones.locY(droneNo);
    x2 = graph.node(tour(1)).x;
    y2 = graph.node(tour(1)).y;
    distFitness = sqrt((x2-x1)^2 + (y2-y1).^2);
    for i = 1 : 1: length(tour) - 1
    
        currentNode = tour(i);
        nextNode = tour(i+1);
        distFitness = distFitness + graph.edges( currentNode ,  nextNode );
    
    end
end
