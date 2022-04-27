function Clustering = BestMatrixSSEClustering(Y,k,r)
    clusters = clusterTensor(Y,k);
    result = zeros(size(Y,3),1);
    for i=1:size(clusters,1)
        cluster = clusters(i,:);
        result(i) = calculateSSET(cluster,Y);
%         nrm = norm(Y(:,:,i));
%         for j=1:size(Y,3)
%             result(i) = result(i)+calculateSSE(cluster,Y(:,:,j))/nrm;
%         end
    end
    [~,I] = min(result);
    Clustering = clusters(I,:);
    size(Clustering)
end