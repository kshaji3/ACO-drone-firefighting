function [ fireFitness, fireTotDiffFit, fireEqFit, fireIntFit ] = fireFitnessFunction (ant, droneCapac, totalDrones, totalFires)
    if length(ant.tour) == 0
        fireFitness = 10000;
        fireTotDiffFit = 10000;
        fireEqFit = 10000;
        fireIntFit = 10000;
    else
        fireTotDiffFit = 0.01 + fireSumFitness(droneCapac, ant.fireSum);
        fireFitness = fireTotDiffFit;
        iDronePerFire = totalFires / totalDrones; %ideal drones per fire
        fireEqFit = fireEqFitness(iDronePerFire, length(ant.fires));
        fireFitness = fireFitness + fireEqFit;
        fireIntFit = 0;
        for f = 1: length(ant.fires)
            fireIntFit = fireIntFit + fireIntFitness(droneCapac, iDronePerFire, ant.fires(f));
        end
        fireFitness = fireFitness + fireIntFit;
    end
end
