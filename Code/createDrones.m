function [drones] = createDrones(fires, droneNo)
    drones.capac = zeros(1, droneNo);
    for i = 1: droneNo
        drones.capac(1, i) = mean(fires.intensity) * (length(fires.locX) / droneNo);
    end
    %[3 6 9 12 15];
    drones.locX = zeros(1, droneNo);
    for i = 1: droneNo
        drones.locX(i) = min(fires.locX) + (max(fires.locX) - min(fires.locX)) / droneNo * i;
    end
    %drones.locX = [0 5 10 15 20];
    
    drones.locY = zeros(1, droneNo);
    for i = 1: droneNo
        drones.locY(i) = min(fires.locY) - 0.25;
    end
    %drones.locY = [0 0 0 0 0];
end
