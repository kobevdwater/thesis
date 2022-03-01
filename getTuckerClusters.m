%GETTUCKERCLUSTERS get clusters based on a Tucker decomposition
%parameters:
%   method: The method to use


function Clusters = getTuckerClusters(method,G,U,k)
    switch method
        case "Tucker1"
            Clusters = clusterOnTucker(G,U{1,1},k);
        case "Tucker2"
            Clusters = clusterOnTucker2(G,U{1,1},k);
        case "Tucker3"
            Clusters = clusterOnTucker3(G,U{1,1},k);
        otherwise
            warning('unexpected method name'+method);
    end
end