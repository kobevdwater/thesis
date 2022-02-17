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
            Clusters = SSEWeightedClustering(Y,k,3);
        case "Venu"
            Sim = venuFlatten(Y);
            Clusters = spectralClustering(Sim,3,k,'sim');
        otherwise
            warning('unexpected other method name '+ method)
    end
end