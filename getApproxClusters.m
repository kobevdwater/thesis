%GETAPPROXCLUSTERS get a clustering based on a sampling method.
%parameters:
%   method: The method to use.
%   samplerate: The samplerate to be used in th sampling method.
%   Y: The tensor to cluster
%   k: amount of clusters.
%result
%   Clusters: clustering of the first mode of tensor Y consisting of k
%   clusters.
%Supported methods:
%   Venu: using venuflattening and spectral clustering.
%   FSTD1: using FSTD and ClusterOnTucker1
%   FSTD2: using FSTD and ClusterOnTucker2
%   FSTD3: using FSTD and ClusterOnTucker3
%   ParCube1: using ParCube and ClusterOnCP
%   ParCube2: using ParCube and ClusterOnCP2
%   MACH1: using MACH_HOSVD and ClusterOnTucker1
%   MACH2: using MACH_HOSVD and ClusterOnTucker2
%   MACH3: using MACH_HOSVD and ClusterOnTucker3
%   Random: return random clusters.
function Clusters = getApproxClusters(method, samplerate,Y,k)
    switch method
        case "Venu"
            r = floor(samplerate*size(Y,2)*size(Y,3));
            simMatrix = venuFlatten(Y,r);
            %Clusters = spectralClustering(simMatrix,3,k,'sim');
            Clusters = spectralcluster(simMatrix,k,'Distance','precomputed','LaplacianNormalization','symmetric');
        case "VenuP"
            %r = floor(samplerate*size(Y,1)*size(Y,2));
            %limit r to same amount as dataentries when we would use P
            %instead of Y.
            r = floor(samplerate*size(Y,2)*size(Y,3));
            simMatrix = venuFlattenP(Y,r);
            Clusters = spectralClustering(simMatrix,3,k,'sim');
        case "VenuD"
            r = floor(samplerate*size(Y,2)*size(Y,3));
            [~,Dist] = venuFlatten(Y,r);
            Clusters = spectralClustering(Dist,3,k,'dis');
        case "FSTD1"
            r = floor(sqrt(samplerate*size(Y,1)*size(Y,2)*size(Y,3)/(size(Y,1)+size(Y,2)+size(Y,3))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k,3);
        case "FSTD11"
            r = floor(sqrt(samplerate*size(Y,1)*size(Y,2)*size(Y,3)/(size(Y,1)+size(Y,2)+size(Y,3))));
            [W,Cn] = FSTD1(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k,3);
        case "FSTD2"
            r = floor(sqrt(samplerate*size(Y,1)*size(Y,2)*size(Y,3)/(size(Y,1)+size(Y,2)+size(Y,3))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker2(W,Cn{1,1},k,3);
        case "FSTD3"
            r = floor(sqrt(samplerate*size(Y,1)*size(Y,2)*size(Y,3)/(size(Y,1)+size(Y,2)+size(Y,3))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker3(W,Cn{1,1},k,3);
        case "ParCube1"
            U = ParCube(Y,5,samplerate);
            Clusters = clusterOnCP(U{1,1},k,3);
        case "ParCube2"
            U = ParCube(Y,5,samplerate);
            Clusters = clusterOnCP2(U{1,1},k);
        case "MACH1"
            [G,A1] = MACH_HOSVD(Y,5,5,5,samplerate);
            Clusters = clusterOnTucker(G,A1,k,3);
        case "MACH2"
            [G,A1] = MACH_HOSVD(Y,5,5,5,samplerate);
            Clusters = clusterOnTucker2(G,A1,k,3);
        case "MACH3"
            [G,A1] = MACH_HOSVD(Y,5,5,5,samplerate);
            Clusters = clusterOnTucker3(G,A1,k,3);
        case "Random"
            Clusters = randi(k,1,size(Y,1));
        otherwise 
            warning('unexpected method name')
    end
end