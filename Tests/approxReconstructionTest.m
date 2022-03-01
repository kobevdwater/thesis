initialize;
k=3;
retries = 1;
methods = ["FSTD","MACH","ParCube"];
% methods = ["ParCube"];
sinterval = logspace(-2,0,10);
[U,S] = lmlra_rnd([30,30,30,30],[10,10,10,10]);
Y1 = lmlragen(U,S);
Y2 = zeros(100,100,100);
for i=1:100
    for j=1:100
        for k=1:100
            Y2(i,j,k) = 1/sqrt((i^2+j^2+k^2));
        end
    end
end
Ys = {Y1,Y2,Xn};
% Ys = {Y1};
result = zeros(length(Ys),length(sinterval),length(methods),retries);

for y = 1:length(Ys)
    Y = Ys{y};
    nrm = frob(Y);
    for si = 1:length(sinterval)
        for i=1:retries
            for m=1:length(methods)
                Approx = getApproxReconstruction(methods(m),Y,sinterval(si));
                result(y,si,m,i) = frob(Y-Approx)/nrm;
            end
        end
    end
end
mean = sum(result,4)./retries;
for i=1:length(Ys)
    figure(i);
    loglog(sinterval,squeeze(mean(i,:,:)));
    legend(methods);
end