%Visualization of two timeseries and their matched dtw-signals.
% uses person 160 and 98 and sensor 73.
item = sprintf('/skeleton_%d/block0_values',160);
a1 = h5read('./datasets/Amie/amie-kinect-data.hdf',item);
item = sprintf('/skeleton_%d/block0_values',98);
a2 = h5read('./datasets/Amie/amie-kinect-data.hdf',item);
a1 = a1(73,:);
a2 = a2(73,:);
a1 = normalize(a1);
a2 = normalize(a2);
figure();
hold on; plot(a1); plot(a2); hold off;

a1 = normalize(a1);
a2 = normalize(a2);
figure;
dtw(a1,a2);