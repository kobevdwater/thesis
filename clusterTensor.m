%CLUSTERTENSOR create clusters via spectral clustering for all distance 
% matrices in a tensor.
%parameters:
%   T: stack of distance matrices via 3th mode. Di = T(:,:,i)
%   dim: dimention of features used in spectral clustering. 
%   k: nb of clusters. 
%returns:
%   Clusters: a clustering for all distance matrices.
%See also SPECTRALCLUSTERING
function Clusters = clusterTensor(T,dim,k)
    sz = size(T);
    Clusters = zeros(sz(3),sz(1));
    for i =1:sz(3)
        Clusters(i,:) = spectralClustering(T(:,:,i),dim,k);
    end

    
end