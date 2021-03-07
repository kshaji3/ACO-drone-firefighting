function [ fireFitness ] = fireFitnessFunction (fireSum, droneCapac)
    fireFitness = abs(droneCapac - fireSum);
end
