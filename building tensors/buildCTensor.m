%BUILDCTENSOR create a non-convex C tensor. The points used to create each
%slice will be based on splines. The points of each cluster will be placed
%around the spline.
%parameters:
%   sz: the size of the resulting tensor
%   k: number of clusters
%   nbPoints: the number of points in the spline used as basis for the
%   clustes.
%result:
%   C: distancetensor of the given size with the given amount of clusters.
%   expected: the clusters to which the points in C belong.
function [C,expected] = buildCTensor(sz,k,nbPoints)
    assert(sz(1) == sz(2),'Expected the first and second dimention of the size to be the same.');
    expected = randi(k,1,sz(1));
    C = zeros(sz);
    nmslc = prod(sz(3:end),'all');
    %rnd: point to which a given point belongs on the curve. Will be the
    %same for each slice. This keeps the tensor from becoming convex.
    rnd = randi(100,1,length(expected));
    for i=1:nmslc
        xvals = zeros(k,100);
        yvals = zeros(k,100);
        for cv=1:k
            [xvals(cv,:),yvals(cv,:)] = getCurve(nbPoints);
        end
        points = zeros(2,sz(1));
        points(1,:) = arrayfun(@(x) (xvals(expected(x),rnd(x))+(rand()-0.5)*0.5 ),1:length(expected));
        points(2,:) = arrayfun(@(x) (yvals(expected(x),rnd(x))+(rand()-0.5)*0.5 ),1:length(expected));
        if false
            figure(); hold on;
            gscatter(points(1,:),points(2,:),expected);
        end
        D = squareform(pdist(points'));
        C(:,:,i) = D;
    end
end


%GETCURVE: create a curve based on a spline.
%parameters:
%   nbPoints: the number of points of the spline.
%result
%   [xvals,yvals]: 100 coordinates of the resulting spline.
function [xvals,yvals] = getCurve(nbPoints)
    a = 3;  % length of the segments between points
    b = 1;  % max angle change
    c = 3;  % max mean of points
    %creating points for curve.
    xs = zeros(1,nbPoints);
    ys = zeros(1,nbPoints);
    angle = 2*pi*rand();
    for j=2:nbPoints
        %Chosing new angel between -+90 degrees from old angle
        nangle = (rand()-0.5)*b*pi; 
        angle = angle+nangle;
        xs(j) = xs(j-1)+a*cos(angle);
        ys(j) = ys(j-1)+a*sin(angle);
    end
    xs = xs - sum(xs)/length(xs)+(rand()-0.5)*2*c;
    ys = ys - sum(ys)/length(ys)+(rand()-0.5)*2*c;
    % Creating spline
    t = 1:nbPoints;
    pts = linspace(1,nbPoints);
    xvals = spline(t,xs,pts);
    yvals = spline(t,ys,pts);
end
