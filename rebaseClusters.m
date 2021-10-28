%REBASECLUSTERS rebase multiple clusters to the first cluster.
%parameters:
%   Clusters: matrix with a clustering in each row.
%   nbOfClusters: the number of clusters in the clusterings.
%returns:
%   newClusters: matrix with clusterings where each clustering is rebased
%       to the first clustering.
%See also REBASECLUSTER
function newClusters = rebaseClusters(Clusters,nbOfClusters)
    newClusters = zeros(size(Clusters));
    newClusters(1,:) = Clusters(1,:);
    for i=2:size(Clusters,1)
        newClusters(i,:)  = rebaseCluster(Clusters(1,:),Clusters(i,:),nbOfClusters);
    end
end