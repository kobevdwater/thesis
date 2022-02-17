%Testing different sample mechanisms for venu. 
initialize
k=3;
am = 75;
r = 5;
retries = 15;
methods = ["matrix","ex","Venu","VenuHi","VenuSp"];
sinterval = logspace(-3,-0.6,5);
result = zeros(length(sinterval),length(methods),retries);
exerciseClusters = info(2,1:180);

for j=1:am
            D= Yn(:,:,j);
            mx = max(D,[],"all");
            MatrixClusters = spectralClustering(D./mx,3,k,"dis");
            nrm = norm(D);
            result(:,1,:) = result(:,1,:) + calculateSSE(MatrixClusters,D)/nrm;
            result(:,2,:) = result(:,2,:) + calculateSSE(exerciseClusters,D)/nrm; 
end

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m=3:length(methods)
            Clusters = getApproxClusters(methods(m),sinterval(si),Yn,k);
            for j=1:am
                D = Yn(:,:,j);
                nrm = norm(D);
                result(si,m,i) = result(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end
mean = sum(result,3)/retries;
ymin = mean - min(result,[],3);
ymax = max(result,[],3) - mean;
stand = std(result,0,3);
figure(1);
% errorbar(repmat(sinterval',1,length(methods)),mean,stand);
semilogy(sinterval,mean);
legend(methods);
%errorbar(repmat(sinterval',1,length(methods)),mean,ymin,ymax);
legend(methods);

figure(2); semilogx(sinterval,stand);
legend(methods);
figure(3); semilogx(sinterval,ymax-ymin);
legend(methods);




