retries = 2;
rrange = 1:20;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();

Y.setSlice(1);
for i=1:retries
    D = Y(:,:,i);
    tic;
    parfor j=1:length(rrange)
        Y.resetSamplingRate();
        Yh = CRMDFMWA1(Y,rrange(j),rrange(j),rrange(j));
        Dh = Yh(:,:,i);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate();
    end
    toc
end