%BESTMATRIXCLUSTERING: create a clustering for the distancetensor by
%   chosing the best clustering from all slices. This is the clustering
%   with the lowest SSET of all the clusterings of the slices.
%parameters: 
%   Y: distancetensor that contains the entities to be clustered.
%   k: amount of clusters.
%result: 
%   Clustering: a clustering for the given distancetensor.
%       
function Clustering = BestMatrixSSEClustering(Y,k,~)
    clusters = clusterTensor(Y,k);
    result = zeros(size(Y,3),1);
    for i=1:size(clusters,1)
        cluster = clusters(i,:);
        result(i) = calculateSSET(cluster,Y);
    end
    [~,I] = min(result);
    Clustering = clusters(I,:);
end