% Test the ability of SOLRADM to approximate the individual distance
% matrices in the distance tensor.
initialize;
T = S;
sz = size(T);
am = prod(sz(3:end),'all');
Srrange = 0.05:0.025:0.1;
results = zeros(am,2,length(Srrange));
for j=1:length(Srrange)
    Srrange(j)
    rf = floor(sqrt(Srrange(j)*prod(sz,'all')/(sum(sz,'all'))));
    rs = floor(Srrange(j)*size(T,1)/2)
%     [W,Cn] = FSTD(T,rf);
%     Approx = lmlragen(Cn,W);
    for i=1:am
        D = T(:,:,i);
        Dh = SOLRADM(D,10,rs);
        results(i,1,j) = norm(D-Dh)/norm(D);
%         Da = Approx(:,:,i);
%         results(i,2,j) = norm(D-Da)/norm(D);

    end
end
mean = squeeze(sum(results,1))./am;
plot(Srrange,mean);
legend(["SOL","FSTD"])
