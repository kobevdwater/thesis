k = 9;
initialize
load("./data/limbs.mat");
[U,G] = mlsvd(Xn,[10,10,10,3]);
sz = size(G);
Gt = tens2mat(G,3,[1,2,4]);
Gt = mat2tens(Gt,[sz(3),sz(1),sz(2),sz(4)],1);
Clusters = clusterOnTucker(Gt,U{1,3},k);
colorClusters(Clusters,SingleLimbPositions);

[U,G] = mlsvd(XPn,[10,10,10,3]);
Clusters = clusterOnTucker(G,U{1,1},k);
figure;colorClusters(Clusters,SingleLimbPositions);

Clusters = getApproxClusters("Venu",0.03,XPn,k);
figure;colorClusters(Clusters,SingleLimbPositions);

