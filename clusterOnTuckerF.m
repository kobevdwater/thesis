%CLUSTERONTUCKER: Make a clustering based on the TUCKER-2 decomposition of a tensor.
% Uses the slices of the TUCKER-2 decompsiton as feature vector for
% spectral clustering.
%parameters:
%   A1: The factor matrix of the mode you want to cluster.
%   G: The core of the TUCKER decomposition.
%   k: Number of clusters.
%   r: dimentions used for spectral clustering.
%returns:
%   clusters: The clustering of the first mode.
function clusters = clusterOnTuckerF(G,A1,k)
    S2 = tmprod(G,A1,1);
    ln = length(size(S2));
    %split the frontal slices and vectorise and normalize them.
    M = tens2mat(S2,2:ln,1);

    M = M./vecnorm(M);
    %we can use this similarity matrix to cluster the sens.
    clusters = spectralClustering(M',k,"preComputed",false);