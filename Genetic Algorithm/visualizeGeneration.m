function [ output_args ] = visualizeGeneration( cities, pop, minPath, totalDistances )
%Visualizing the cities and the best finded result according to algorithm.
 
    global gNumber;
    [l, length] = size(cities);
    xDots = cities(1,:);
    yDots = cities(2,:);
    zDots = cities(3,:);
    %figure(1);
    title('Genetic Algorithms for TSP');
    plot3(xDots,yDots, zDots, 'o', 'MarkerSize', 7.5, 'MarkerFaceColor', 'blue');
    xlabel('X Dimension');
    ylabel('Y Dimension');
    zlabel('Z Dimension');
    axis equal
    hold on
    [minPathX,minPathY, minPathZ] = find(totalDistances==minPath,1, 'first');
    bestPopPath = pop(minPathX, :);
    bestX = zeros(1,length);
    bestY = zeros(1,length);
    bestZ = zeros(1,length);
    for j=1:length;
       bestX(1,j) = cities(1,bestPopPath(1,j));
       bestY(1,j) = cities(2,bestPopPath(1,j));
       bestZ(1,j) = cities(3,bestPopPath(1,j));
    end
title('Genetic Algorithms for TSP');
    plot3(bestX(1,:),bestY(1,:), bestZ(1,:), 'red', 'LineWidth', 1.25);
    legend('Cities', 'Path');
    axis equal
    grid on
    text(-100,99,sprintf('Generation number this path was found: %d Total path distance: %.2f',gNumber, minPath),'FontSize',10);
    drawnow
    hold off
end

