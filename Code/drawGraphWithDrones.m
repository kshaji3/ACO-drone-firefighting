function [   ]  = drawGraphWithDrones(graph, droneLocX, droneLocY)
    hold on 
    % # VERTICES = # CITIES
    for i = 1 : graph.n - 1
        for j =  i+1 : graph.n
    
            x1 = graph.node(i).x;
            y1 = graph.node(i).y;
        
            x2 = graph.node(j).x;
            y2 = graph.node(j).y;
        
            X = [x1 , x2]; 
            Y = [y1 , y2];
        
            plot( X , Y , '-k');
        end
    end

    for i = 1 : graph.n
        X = [graph.node(:).x];
        Y = [graph.node(:).y ];
        plot(X,Y, 'ok', 'MarkerSize', 10, 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor' , [ 1, 0.6 , 0.6]);
    end
    for i = 1: length(droneLocX)
        x1 = droneLocX(i);
        y1 = droneLocY(i);
        for j = 1: graph.n
            x2 = graph.node(j).x;
            y2 = graph.node(j).y;
            X = [x1, x2];
            Y = [y1, y2];
            plot(X, Y, ':k');
        end
    end
    for i = 1: length(droneLocX)
        X = [droneLocX(i)];
        Y = [droneLocY(i)];
        plot(X,Y, 'ok', 'MarkerSize', 6, 'MarkerEdgeColor' , 'blue' , 'MarkerFaceColor' , 'blue');
    end
    title ('All nodes, edges, and drones')
    box('on')

end
