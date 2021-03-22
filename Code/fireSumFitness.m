function [fireSumFitness] = fireSumFitness (droneCapac, fireSum)
   fireSumFitness = (abs(droneCapac - fireSum))^1;
        

end


%     fireSumFitness = floor((droneCapac - fireSum)^1);
%     if (fireSumFitness < -0.5)
%         fireSumFitness = fireSumFitness * 2;
%     else
%     end
