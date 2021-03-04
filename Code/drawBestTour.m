function [ ] = drawBestTour(colony , drones, droneNo, graph)
    queenTour = colony.queen.tour;
    hold on

    for i = 1 : graph.n
    
        X = [graph.node(:).x];
        Y = [graph.node(:).y];
    
        plot(X, Y, 'ok', 'markerSize' , 10 , 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor', [1, 0.6, 0.6]);
    end
    
    color = [0.1 * droneNo, 0.5, 0.5];
    
    if (length(queenTour) >= 1)
        nextNode =  queenTour(1);
    
        x1 = drones.locX(droneNo);
        y1 = drones.locY(droneNo);
    
        x2 = graph.node(nextNode).x;
        y2 = graph.node(nextNode).y;
    
        X = [x1 , x2];
        Y = [y1, y2];
%         currentNode = queenTour(1);
%     
%         x1 = graph.node(currentNode).x;
%         y1 = graph.node(currentNode).y;
        plot (X, Y, 'color', color);
        
        for i = 1 : length(queenTour) - 1
    
            currentNode = queenTour(i);
            nextNode =  queenTour(i+1);
    
            x1 = graph.node(currentNode).x;
            y1 = graph.node(currentNode).y;
    
            x2 = graph.node(nextNode).x;
            y2 = graph.node(nextNode).y;
    
            X = [x1 , x2];
            Y = [y1, y2];
            plot (X, Y, 'color', color);

        end
    else
    end
    for i = 1: length(drones.locX)
        X = [drones.locX(i)];
        Y = [drones.locY(i)];
        plot(X,Y, 'ok', 'MarkerSize', 6, 'MarkerEdgeColor' , 'blue' , 'MarkerFaceColor' , 'blue');
    end
    title('Best tour (the queen)')
    box('on');
end
