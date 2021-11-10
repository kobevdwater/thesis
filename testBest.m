retries = 1;
rrange = 2:50;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();
D = Y(:,:,1);
Y.setSlice(1);
for i=1:retries
    i
    for j=1:length(rrange)
        Y.resetSamplingRate();
        YY = Y(:,:,:);
        coresize = [rrange(j),rrange(j),rrange(j)];
        [U,S ] = lmlra(YY,coresize);
        Yh = lmlragen(U,S);
        Dh = Yh(:,:,1);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate();
    end
end