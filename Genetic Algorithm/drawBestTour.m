function [ ] = drawBestTour(bestTour, drones, droneNo, graph) %draw the best tour    
    %graph nodes
    for i = 1 : graph.n
    
        X = [graph.node(i).x];
        Y = [graph.node(i).y];
        Z = [graph.node(i).z];
        plot3(X, Y, Z, 'ok', 'markerSize' , 10 , 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor', [1, 0.6, 0.6]);;
        text(X, Y, Z, num2str(i));
        hold on
    end
    
    %different colors for each drone
    color = [mod(0.77 * droneNo, 1), 0.5, 0.5];
    
    if (length(bestTour) >= 1)
        nextNode =  floor(bestTour(1));
    
        x1 = drones.loc(1, droneNo);
        y1 = drones.loc(2, droneNo);
        z1 = drones.loc(3, droneNo);
    
        x2 = graph.node(nextNode).x;
        y2 = graph.node(nextNode).y;
        z2 = graph.node(nextNode).z;
    
        X = [x1 , x2];
        Y = [y1, y2];
        Z = [z1, z2];
        plot3(X, Y, Z, 'color', color, 'LineWidth', 1 + (droneNo * 0.2));
        
        for i = 1 : length(bestTour) - 1
    
            currentNode = floor(bestTour(i));
            nextNode =  floor(bestTour(i+1));
    
            x1 = graph.node(currentNode).x;
            y1 = graph.node(currentNode).y;
            z1 = graph.node(currentNode).z;
    
            x2 = graph.node(nextNode).x;
            y2 = graph.node(nextNode).y;
            z2 = graph.node(nextNode).z;
    
            X = [x1 , x2];
            Y = [y1, y2];
            Z = [z1, z2];
            plot3(X, Y, Z, 'color', color, 'LineWidth', 1 + (droneNo * 0.2));

        end
    else
    end
    for i = 1: length(drones.loc(1,:))
        X = [drones.loc(1, i)];
        Y = [drones.loc(2, i)];
        Z = [drones.loc(3, i)];
        plot3(X,Y, Z, 'ok', 'MarkerSize', 6, 'MarkerEdgeColor' , 'blue' , 'MarkerFaceColor' , 'blue');
    end
    box('on');
end
