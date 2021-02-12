function [ graph ] = createGraph()
    %create the CONSTRUCTION GRAPH
    x = [0 5 10 15 20 25];
    y = [0 5 10 15 20 25];
    graph.n = length(x);
    for i = 1: graph.n
        graph.node(i).x = x(i);
        graph.node(i).y = y(i);
    end
    graph.edges = zeros(graph.n, graph.n);
    for i = 1: graph.n
        for j = 1: graph.n
            x1 = graph.node(i).x;
            x2 = graph.node(j).x;
            y1 = graph.node(i).y;
            y2 = graph.node(j).y;
            graph.edges(i,j) = sqrt(  (x1 - x2) ^2 + (y1 - y2)^2  ); 
        end
    end
end

