%Testing and plotting different ways to make splines for the basis of the C
% tensor.
hold on;
nbPoints = 5;
for i=1:5

    xs = zeros(1,nbPoints);
    ys = zeros(1,nbPoints);
    xs(1) = rand()*3;
    ys(1) = rand()*3;
    angle = 2*pi*rand();
    for j=2:nbPoints
        %Chosing new angel between -+135 degrees from old angle
        nangle = (rand()-0.5)*pi*1.5; 
        angle = angle+nangle;
        xs(j) = xs(j-1)+1*cos(angle);
        ys(j) = ys(j-1)+1*sin(angle);
    end
    xs = xs-sum(xs)/length(xs);
    ys = ys-sum(ys)/length(ys);
    sum(xs)
    t = 1:nbPoints;
    pts = linspace(1,nbPoints);
    xx = spline(t,xs,pts);
    yy = spline(t,ys,pts);

    plot(ys,xs,'o');
    plot(yy,xx);
    for k=1:50
        ind = randi(100);
        xi = xx(ind)+(rand()-0.5)*0.5;
        yi = yy(ind)+(rand()-0.5)*0.5;
        plot(yi,xi,'r.');
    end
end
hold off;
