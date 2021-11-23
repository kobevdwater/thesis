retries = 5;
rrange = 1:20;
results = zeros(retries,length(rrange));
resultsi = zeros(retries,length(rrange));
Yi = exp(-Y.^2/(2*10^2));


for i=1:retries
    
    tic;
    for j=1:length(rrange)
        Yh = CRMDFMWA1(Y,rrange(j),rrange(j),rrange(j));
        Yhi = CRMDFMWA1(Yi,rrange(j),rrange(j),rrange(j));
        res = 0;
        resi = 0;
        for k=1:45
            Dh = Yh(:,:,k);
            D = Y(:,:,k);
            res = res + norm(D-Dh)/norm(D);
            Dh = Yhi(:,:,k);
            D = Yi(:,:,k);
            resi = resi + norm(D-Dh)/norm(D);
        end
        results(i,j) = res/45;
        resultsi(i,j) = resi/45;
    end
    toc
end
