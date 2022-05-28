%Compair spectral and kmeans clustering
%creating non-convex clusters.
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
colors = ['r','b'];
markers = ['+','s'];
figure(); hold on;
for i=1:1000
    plot(points(2,i),points(1,i),'Color',colors(kClusters(i)),'Marker',markers(kClusters(i)));
end
hold off;

sClusters = spectralcluster(points',2);
figure(); hold on;
for i=1:1000
    plot(points(2,i),points(1,i),'Color',colors(sClusters(i)),'Marker',markers(sClusters(i)));
end