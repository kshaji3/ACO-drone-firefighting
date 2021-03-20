t = readtable('../data-manipulation/northeast-samples.xlsx', 'sheet', 'Sheet1')
t = table2cell(t)

fireCoords = cell2mat(t(:, 8))'
xCoords = cell2mat(t(:, 15))'
yCoords = cell2mat(t(:, 16))'
plot(xCoords, yCoords)