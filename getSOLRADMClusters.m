%GETSOLRADMCLUSTERS: get clusters of third order slices using solradm.
%parameters:
%   Y: the tensor to cluster.
%   a: nb of items to use in each mode.
%   k: nb of clusters.
function Clusters = getSOLRADMClusters(Y,a,k)
    sz = size(Y);
    r1 = floor(sz(1)*a);
    am = prod(sz(3:end),'all');
    r3 = floor(am*a);
    Clusters = zeros(r3,size(Y,1));
    slices = datasample(1:am,r3,'replace',false);
    for i=1:r3
        slice = slices(i);
        D = Y(:,:,slice);
        Dh = SOLRADM(D,25,r1);
        Dh = Dh+Dh';
        Dh = max(Dh,0);
        Clusters(i,:) = spectralClustering(Dh,k,"isDist",true);
    end
end