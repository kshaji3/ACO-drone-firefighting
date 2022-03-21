function [fires] = generateCities(fileName, sheetName)
%generateCities Generates cities on random locations.

%    cities = rand(3,numberOfCities) * range;
    t = table2cell(readtable(fileName, 'sheet', sheetName));
    fires.intensity = cell2mat(t(:, 8))';
    
    %row 1 = x, row 2 = y, row 3 = z
    fires.loc(1,:) = cell2mat(t(:, 15))' ./ (10^5); 
    fires.loc(2,:) = cell2mat(t(:, 16))' ./ (10^5);
    fires.loc(3,:) = cell2mat(t(:, 6))';
  
end

