function Clusters = getOtherClusters(method,Y,k)
    switch method
        case "Random"
            [I,~,~] = size(Y);
            Clusters = randi(k,1,I);
        case "Ex"
            [I,~,~] = size(Y);
            info
            Clusters = info(2,1:I);
        case "Weighted"
            Clusters = SSEWeightedClustering(Y,k,10);
        case "BestMatrix"
            Clusters = BestMatrixSSEClustering(Y,k,10);

        case "Venu"
            Sim = venuFlatten(Y);
            Clusters = spectralClustering(Sim,k);
        case "SFC"
            Clusterings = clusterTensor(Y,k);
            Sim = SimFromClusterings(Clusterings);
            Clusters = spectralClustering(Sim,k);
        otherwise
            warning('unexpected other method name '+ method)
    end
end