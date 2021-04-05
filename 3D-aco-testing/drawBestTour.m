function [ ] = drawBestTour(colony , graph)

queenTour = colony.queen.tour;

for i = 1 : length(queenTour) - 1
    
    currentNode = queenTour(i);
    nextNode =  queenTour(i+1);
    
    x1 = graph.node(currentNode).x;
    y1 = graph.node(currentNode).y;
    z1 = graph.node(currentNode).z;
    
    x2 = graph.node(nextNode).x;
    y2 = graph.node(nextNode).y;
    z2 = graph.node(nextNode).z;
    
    X = [x1 , x2];
    Y = [y1, y2];
    Z = [z1, z2];
    plot3(X, Y, Z, '-r');
    hold on
end


for i = 1 : graph.n
    
    X = [graph.node(:).x];
    Y = [graph.node(:).y];
    Z = [graph.node(:).z];
    plot3(X, Y, Z, 'ok', 'markerSize' , 10 , 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor', [1, 0.6, 0.6]);
end

title('Best tour (the queen)')
box('on');