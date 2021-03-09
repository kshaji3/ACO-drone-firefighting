function [ fireFitness ] = fireFitnessFunction (ant, droneCapac, totalDrones, totalFires)
    fireFitness = fireSumFitness(droneCapac, ant.fireSum);
    iDronePerFire = totalFires / totalDrones; %ideal drones per fire
    fireFitness = fireFitness + fireEqFitness(iDronePerFire, length(ant.fires));
    for f = 1: length(ant.fires)
        fireFitness = fireFitness + fireIntFitness(droneCapac, iDronePerFire, ant.fires(f));
    end
end
