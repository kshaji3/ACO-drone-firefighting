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
%     if prob >= random;
%         [l, length] = size(parent1Path);
% %         childPath = zeros(l,length);
%         setSize = int8(length/2);
%         offset = randi(setSize);
% 
%         for i = offset : setSize + offset - 1
%             childPath(1,xi) = parent1Path(1,i);
%         end
%         iterator = i+1;
%         j = iterator;
%         while any(childPath == 0);
%             if j > length;
%                 j = 1;
%             end
% 
%             if iterator > length;
%                 iterator = 1;
%             end
%             if ~any(childPath == parent2Path(1,j));
%                 childPath(1,iterator) = parent2Path(1,j);
%                iterator = iterator + 1;
%             end
%             j = j + 1;
%         end
%     else
%         [l, length] = size(parent1Path);
%         %childPath = generateIndividual(length);
%         childPath = parent1Path;
end

