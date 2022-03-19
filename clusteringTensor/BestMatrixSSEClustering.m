%BESTMATRIXSSECLUSTERING: Get a clustering by clustering all third order
%slices and chosing the best one based on the SSE of the whole tensor.
%parameters: 
%   Y: the tensor to cluster. Must be a distance tensor.
%   k: amount of clusters.
%result:
%   Clustering: A clustering of the first mode of Y.
function Clustering = BestMatrixSSEClustering(Y,k,r)
    clusters = clusterTensor(Y,k);
    result = zeros(size(Y,3),1);
    for i=1:size(clusters,1)
        cluster = clusters(i,:);
        nrm = norm(Y(:,:,i));
        for j=1:size(Y,3)
            result(i) = result(i)+calculateSSE(cluster,Y(:,:,j))/nrm;
        end
    end
    [~,I] = min(result);
    Clustering = clusters(I,:);
end