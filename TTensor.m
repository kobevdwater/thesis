T = zeros(180,75,400);
for i=1:180
    item = sprintf('/skeleton_%d/block0_values',i);
    series = h5read('amie/amie-kinect-data.hdf',item);
    T(i,:,:) = series(:,1:400);
end