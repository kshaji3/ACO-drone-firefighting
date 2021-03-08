function [ fireFitness ] = fireFitnessFunction (ant, droneCapac, totalDrones, totalFires)
    fireFitness = (abs(droneCapac - ant.fireSum))^1;
    iDronePerFire = totalFires / totalDrones; %ideal drones per fire
    fireFitness = fireFitness + (abs(iDronePerFire - length(ant.fires)))^(1/2);
    for f = 1: length(ant.fires)
        fireFitness = fireFitness + (abs(droneCapac / iDronePerFire - ant.fires(f)))^(1/3);
    end
end
