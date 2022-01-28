% Testing the influence of the amount of rows sampled by
% opstellenkanverdeling on the performace of Venu.
k=3;
am = 75;
r = 5;
retries = 15;
amountrange = 1:10:300;
result = zeros(length(sinterval),4,retries);
exerciseClusters = info(2,1:180);
for j=1:am
            D= Yn(:,:,j);
            MatrixClusters = spectralClustering(D,3,k);
            nrm = norm(D);
            result(:,2,:) = result(:,2,:) + calculateSSE(MatrixClusters,D)/nrm;
            result(:,4,:) = result(:,4,:) + calculateSSE(exerciseClusters,D)/nrm; 
end

for si = 1:length(amountrange)
    si
    for i=1:retries
        [simVenu,simVenuNorm] = venuFlatten(Yn,400,amountrange(si));
        VenuClusters = spectralClustering(simVenu,3,k,'sim');
        RandomClusters = randi(k,1,size(Yn,1));
        
        for j=1:am
            D= Yn(:,:,j);
            nrm = norm(D);
            result(si,1,i) = result(si,1,i) + calculateSSE(VenuClusters,D)/nrm;
            result(si,3,i) = result(si,3,i) + calculateSSE(RandomClusters,D)/nrm;
        end
    end
end
methods = ["venu","Matrix","Random","exe"];
mean = sum(result,3)/retries;
ymin = mean - min(result,[],3);
ymax = max(result,[],3) - mean;
stand = std(result,0,3);
errorbar(repmat(amountrange',1,4),mean,ymin,ymax);
legend(methods);

figure(2); plot(amountrange,stand);
figure(3); plot(amountrange,ymax-ymin);




