
k=3;
am = 75;
r = 5;
retries = 15;
sinterval = logspace(-3,-0.6,15);
result = zeros(length(sinterval),6,retries);
venuInterval = floor(sinterval*size(Yn,2)*size(Yn,3));
exerciseClusters = info(2,1:180);
for j=1:am
            D= Yn(:,:,j);
            nrm = norm(D);
            result(:,5,:) = result(:,5,:) + calculateSSE(exerciseClusters,D)/nrm; 
end




for si = 1:length(sinterval)
    si
    for i=1:retries
        RandomClusters = randi(k,1,size(Yn,1));
        [simVenurand] = venuFlatten(Yn,venuInterval(si),10,1);
        [simVenusp,simVenuspnr] = venuFlatten(Yn,venuInterval(si),10,2);
        [simVenuwe] = venuFlatten(Yn,venuInterval(si),10,3);

        VenuClustersrand = spectralClustering(simVenurand,3,k,'sim');
        VenuClusterssp = spectralClustering(simVenusp,3,k,'sim');
        VenuClusterswe = spectralClustering(simVenuwe,3,k,'sim');
        VenuClusterspnr = spectralClustering(simVenuspnr,3,k,'dis');
        for j=1:am
            D= Yn(:,:,j);
            nrm = norm(D);
            result(si,1,i) = result(si,1,i) + calculateSSE(VenuClustersrand,D)/nrm;
            result(si,2,i) = result(si,2,i) + calculateSSE(VenuClusterssp,D)/nrm;
            result(si,3,i) = result(si,3,i) + calculateSSE(VenuClusterswe,D)/nrm;
            result(si,4,i) = result(si,4,i) + calculateSSE(RandomClusters,D)/nrm;
            result(si,6,i) = result(si,6,i) + calculateSSE(VenuClusterspnr,D)/nrm;

        end
    end
end
methods = ["venurand","venusp","venuswe","Random","exe","spnr"];
mean = sum(result,3)/retries;
ymin = mean - min(result,[],3);
ymax = max(result,[],3) - mean;
stand = std(result,0,3);
figure(1);
errorbar(repmat(sinterval',1,length(methods)),mean,stand);
legend(methods);
errorbar(repmat(sinterval',1,length(methods)),mean,ymin,ymax);
legend(methods);

figure(2); semilogx(sinterval,stand);
legend(methods);
figure(3); semilogx(sinterval,ymax-ymin);
legend(methods);




