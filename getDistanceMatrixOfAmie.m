%GETDISTANCEMATRIXOFAMIE get a distance matrix from a subset of the the amie dataset.
%parameters: 
%   nbIndv: number of individuals that get chosen randomly to be included.
%   depth: number of sensors that get chosen randomly to be included.
%returns:
%   distanceMatrix: the distancematrix of the selected individuals and
%       sensors. Will be of size (nbIndv,nbIndv,depth)
%   exersise: the exersise of the chosen individuals.
%
function [distanceMatrix,exersise,sensorType] = getDistanceMatrixOfAmie(nbIndv,depth)
    distanceMatrix = zeros(nbIndv,nbIndv,depth);
    %timeSeries;
    individuals = randperm(120,nbIndv);
    Allexercises = h5read('amie/amie-kinect-data.hdf','/overview/block0_values');
    exersise = zeros(nbIndv,1);
    AllSensors = h5read('amie/amie-kinect-data.hdf','/skeleton_90/axis0');
    sensorType = AllSensors([1:depth])
    for i = 1:nbIndv
        item = sprintf('/skeleton_%d/block0_values',individuals(i));
        timeSeries(i).data = h5read('amie/amie-kinect-data.hdf',item);         
        exersise(i) = Allexercises(individuals(i));
    end


    for i = 1:nbIndv
        for j = 1:nbIndv
            for k = 1:depth
                fprintf('i: %d; j: %d; k: %d \n',i,j,k)
                distanceMatrix(i,j,k) = dtwDistance(timeSeries(i).data(k,:),timeSeries(j).data(k,:));
            end
        end
    end    
end

function sm = testDistance(a1,a2)
    sm = 0;
    for i = 1:min(length(a1),length(a2))
        sm = sm + (a1(i)-a2(i))^2;
    end
    sm = sqrt(sm);

end