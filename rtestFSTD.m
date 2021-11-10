retries = 5;
r1range = 1:20;
r2range = 1:20;
results = zeros(length(r2range),length(r1range),retries);
D = Y(:,:,1);
Y.setSlice(1);
for k = 1:retries
    for i=1:length(r1range)
        for j=1:length(r2range)
            Yh = CRMDFMWA1(Y,r1range(i),r1range(i),r2range(j));
            Dh = Yh(:,:,1);
            results(i,j,k) = norm(D-Dh)/norm(D);
        end
    end
end