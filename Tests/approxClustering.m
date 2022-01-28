%Testing different sampling methods and compairing the SSE. The methods are
%compaired with the exercice clusters and the best matrix clusters.
initialize;
k=3;
am = 75;
r = 5;
retries = 10;
%methods = ["Matrix","ex","Venu","FSTD1","ParCube1","MACH1","Random"];
methods = ["Matrix","ex","Venu","FSTD1","FSTD11"];
methodsP = ["VenuP"];
%sinterval = [0.02,0.05,0.1,0.2,0.33];
sinterval = [0.02,0.03,0.05,0.1];
result = zeros(length(sinterval),length(methods),retries);
resultP = zeros(length(sinterval),length(methodsP),retries);
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
        for m=1:length(methodsP)
            Clusters = getApproxClusters(methodsP(m),sinterval(si),Pn,k);
            for j=1:am
                D= Yn(:,:,j);
                nrm = norm(D);
                resultP(si,m,i) = resultP(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end

mean = sum(result,3)./retries;
stand = std(result,0,3);
%errorbar(mean,stand);
plot(sinterval,mean);
meanP = sum(resultP,3)./retries;
standP = std(resultP,0,3);
hold on;
%errorbar(meanP,standP);
plot(sinterval,meanP);
legend([methods,methodsP]);
hold off;

