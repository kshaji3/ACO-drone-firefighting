function [fireFitness] = fireFitnessFunction(indPop, droneCapac, totalDrones, totalFires)
    if isempty(indPop.tour) == 1
        fireFitness = 100000;
    else
        fireTotDiffFit = fireSumFitness(droneCapac, indPop.fireSum);
        iDronePerFire = totalFires / totalDrones;
        fireEqFit = fireEqFitness(iDronePerFire, length(indPop.fires));
        fireIntFit = 0;
        for f = 1: length(indPop.fires)
            fireIntFit = fireIntFit + fireIntFitness(droneCapac, iDronePerFire, ...
                indPop.fires(f));
        end
        fireFitness = fireTotDiffFit + fireEqFit + fireIntFit;
    end
end
