function [ distFitness ] = distFitnessFunction ( drones, droneNo, tour , graph)
    %calculate the distances, this is mostly a value taken for just
    %process, and not really used anywhere in the algorithm
    if (length(tour) == 0)
        distFitness = Inf;
    else
        distFitness = 0;
        x1 = drones.loc(1, droneNo);
        y1 = drones.loc(2, droneNo);
        z1 = drones.loc(3, droneNo);
        x2 = graph.node(tour(1)).x;
        y2 = graph.node(tour(1)).y;
        z2 = graph.node(tour(1)).z;
        distFitness = sqrt((x2-x1)^2 + (y2-y1).^2 + (z2-z1)^2);
        for i = 1 : 1: length(tour) - 1

            currentNode = tour(i);
            nextNode = tour(i+1);
            distFitness = distFitness + graph.edges( currentNode ,  nextNode );

        end
    end
end