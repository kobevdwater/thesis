function Clusters = getSOLRADMClusters(Y,r,k)
    sz = size(Y);
    am = prod(sz(3:end),'all');
    Clusters = zeros(am,size(Y,1));
    for i=1:am
        D = Y(:,:,i);
        Dh = SOLRADM(D,25,r);
        Dh = Dh+Dh';
        Dh = max(Dh,0);
        Clusters(i,:) = spectralClustering(Dh,k,"isDist",true);
    end
end