retries = 10;
rrange = 1:50;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();
D = Y(:,:,1);
Y.setSlice(1);
for i=1:retries
    i
    for j=1:length(rrange)
        Y.resetSamplingRate();
        Yh = CRMDFMWA1(Y,rrange(j),rrange(j),12);
        Dh = Yh(:,:,1);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate();
    end
end