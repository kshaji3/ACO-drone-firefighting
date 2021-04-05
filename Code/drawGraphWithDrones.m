function [   ]  = drawGraphWithDrones(graph, drones)
    % # VERTICES = # CITIES
    for i = 1 : graph.n - 1
        for j =  i+1 : graph.n
    
            x1 = graph.node(i).x;
            y1 = graph.node(i).y;
            z1 = graph.node(i).z;
        
            x2 = graph.node(j).x;
            y2 = graph.node(j).y;
            z2 = graph.node(j).z;
        
            X = [x1 , x2]; 
            Y = [y1 , y2];
            Z = [z1, z2];
        
            plot3( X , Y , Z, '-k');
            hold on
        end
    end

    for i = 1 : graph.n
        X = [graph.node(:).x];
        Y = [graph.node(:).y];
        Z = [graph.node(:).z];
        plot3(X,Y,Z, 'ok', 'MarkerSize', 10, 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor' , [ 1, 0.6 , 0.6]);
    end
    for i = 1: length(drones.locX)
        x1 = drones.locX(i);
        y1 = drones.locY(i);
        z1 = drones.locZ(i);
        for j = 1: graph.n
            x2 = graph.node(j).x;
            y2 = graph.node(j).y;
            z2 = graph.node(j).z;
            X = [x1, x2];
            Y = [y1, y2];
            Z = [z1, z2];
            plot3(X, Y, Z, ':k');
        end
    end
    for i = 1: length(drones.locX)
        X = [drones.locX(i)];
        Y = [drones.locY(i)];
        Z = [drones.locZ(i)];
        plot3(X,Y,Z, 'ok', 'MarkerSize', 6, 'MarkerEdgeColor' , 'blue' , 'MarkerFaceColor' , 'blue');
    end
    title ('All nodes, edges, and drones')
    box('on')

end
