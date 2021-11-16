retries = 3;
rrange = 1:20;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();

%Y.setSlice(1);
for i=1:retries
    
    tic;
    for j=1:length(rrange)
        %Y.resetSamplingRate();
        Yh = CRMDFMWA1(Y,rrange(j),rrange(j),rrange(j));
        res = 0;
        for k=1:75
            Dh = Yh(:,:,k);
            D = Y(:,:,k);
            res = res + norm(D-Dh)/norm(D)
        end
        results(i,j) = res/75;
        sr(i,j)= Y.getSampleRate();
    end
    toc
end