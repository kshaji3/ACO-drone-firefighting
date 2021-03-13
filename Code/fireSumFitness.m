function [fireSumFitness] = fireSumFitness (droneCapac, fireSum)
   fireSumFitness = floor((abs(droneCapac - fireSum))^1);
end