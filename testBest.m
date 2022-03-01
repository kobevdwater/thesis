%Test how good we can resconstruct our tensor using a Tucker decomposition 
% using a given coresize.
retries = 1;
rrange = 2:2:50;
results = zeros(retries,length(rrange));
for i=1:retries
    i
    for j=1:length(rrange)
        j
        coresize = [rrange(j),rrange(j),rrange(j)];
        [U,S] = lmlra(Yn,coresize);
        Yr = lmlragen(U,S);
        results(i,j) = frob(Yn-Yr)/frob(Yn);
    end
end
sm = sum(results,1);
plot(rrange,sm);