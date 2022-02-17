%Test how good we can resconstruct our tensor using a Tucker decomposition 
% using a given coresize.
retries = 1;
rrange = 2:50;
results = zeros(retries,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();
% Y.setSlice(1);
for i=1:retries
    i
    for j=1:length(rrange)
        j
%         Y.resetSamplingRate();
        coresize = [rrange(j),rrange(j),rrange(j)];
        [U,S] = lmlra(Yn,coresize);
        Yr = lmlragen(U,S);
        for k=1:size(Yn,3)
            D = Yn(:,:,k);
            Dh = Yr(:,:,k);
            results(i,j) =results(i,j)+norm(D-Dh)/norm(D);
        end
        sr(i,j)= 0;
    end
end
sm = sum(result);
plot()