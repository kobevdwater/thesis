retries = 1;
rrange = 1:15;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();
D = Y(:,:,1);
Y.setSlice(1);
for i=1:retries
    for j=1:length(rrange)
        j
        Y.resetSamplingRate();
        Yh = CRMDFMWA1(Y,rrange(j));
        Dh = Yh(:,:,1);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate(:,:);
    end
end