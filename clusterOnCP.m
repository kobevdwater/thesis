%CLUSTERONCP: make a clustering based on the CP decomposition of a tensor.
% Uses spectral clustering.
%parameters:
%   A1: The factor matrix of the mode you want to cluster.
%   k: number of clusters.
%   r: dimentions used for spectral clustering.
%returns:
%   clusters: The clustering of the given mode.
function clusters = clusterOnCP(A1,k,r)
    M = A1';
    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,r,k,'sim');

end
