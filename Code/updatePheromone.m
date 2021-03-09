function [ subTau ] = updatePheromone(subTau, subColony)

    %nodeNo = length(colony(droneNo).ant(1).tour);
    antNo = length(subColony.ant(:));

    for i = 1 : antNo % for each ant
        nodeNo = length(subColony.ant(i).tour);
        for j = 1 : nodeNo-1 % for each node in the tour
            currentNode = subColony.ant(i).tour(j);
            nextNode = subColony.ant(i).tour(j+1);
        
            subTau(currentNode, nextNode) = subTau(currentNode, nextNode)  + 1./ subColony.ant(i).fireFitness;
            subTau(nextNode, currentNode) = subTau(nextNode, currentNode)  + 1./ subColony.ant(i).fireFitness;

        end
    end

end