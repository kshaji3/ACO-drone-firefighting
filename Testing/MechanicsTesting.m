figure

x = [2, 5, 7, 9, 10, 11, 15, 16, 17, 18];
y = [1, 2, 3, 8, 9, 10, 13, 16, 17, 20];
z = [2, 3, 4, 6, 8, 10, 13, 15, 16, 19];

for i = 1: length(x) - 1
    for j = i + 1: length(x)
        x1 = x(i);
        y1 = y(i);
        z1 = z(i);
        
        x2 = x(j);
        y2 = y(j);
        z2 = z(j);
        
        X = [x1 , x2]; 
        Y = [y1 , y2];
        Z = [z1 , z2];
       plot3(X , Y, Z);
       hold on
    end
end
for i = 1 : length(x)
    X = x(:);
    Y = y(:);
    Z = z(:);
    plot3(X,Y, Z, 'ok', 'MarkerSize', 10, 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor' , [ 1, 0.6 , 0.6]);
end

% 
% X = [x(1), x(2)];
% Y = [y(1), y(2)];
% Z = [z(1), z(2)];
% 
% plot3(X, Y, Z)
% hold on
% plot3(X, Y, Z, 'o')
% X = [x(2), x(3)];
% Y = [y(2), y(3)];
% Z = [z(2), z(3)];
% plot3(X, Y, Z)