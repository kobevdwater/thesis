%COLORSENSORCLUSTERS: color the positions of the sensors based on the
%   clusters. Sensors in the same cluster will have the same color.
%parameters: 
%   cl: a clustering of the sensors.
%   SensorPositions: the position of the sensors.
function colorSensorClusters(cl,SensorPositions)
    lnspecs = ["r+","g+",'b+','c+','m+','y+',"r*","g*",'b*','c*','m*','y*'];
    image = imread("./data/man-shape.png");
    imshow(image);
    hold on;
    for i=1:length(cl)
        plot(SensorPositions(1,i),SensorPositions(2,i), lnspecs(cl(i)), 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off;

end