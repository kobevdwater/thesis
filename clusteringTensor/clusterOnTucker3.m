%CLUSTERONTUCKER3: Make a clustering based on the Tucker decomposition.
% Uses the factor matrix of the first mode to do kmeans clustering.
%parameters:
%   G: The core of the TUCKER decomposition. (Not used in calculation)
%   A1: The factor matrix of the mode you want to cluster.
%   k: Number of clusters.
%returns:
%   clusters: The clustering of the first mode.
function clusters = clusterOnTucker3(G,A1,k)
       clusters = kmeans(A1,k);
 
end
    