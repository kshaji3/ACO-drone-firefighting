function [   ]  = drawGraph( graph )
% To visualize the nodes and edges of the graph
% graph.node(:).x
% xValues = tranpose(x)
% plot3(graph.node(:).x, graph.node(:).y, graph.node.z);

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
        Z = [z1 , z2];
        
        plot3(X , Y, Z, '-k');
        hold on
    end
end

for i = 1 : graph.n
    X = [graph.node(:).x];
    Y = [graph.node(:).y ];
    Z = [graph.node(:).z];
    plot3(X,Y, Z, 'ok', 'MarkerSize', 10, 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor' , [ 1, 0.6 , 0.6]);
end

title ('Al nodes and edges')
box('on')

end