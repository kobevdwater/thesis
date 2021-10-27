%based on paper: Tensor decompositions for feature extraction and
%classification of high dimensional datasets.Phan and Cichocki
function [similarity,clusters] = findingRelatedSensors(D)
    %First we get a low rank TUCKER-2 decomp. (via TUCKER-3)
    [U,S,~] = lmlra(D,[4,4,size(D,3)]);
    S2 = tmprod(S,U{1,3},3);
    %split the frontal slices and vectorise and normalize them.
    M = tens2mat(S2,[1,2],3);
    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,4,2,'sim');
    low_dimM = tsne(M');
    gscatter(low_dimM(:,1),low_dimM(:,2),clusters)
    

end