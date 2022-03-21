function [node] = rouletteWheel(currentTour, allUsedNodes, numFires)
    node = randi(1, numFires);
    while (ismembertol(node, currentTour) == 1 && ismembertol(node, allUsedNodes) == 1)
        node = randi(1, numFires);
    end
end