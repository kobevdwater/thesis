retries = 10;
krange = 1:20;
results = zeros(retries,length(krange));
sr = zeros(retries,length(krange));
%Y = DistanceTensorP();
D = Y(:,:,1);
Y.setSlice(1);
for i=1:retries
    i
    for j=1:length(krange)
        Y.resetSamplingRate();
        Dh = SOLRADM(Y,krange(j),4);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate(:,:);
    end
end
