function [nextNode] = rouletteWheel( P )
%Roulette wheel to choose next edge based on P values
    consumP = consum(P);
    r = rand();
    nextNode = find(r <= cumsumP);
    nextNode = nextNode(i);
end
