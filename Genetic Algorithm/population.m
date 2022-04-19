function [ cluster ] = population(popSize, fireIntensity,  toursFound, droneNo,...
    droneCapac, cluster)
%population Generates a population sized of given popSize number.  
    nodeNo = length(fireIntensity);
    for i = 1: popSize
        initial_node = randi([1, nodeNo]);
        while (ismembertol(initial_node, toursFound) == 1 || ...
                fireIntensity(initial_node) > droneCapac)
            initial_node = randi([1, nodeNo]);
        end
        cluster(droneNo).pop(i).fireSum = fireIntensity(initial_node);
        if (isempty(cluster(droneNo).pop(i).fireSum))
            cluster(droneNo).pop(i).fireSum = 0;
        end
        cluster(droneNo).pop(i).fires(1) = fireIntensity(initial_node);
        cluster(droneNo).pop(i).tour(1) = initial_node;
        j = 2;
        abortCondition = 0;
        while (abortCondition == 0 && droneCapac > cluster(droneNo).pop(i).fireSum && j < nodeNo)
            nextNode = rouletteWheel(cluster(droneNo).pop(i).tour, toursFound, nodeNo);
            if (isempty(nextNode) == 1)    
                cluster(droneNo).pop(i).tour = [cluster(droneNo).pop(i).tour, nextNode];
                cluster(droneNo).pop(i).fires = [cluster(droneNo).pop(i).fires, fireIntensity(nextNode)];
                cluster(droneNo).pop(i).fireSum = [cluster(droneNo).pop(i).fireSum + ...
                    cluster(droneNo).pop(i).fires(length(cluster(droneNo).pop(i).fires))];
            else
                %makes sure no more looping if nextNode is empty
                abortCondition = 1;
            end
        end
        
        if droneCapac < cluster(droneNo).pop(i).fireSum
            cluster(droneNo).pop(i).fireSum = [cluster(droneNo).pop(i).fireSum - fireIntensity(cluster(droneNo).pop(i).tour(j - 1))];
            cluster(droneNo).pop(i).fires(j - 1) = [];
            cluster(droneNo).pop(i).tour(j - 1) = [];
        else
        end
    end

end

