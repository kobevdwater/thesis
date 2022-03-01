%CLUSTERONCP2: make a clustering based on the CP decomposition of a tensor.
% Uses kmeans clustering to cluster directly on the factor matrix.
%parameters:
%   A1: The factor matrix of the mode you want to cluster.
%   k: number of clusters.
%returns:
%   clusters: The clustering of the given mode.
function clusters = clusterOnCP2(A1,k)
    clusters = kmeans(A1,k);

end
