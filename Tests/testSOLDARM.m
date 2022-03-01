% Test the ability of SOLRADM to approximate the individual distance
% matrices in the distance tensor.
initialize;
am = size(Yn,3);
Srrange = 0.05:0.01:0.3;
results = zeros(retries,2,length(Srrange));
for j=1:length(Srrange)
    rf = floor(sqrt(Srrange(j)*size(Yn,1)*size(Yn,2)*size(Yn,3)/(size(Yn,1)+size(Yn,2)+size(Yn,3))));
    rs = floor(Srrange(j)*size(Yn,1)/2);
    [W,Cn] = FSTD(Yn,rf);
    Approx = lmlragen(Cn,W);
    for i=1:retries
        D = Yn(:,:,i);
        Dh = SOLRADM(D,10,rs);
        results(i,1,j) = norm(D-Dh)/norm(D);
        Da = Approx(:,:,i);
        results(i,2,j) = norm(D-Da)/norm(D);

    end
end
mean = squeeze(sum(results,1))./retries;
plot(Srrange,mean);
legend(["SOL","FSTD"])
