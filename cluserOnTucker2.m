function clusters = cluserOnTucker2(G,A1,k)
    S2 = tmprod(G,A1,1);
    %split the frontal slices and vectorise and normalize them.
    %M = tens2mat(S2,[2,3],1);
    M = A1';
    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,4,k,'sim');