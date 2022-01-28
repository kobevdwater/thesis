%CLUSTERONTUCKER2: Make a clustering based on the Tucker decomposition.
% Uses the factor matrix of the first mode to create a similarity matrix
% that is used in spectral clustering.
%parameters:
%   G: The core of the TUCKER decomposition. (Not used in calculation)
%   A1: The factor matrix of the mode you want to cluster.
%   k: Number of clusters.
%   r: dimentions used for spectral clustering.
%returns:
%   clusters: The clustering of the first mode.
function clusters = clusterOnTucker2(G,A1,k,r)
    M = A1';
    M = M./vecnorm(M);

%     dist_temp = pdist(M');
%     dist = squareform(dist_temp);
%     clusters = spectralClustering(dist,r,k,'dis');
    similarity = M'*M;
    similarity = max(similarity,0);
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,r,k,'sim');

end