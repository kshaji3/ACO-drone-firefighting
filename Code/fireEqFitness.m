function [ fireEqFitness ] = fireEqFitness (iDronePerFire, length)
    %if fire number is equal across them.
   fireEqFitness = (abs(iDronePerFire - length))^(1/2); %1/2 3/4 %^
end