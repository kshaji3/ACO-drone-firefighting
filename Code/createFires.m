function [fires] = createFires(fileName, sheetName) %get fire values
    t = table2cell(readtable(fileName, 'sheet', sheetName));
    %convert from cell to array and transpose it (')
    fires.intensity = cell2mat(t(:, 8))'; 
    %all the values are by default raised to 10^5 (due to actual distances), 
    %so we want to reduce that to save computational power. Distance does 
    %not play a role in the fitness algorithm's decision making, so for 
    %simplicity in the graph we can make this decision.
    fires.locX = cell2mat(t(:, 15))' ./ (10^5); 
    fires.locY = cell2mat(t(:, 16))' ./ (10^5);
    fires.locZ = cell2mat(t(:, 6))';
    
    %control trial values
%     fires.intensity = [1 1 1 2 2 2 3 3 3 4 4 4 5 5 5];
%     fires.locX = [0 0 0 5 5 5 10 10 10 15 15 15 20 20 20];
%     fires.locY = [5 10 15 5 10 15 5 10 15 5 10 15 5 10 15];
%     fires.locZ = [15 10 5 15 10 5 15 10 5 15 10 5 15 10 5];
end
