function [ childPath ] = crossover( parent1Path, parent2Path, prob, drones, environment, droneNo )
% Generating child path from given two parent pathes by using ordered one
% crossover method.
    random = rand();
    childPath = [];
    intensity = 0;
    if prob >= random
        cutPoint = randi(length(parent1Path));
        for i = 1: cutPoint
            childPath = [childPath, parent1Path(i)]; 
            intensity = intensity + environment.fires.intensity(parent1Path(i));
        end
        for i = 1: length(parent2Path)
            if (ismembertol(parent2Path(i), childPath) == 0)
                if (intensity + ...
                        environment.fires.intensity(parent2Path(i)) < ...
                        drones(droneNo).capac)
                    childPath = [childPath, parent2Path(i)];
                end
            end
        end
    else
        childPath = parent1Path;
    end
end

