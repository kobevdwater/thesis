%Create manual clusters for the sensors of the amie dataset. 
%results:
%   limClusters: cluster each limb together.
%   symetryClusters: each cluster consists of its left and right
%       corresponding sensor.
function [limbClusters, symetryClusters] = ManualyClusterSensors()
    AllSensors = h5read('./datasets/Amie/amie-kinect-data.hdf','/skeleton_90/axis0');
    symetryClusters = zeros(1,length(AllSensors)); 
    limbClusters = zeros(1,length(AllSensors));

    index = 1;
    for i=1:length(AllSensors)
        if (contains(AllSensors(i),"Left"))
            symetryClusters(i) = index;
            right = deblank(replace(AllSensors(i),"Left","Right"));
            idx = find(contains(AllSensors, right));
            symetryClusters(idx) = index;
            index = index+1;
        end
    end
    
    for i=1:length(AllSensors)
        if(contains(AllSensors(i),"Ankle"))
            limbClusters(i) = 0;
        end
        if(contains(AllSensors(i),"Elbow"))
            limbClusters(i) = 1;
        end
        if(contains(AllSensors(i),"Foot"))
            limbClusters(i) = 2;
        end
        if(contains(AllSensors(i),"Hand"))
            limbClusters(i) = 3;
        end
        if(contains(AllSensors(i),"HandTip"))
            limbClusters(i) = 4;
        end
        if(contains(AllSensors(i),"Head"))
            limbClusters(i) = 5;
        end
        if(contains(AllSensors(i),"Hip"))
            limbClusters(i) = 6;
        end
        if(contains(AllSensors(i),"Knee"))
            limbClusters(i) = 7;
        end
        if(contains(AllSensors(i),"Neck"))
            limbClusters(i) = 8;
        end
        if(contains(AllSensors(i),"Shoulder"))
            limbClusters(i) = 9;
        end
        if(contains(AllSensors(i),"Spine"))
            limbClusters(i) = 10;
        end
        if(contains(AllSensors(i),"SpineSchoulder"))
            limbClusters(i) = 11;
        end
        if(contains(AllSensors(i),"Thumb"))
            limbClusters(i) = 12;
        end
        if(contains(AllSensors(i),"Wrist"))
            limbClusters(i) = 13;
        end
    end
end