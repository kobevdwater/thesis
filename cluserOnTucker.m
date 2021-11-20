function clusters = cluserOnTucker(G,A1,k,r)
    S2 = tmprod(G,A1,1);
    %split the frontal slices and vectorise and normalize them.
    M = tens2mat(S2,[2,3],1);

    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,r,k,'sim');
    %low_dimM = tsne(M');
    %gscatter(low_dimM(:,1),low_dimM(:,2),clusters)