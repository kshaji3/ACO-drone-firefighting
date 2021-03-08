function [fireIntFitness] = fireIntFitness(droneCapac, iDronePerFire, firePoint)
    fireIntFitness = (abs(droneCapac / iDronePerFire - firePoint))^(1/3);
end