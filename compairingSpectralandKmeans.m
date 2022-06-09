%Compairing spectral and kmeans clustering on non-convex clusters.
%Creation of two c-shaped clusters.
xs = [0.5, -0.5, 0.5; 0,1,0];
ys = [1,2,3;0,1,2];
t = 1:3;
pts = linspace(1,3,500);
xx = spline(t,xs,pts);
yy = spline(t,ys,pts);
points(1,:) = arrayfun(@(x) (x+(rand()-0.5)*0.1 ),xx(:));
points(2,:) = arrayfun(@(x) (x+(rand()-0.5)*0.1 ),yy(:));
plot(points(2,:),points(1,:),'.');

kClusters = kmeans(points',2);
figure;gscatter(points(1,:),points(2,:),kClusters);

sClusters = spectralcluster(points',2);
figure;gscatter(points(1,:),points(2,:),sClusters);