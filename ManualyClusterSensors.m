AllSensors = h5read('amie/amie-kinect-data.hdf','/skeleton_90/axis0');
symetryClusters = zeros(1,length(AllSensors));
limClusters = zeros(1,length(AllSensors));

index = 1;
for i=1:length(AllSensors)
    if (contains(AllSensors(i),"Left"))
        symetryClusters(i) = index;
        right = deblank(replace(AllSensors(i),"Left","Right"))
        idx = find(contains(AllSensors, right))
        symetryClusters(idx) = index;
        index = index+1;
    end
end

for i=1:length(AllSensors)
    if(contains(AllSensors(i),"Ankle"))
        limClusters(i) = 0;
    end
    if(contains(AllSensors(i),"Elbow"))
        limClusters(i) = 1;
    end
    if(contains(AllSensors(i),"Foot"))
        limClusters(i) = 2;
    end
    if(contains(AllSensors(i),"Hand"))
        limClusters(i) = 3;
    end
    if(contains(AllSensors(i),"HandTip"))
        limClusters(i) = 4;
    end
    if(contains(AllSensors(i),"Head"))
        limClusters(i) = 5;
    end
    if(contains(AllSensors(i),"Hip"))
        limClusters(i) = 6;
    end
    if(contains(AllSensors(i),"Knee"))
        limClusters(i) = 7;
    end
    if(contains(AllSensors(i),"Neck"))
        limClusters(i) = 8;
    end
    if(contains(AllSensors(i),"Shoulder"))
        limClusters(i) = 9;
    end
    if(contains(AllSensors(i),"Spine"))
        limClusters(i) = 10;
    end
    if(contains(AllSensors(i),"SpineSchoulder"))
        limClusters(i) = 11;
    end
    if(contains(AllSensors(i),"Thumb"))
        limClusters(i) = 12;
    end
    if(contains(AllSensors(i),"Wrist"))
        limClusters(i) = 13;
    end
end