function [graph] = createGraph(fireLocX, fireLocY, fireLocZ) %create an initial visualization
    %create the CONSTRUCTION GRAPH
    graph.n = length(fireLocX);
    x = fireLocX;
    y = fireLocY;
    z = fireLocZ;
    %plot the nodes
    for i = 1: graph.n
        graph.node(i).x = x(i);
        graph.node(i).y = y(i);
        graph.node(i).z = z(i);
    end
    graph.edges = zeros(graph.n, graph.n);
    
    %plot the edge lines
    for i = 1: graph.n
        for j = 1: graph.n
            x1 = graph.node(i).x;
            x2 = graph.node(j).x;
            
            y1 = graph.node(i).y;
            y2 = graph.node(j).y;
            
            z1 = graph.node(i).z;
            z2 = graph.node(j).z;
            
            graph.edges(i,j) = sqrt(  (x1 - x2) ^2 + (y1 - y2)^2 + (z1 - z2)^2 ); 
        end
    end
end

