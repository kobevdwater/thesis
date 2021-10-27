function Clusters = clusterTensor(T,dim,k)
    sz = size(T);
    Clusters = zeros(sz(3),sz(1));
    for i =1:sz(3)
        Clusters(i,:) = spectralClustering(T(:,:,i),dim,k);
    end

    
end