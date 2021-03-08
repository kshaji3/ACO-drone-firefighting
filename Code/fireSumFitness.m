function [fireSumFitness] = fireSumFitness (droneCapac, fireSum)
   fireSumFitness = (abs(droneCapac - fireSum))^1;
end