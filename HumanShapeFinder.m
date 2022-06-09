%Finding the points of the limbs of the human on the picture. Result is
%used to visualize the clustered sensors.
%Manualy annotate the position on the left side of the image. 
%See colorSensorClusters

%image used: https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.clipartbest.com%2Fhuman-shape-outline&psig=AOvVaw2ubLDawPd5OhLtcSoECBTO&ust=1653846402970000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCIDOt4_ggvgCFQAAAAAdAAAAABAD
d1 = imread('data/man-shape.png');
lims = ["Ankle","Elbow","Foot","Hand","HandTip","Head","Hip","Knee","Neck","Shoulder","SpineBase","SpineMid","SpineShoulder","Thumb","Wrist"];
axis ij;
axis manual;
[m n] = size(d1);
axis([0 m 0 n])
imshow(d1);
PartLimPositions = zeros(2,length(lims));

%Manualy annotate all limbs on the image. At the left side or middel of the image.
for i = 1:length(lims)
    lims(i)
    coordinates_input = ginput(1)
    PartLimPositions(:,i) = round(coordinates_input);
end
%Reading the name of all sensors.
AllSensors = h5read('./datasets/Amie/amie-kinect-data.hdf','/skeleton_90/axis0');
LimPositions = zeros(2,length(AllSensors));
%Auto-complete all sensors on the right side.
for i=1:length(LimPositions)
    leftPosition = [0,0];
    for j=1:length(lims)
        if (AllSensors(i).startsWith(lims(j)))
            leftPosition = PartLimPositions(:,j);
        end
    end
    if (AllSensors(i).contains("Left"))
        LimPositions(:,i) = leftPosition;
    elseif (AllSensors(i).contains("Right"))
        LimPositions(:,i) = [n-leftPosition(1),leftPosition(2)];
    else 
        LimPositions(:,i) = [round(n/2),leftPosition(2)];
    end
end
hold on;
for i=1:length(LimPositions)
    plot(LimPositions(1,i),LimPositions(2,i), 'r+', 'MarkerSize', 7, 'LineWidth', 2);
end
hold off;
SingleLimbPositions = zeros(2,25);
j=1;
%Add x,y and z ofsets for each sensor.
for i=1:length(LimPositions)
    str = deblank(AllSensors(i));
    if (endsWith(str,"X"))
        SingleLimbPositions(:,j) = LimPositions(:,i);
        LimPositions(1,i) = LimPositions(1,i)-20;
        j = j+1;
    elseif (endsWith(str,"Y"))
        LimPositions(1,i) = LimPositions(1,i)+20;
    elseif (endsWith(str,"Z"))
        LimPositions(2,i) = LimPositions(2,i)-20;
    end
end
%Visualize the found points.
hold on;
for i=1:length(LimPositions)
    plot(LimPositions(1,i),LimPositions(2,i), 'g.', 'MarkerSize', 7, 'LineWidth', 2);
end
for j=1:length(SingleLimbPositions)
    plot(SingleLimbPositions(1,j),SingleLimbPositions(2,j),'r*');
end
hold off;

