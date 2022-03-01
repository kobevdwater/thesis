%Calculating the SSE for different clustering algorithms based on
%sampling in function of sampling rate.
%to cluster the third (sensor) mode. 
%Using methods that both use the P (m*m*n) and Y (n*n*m) tensors.
%   Where n=#persons and m=#sensors
initialize;
k=10;
am = size(Pn,3);
retries = 1;
methods = ["Matrix","Venu","MACH1","Random","SOLSFC"];
%methods = ["Matrix","Venu","XYZ"];
methodsP = ["VenuP"];
sinterval = [0.03,0.05,0.1,0.2,0.33,0.5];
result = zeros(length(sinterval),length(methods),retries);
resultP = zeros(length(sinterval),length(methodsP),retries);


for j=1:am
            D= Pn(:,:,j);
            mx = max(D,[],"all");
            MatrixClusters = spectralClustering(D./mx,k,"isDist",true);
            nrm = norm(D);
            result(:,1,:) = result(:,1,:) + calculateSSE(MatrixClusters,D)/nrm;
end

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m=2:length(methods)
            Clusters = getApproxClusters(methods(m),sinterval(si),Pn,k);
            for j=1:am
                D= Pn(:,:,j);
                nrm = norm(D);
                result(si,m,i) = result(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
        for m=1:length(methodsP)
            Clusters = getApproxClusters(methodsP(m),sinterval(si),Yn,k);
            for j=1:am
                D= Pn(:,:,j);
                nrm = norm(D);
                resultP(si,m,i) = resultP(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end

mean = sum(result,3)./size(result,3);
stand = std(result,0,3);
%errorbar(mean,stand);
plot(sinterval,mean);
hold on;
meanP = sum(resultP,3)./size(resultP,3);
standP = std(resultP,0,3);
%errorbar(meanP,standP);
plot(sinterval,meanP);
legend([methods,methodsP]);
hold off;