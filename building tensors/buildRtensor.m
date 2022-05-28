%BUILDRTENSOR: build a sythetic tensor. The individual distancematrices are
%   based on 2d convex clusters.
%parameters: 
%   sz: size of the tensor. sz(1) and sz(2) should be the same.
%   k: nb of clusters used in creating the tensor.
%   options.maxMean: the maximum x and y values for the centroid.
%   options.sigma: the simga of the normal distribution of the difference
%       of the centroid and the points.
%   options.visualize: visualize the points used to ceate the tensor. 
%       Will create one figure for each slice.
%results:
%   R: distance tensor of the given size.
%   Rp: distance tensor with the entities in the tird mode. Compairs
%       different slices. Will always be transformed to a 3d tensor.
%   expected: the clusters of the entities of R.
function [R,Rp,expected] = buildRtensor(sz,k,options)
    arguments
        sz
        k;
        options.maxMean = 10
        options.sigma = 5
        options.visualize = false
    end
    assert(sz(1) == sz(2));
    expected = randi(k,1,sz(1));
    nmslc = prod(sz(3:end),'all');

    R = zeros(sz);
    Rp = zeros([nmslc,nmslc,sz(1)]);
    valuesStore = zeros(nmslc,2,sz(1));
    for i=1:nmslc
        means = rand(2,k).*options.maxMean;
        values = normrnd(means(:,expected),options.sigma);
        D = squareform(pdist(values'));
        R(:,:,i) = D;
        valuesStore(i,:,:) = values;
        if options.visualize
            figure(); hold on;
            gscatter(values(1,:),values(2,:),expected);
        end
    end
    
    %building Rp
    for i=1:sz(1)
        values = squeeze(valuesStore(:,:,i));
        D = squareform(pdist(values));
        Rp(:,:,i) = D;
    end

    

end
