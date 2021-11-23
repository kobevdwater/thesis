function clusters = cluserOnCP(A1,k,r)
    M = A1';
    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,r,k,'sim');

end

