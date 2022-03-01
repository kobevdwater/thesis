function Clustering = SSEWeightedClustering(Y,k,r)
    clusters = clusterTensor(Y,k);
        
    clusters = rebaseClusters(clusters,k);
    sz = size(clusters);
    weights = zeros(1,sz(1));
    for i=1:sz(1)
        weights(i) = 10000/calculateSSE(clusters(i,:),Y(:,:,i));
    end
    Clustering = majorityVote(clusters,weights);
end