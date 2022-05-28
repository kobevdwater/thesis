%CLUSTERONCP: make a clustering based on the CP decomposition of a tensor.
% Uses spectral clustering.
%parameters:
%   A1: The factor matrix of the mode you want to cluster.
%   k: number of clusters.
%   r: dimentions used for spectral clustering.
%   A2: factor matrix of the second mode. If given, both the firs and the
%       second factor matrix will be used to construct a similarity matrix.
%returns:
%   clusters: The clustering of the given mode.
function clusters = clusterOnCP(A1,k,A2)
    M = A1';
    M = M./vecnorm(M);
    if exist('A2','var')
        M2 = A2'./vecnorm(A2');
        %M2 can contain 0-rows when using parcube.
        M2(isnan(M2)) = 0;
        similarity = M'*M2;
        %making sim symetric for use in spectral clustering.
        similarity = (similarity+similarity')/2;
    else
        similarity = M'*M;
    end
    similarity = max(similarity,0);
    clusters = spectralClustering(similarity,k);

end
