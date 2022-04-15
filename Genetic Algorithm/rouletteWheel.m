function [node] = rouletteWheel(currentTour, allUsedNodes, numFires)
    node = randi([1, numFires]);
    numIters = 0;
    benchmark = 10;
    while (ismembertol(node, currentTour) == 1 || ismembertol(node, allUsedNodes) == 1 &&numIters < benchmark)
        node = randi([1, numFires]);
        numIters = numIters + 1;
    end
    if numIters > benchmark
        node = [];
    end
end