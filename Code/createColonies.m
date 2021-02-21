function [ colony ] = createColonies( graph, colony , droneNo, antNo, tau, eta, alpha,  beta)
    nodeNo = graph.n;
    
    for i = 1: antNo
        initial_node = randi([1, nodeNo]); %select a random node
        colony.ant(i).tour(i) = initial_node;
        
        for j = 2: nodeNo
            currentNode = colony.ant(i).tour(end);
        end
    end
end
