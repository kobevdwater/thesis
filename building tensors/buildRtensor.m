function [R,Rp,expected] = buildRtensor(sz,k,options)
    arguments
        sz
        k;
        options.maxMean = 10
        options.sigma = 5
    end
    assert(sz(1) == sz(2));
    expected = randi(k,1,sz(1));
    R = zeros(sz);
    Rp = zeros([sz(3),sz(3),sz(1)]);
    valuesStore = zeros(sz(3),2,sz(1));
    nmslc = prod(sz(3:end),'all');
    for i=1:nmslc
        means = rand(2,k).*options.maxMean;
        values = normrnd(means(:,expected),options.sigma);
        D = squareform(pdist(values'));
        R(:,:,i) = D;
        valuesStore(i,:,:) = values;
    end
    
    for i=1:sz(1)
        values = squeeze(valuesStore(:,:,i));
        D = squareform(pdist(values));
        Rp(:,:,i) = D;
    end

    

end
