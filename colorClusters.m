
function colorClusters(cl,AllSensors,SensorPositions)
    lnspecs = ["r.","g.",'b.','c.','m.','y.'];
    image = imread("./data/man-shape.png");
    imshow(image);
    hold on;
    for i=1:length(cl)
        plot(SensorPositions(1,i),SensorPositions(2,i), lnspecs(cl(i)), 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off;

end