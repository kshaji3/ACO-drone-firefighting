

function [ ] = drawPhromone(tau , graph)

maxTau = max(tau(:));
minTau = min(tau(:));

tau_normalized = (tau - minTau) ./ (maxTau - minTau);

for i = 1 : graph.n -1 
    for j = i+1 : graph.n
        x1 = graph.node(i).x;
        y1 = graph.node(i).y;
        z1 = graph.node(i).z;
        
        x2 = graph.node(j).x;
        y2 = graph.node(j).y;
        z2 = graph.node(j).z;
        
        X = [x1 , x2];
        Y = [y1 , y2];
        Z = [z1, z2];
        
         tau(i , j);
 
        plot3(X,Y,Z, 'color' , [0, 0, (1-tau_normalized(i,j)),  tau_normalized(i,j)] , 'lineWidth', 10.*tau_normalized(i,j) + 1)
 
    end
end

for i = 1 : graph.n
    hold on
    X = [graph.node(:).x];
    Y = [graph.node(:).y];
    Z = [graph.node(:).z];
    plot3(X , Y , Z, 'ok',  'MarkerSize', 10, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', [1 .6 .6])
end


title('All Phromones')
box on

end