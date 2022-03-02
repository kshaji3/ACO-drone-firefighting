function [time] = greedySolver(graph, fires, droneNo, indHoriz, indVert)
    timeStart = tic;
    [drones] = createDrones(fires, droneNo);
    maxLoops = 10;
    maxPerLoop = 50;
    bestPathFitness = 1000;
    
    drones.uCapac = drones.capac;    
    fires.uIntensity = fires.intensity;
    droneIndex = 1;
    fires.uIntensity = fires.intensity;
    for i = 1: length(fires)
        while (~(droneIndex > droneNo) && fires.uIntensity(1, i) ~= 0)
            %drones with no fire extinguisher are not rerouted
            if (drones.uCapac <= 0.05)
                droneIndex = droneIndex + 1;
            %routing drones and setting new fire values for fires that require
            %the drone to expend all of its fire extinguisher
            
            elseif (fires.uIntensity(1, i) - drones.uCapac >= 0)    
                fires.uIntensity(1, i) = fires.uIntensity(1, i) - drones.uCapac;
                drones.capac(1, droneIndex)  = 0;
                droneIndex = droneIndex + 1;
            %if the drone has fire extinguisher left after fighting one fire
            else
                drones.uCapac = drones.uCapac - fires.uIntensity(1, i);
                fires.uIntensity(1, i) = 0;
            end
        end
    end
    time = toc(timeStart);
end