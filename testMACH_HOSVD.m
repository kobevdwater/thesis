prange = (1:20)*0.05;
retries = 1;
results = zeros(retries,length(prange));
sr = zeros(retries,length(prange));
D = Y(:,:,1);
for i=1:retries
    i
    for j=1:length(prange)
        Y.resetSamplingRate();
        [G,A1,A2,A3,srj] = MACH_HOSVD(Y,5*i,5*i,5*i,prange(j));
        U = {A1,A2,A3};
        Yh = lmlragen(U,G);
        Dh = Yh(:,:,1);
        results(i,j) = norm(D-Dh)/norm(D);
        sr(i,j)= srj
    end
end