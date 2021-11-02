retries = 10;
krange = 2:20;
results = zeros(retries,length(krange));
sr = zeros(retries,length(krange));
%Y = DistanceTensorP();
D = Y(:,:,1);
Y.setSlice(1);
for i=1:retries
    for j=1:length(krange)
        j
        Y.resetSamplingRate();
        Dh = SOLRADM(Y,krange(j),2);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate(:,:);
    end
end


