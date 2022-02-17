function Clusters = getCPClusters(method, U, k)
    switch method
        case "CP1"
            Clusters = clusterOnCP(U{1,1},k,3);
        case "CP2"
            Clusters = clusterOnCP2(U{1,1},k);
        otherwise
            warning('unexpected method name '+ method)
    end
end