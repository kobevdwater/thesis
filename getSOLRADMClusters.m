function Clusters = getSOLRADMClusters(Y,r,k)
    Clusters = zeros(size(Y,3),size(Y,1));
    for i=1:size(Y,3)
        D = Y(:,:,i);
        Dh = SOLRADM(D,10,r);
        Dh = Dh+Dh';
        Dh = max(Dh,0);
        Clusters(i,:) = spectralClustering(Dh,k);
    end
end