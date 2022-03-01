function Clusters = getFSTDClusters(Y,r,k)
    [W,Cn] = FSTD(Y,r);
    Ya = lmlragen(Cn,W);
    Clusters = zeros(size(Y,3),size(Y,1));
    for i=1:size(Y,3)
        Dh = Ya(:,:,i);
        Dh = Dh+Dh';
        Clusters(i,:) = spectralClustering(Dh,k);
    end