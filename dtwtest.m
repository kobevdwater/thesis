item = sprintf('/skeleton_%d/block0_values',160);
a1 = h5read('amie/amie-kinect-data.hdf',item);
item = sprintf('/skeleton_%d/block0_values',98);
a2 = h5read('amie/amie-kinect-data.hdf',item);
a1 = a1(73,:);
a2 = a2(73,:);
a1 = normalize(a1);
a2 = normalize(a2);
dtw(a1,a2);