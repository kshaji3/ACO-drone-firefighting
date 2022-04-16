function [fireSumFitness] = fireSumFitness(droneCapac, fireSum)
   %difference between total amount of drone capacity vs. fires
   %extinguished's fire retardant requirements
   if (droneCapac < fireSum)
       fireSumFitness = 10000;
   else
    fireSumFitness = (abs(droneCapac - fireSum))^1;
   end    

end


%     fireSumFitness = floor((droneCapac - fireSum)^1);
%     if (fireSumFitness < -0.5)
%         fireSumFitness = fireSumFitness * 2;
%     else
%     end
