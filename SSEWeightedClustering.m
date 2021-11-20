function clusters = SSEWeightedClustering(Y,k,r)
    clusters = clusterTensor(Y,r,k);
    clusters = rebaseClusters(clusters,k);
    sz = size(clusters);
    weights = zeros(1,sz(1));
    for i=1:sz(1)
        weights(i) = 1000/calculateSSE(clusters(i,:),Y(:,:,i));
    end
    clusters = majorityVote(clusters,weights);


    

end