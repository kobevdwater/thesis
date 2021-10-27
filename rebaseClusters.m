function newClusters = rebaseClusters(Clusters,nbOfClusters)
    newClusters = zeros(size(Clusters));
    newClusters(1,:) = Clusters(1,:);
    for i=2:size(Clusters,1)
        newClusters(i,:)  = rebaseCluster(Clusters(1,:),Clusters(i,:),nbOfClusters);
    end
end