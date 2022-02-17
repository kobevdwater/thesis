%Finding the points of the limbs of the human on the picture. 
d1 = imread('data/man-shape.png');
lims = ["Ankle","Elbow","Foot","Hand","HandTip","Head","Hip","Knee","Neck","Shoulder","SpineBase","SpineMid","SpineShoulder","Thumb","Wrist"];
axis ij;
axis manual;
[m n] = size(d1);  %%d1 is the image which I want to display
axis([0 m 0 n])
imshow(d1);
PartLimPositions = zeros(2,length(lims));
%Manualy annotate all limbs on the image. At the left side or middel of the image.
for i = 1:length(lims)
    lims(i)
    coordinates_input = ginput(1)
    PartLimPositions(:,i) = round(coordinates_input);
end
AllSensors = h5read('amie/amie-kinect-data.hdf','/skeleton_90/axis0');
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

for i=1:length(LimPositions)
    str = deblank(AllSensors(i));
    if (endsWith(str,"X"))
        LimPositions(1,i) = LimPositions(1,i)-20;
    elseif (endsWith(str,"Y"))
        LimPositions(1,i) = LimPositions(1,i)+20;
    elseif (endsWith(str,"Z"))
        LimPositions(2,i) = LimPositions(2,i)-20;
    end
end
hold on;
for i=1:length(LimPositions)
    plot(LimPositions(1,i),LimPositions(2,i), 'g.', 'MarkerSize', 7, 'LineWidth', 2);
end
hold off;

