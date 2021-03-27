function [ colony ] = createColonies( iterationNum, graph, fireIntensity, droneCapac, droneNo, colony , antNo, tau, eta, alpha,  beta, toursFound)
    nodeNo = graph.n;
    if iterationNum > 1
        for i = 1: antNo
            while isempty(colony(droneNo).ant(i).tour) == 0
                colony(droneNo).ant(i).tour(1) = [];
                colony(droneNo).ant(i).fires(1) = [];
            end
        end
    else
    end
    for i = 1 : antNo
    
        initial_node = randi( [1 , nodeNo] ); % select a random node 
        while ismembertol(initial_node, toursFound) == 1
            initial_node = randi( [1 , nodeNo] ); % select a random node 
        end
        colony(droneNo).ant(i).fireSum = fireIntensity(initial_node);
        colony(droneNo).ant(i).fires(1) = fireIntensity(initial_node);
        colony(droneNo).ant(i).tour(1) = initial_node;
        j = 2;
        %experimental portion
        while droneCapac > colony(droneNo).ant(i).fireSum && j < nodeNo
            currentNode =  colony(droneNo).ant(i).tour(end);
%             zz = tau(currentNode, :)
            P_allNodes = tau( currentNode , :  ) .^ alpha .* eta( currentNode , :  )  .^ beta; %search here for fix
%             z = colony(droneNo).ant(i).tour
            P_allNodes(colony(droneNo).ant(i).tour) = 0;
            P_allNodes(toursFound) = 0;
            P = P_allNodes ./ sum(P_allNodes);
            if isnan(P)
                break
            else
            end
            nextNode = rouletteWheel(P); 
            colony(droneNo).ant(i).tour = [  colony(droneNo).ant(i).tour , nextNode ];
            colony(droneNo).ant(i).fires = [ colony(droneNo).ant(i).fires, fireIntensity(nextNode)];
            colony(droneNo).ant(i).fireSum = [colony(droneNo).ant(i).fireSum + fireIntensity(nextNode)];
            j = j + 1;
                
        end
%         while j < length(colony(droneNo).ant(i).tour)
%             colony(droneNo).ant(i).tour(j) = [];
%             colony(droneNo).ant(i).fires(j) = [];
%         end
        if droneCapac < colony(droneNo).ant(i).fireSum %&& length(colony(droneNo).ant(i).tour) > 1
            colony(droneNo).ant(i).fireSum = [colony(droneNo).ant(i).fireSum - fireIntensity(colony(droneNo).ant(i).tour(j-1))];
            colony(droneNo).ant(i).fires(j - 1) = [];
            colony(droneNo).ant(i).tour(j - 1) = [];
        else
        end
    end
end
