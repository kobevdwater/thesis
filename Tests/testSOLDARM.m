% Test the ability of SOLRADM to approximate the individual distance
% matrices in the distance tensor.
retries = 75;
krange = 1:20;
results = zeros(retries,length(krange));
sr = zeros(retries,length(krange));
%Y = DistanceTensorP();
Y = load('/home/kobe/Documents/school/MATLAB/thesis/data/Yn.mat');
Y =Y.Yn;
for i=1:retries
    D = Y(:,:,i);
     Y.setSlice(i);
    for j=1:length(krange)
        Y.resetSamplingRate();
        Dh = SOLRADM(Y,krange(j),4);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= Y.getSampleRate(:,:);
    end
end
mean = sum(results)./retries;
meansr = sum(sr)./retries;
plot(meansr,mean)
