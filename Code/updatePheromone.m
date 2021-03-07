function [ tau ] = updatePheromone(tau, droneNo, colony)

    %nodeNo = length(colony(droneNo).ant(1).tour);
    antNo = length(colony(droneNo).ant(:));

    for i = 1 : antNo % for each ant
        nodeNo = length(colony(droneNo).ant(i).tour);
        for j = 1 : nodeNo-1 % for each node in the tour
            currentNode = colony(droneNo).ant(i).tour(j);
            nextNode = colony(droneNo).ant(i).tour(j+1);
        
            tau(currentNode, nextNode, droneNo) = tau(currentNode, nextNode, droneNo)  + 1./ colony(droneNo).ant(i).fireFitness;
            tau(nextNode, currentNode, droneNo) = tau(nextNode, currentNode, droneNo)  + 1./ colony(droneNo).ant(i).fireFitness;

        end
    end

end