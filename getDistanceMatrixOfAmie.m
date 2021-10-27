function [distanceMatrix,exersise] = getDistanceMatrixOfAmie(nbIndv,depth)
    distanceMatrix = zeros(nbIndv,nbIndv,depth);
    %timeSeries;
    individuals = randperm(120,nbIndv);
    Allexercises = h5read('amie/amie-kinect-data.hdf','/overview/block0_values');
    exersise = zeros(nbIndv,1);

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