jr = 15;
randomResults = zeros(jr,45);
resultTucker = zeros(jr,45);
resultTucker2 = zeros(jr,45);
resultTucker3 = zeros(jr,45);
resultVenu = zeros(jr,45);
resultMatrix = zeros(jr,45);
resultWeighted = zeros(jr,45);
Sim = venuFlatten(Yp);
for j = 1:jr
    j
    [U,S] = mlsvd(Yp,[10,10,10]);

    randomClusters = randi(4,1,100);
    tuckerClusters = cluserOnTucker(S,U{1,1},j,3);
    tucker2Clusters = cluserOnTucker2(S,U{1,1},j,3);
    tucker3Clusters = cluserOnTucker3(S,U{1,1},j);
    Sim = venuFlatten(Yp);
    venuClusters = spectralClustering(Sim,3,j,'sim');
    weightedClusters = SSEWeightedClustering(Yp,j,3);
    for i=1:45
        D= Yp(:,:,i);
        MatrixClusters = spectralClustering(D,3,j);
        nrm = norm(D);
        randomResults(j,i) = calculateSSE(randomClusters,D)/nrm;
        resultTucker(j,i) = calculateSSE(tuckerClusters,D)/nrm;
        resultTucker2(j,i) = calculateSSE(tucker2Clusters,D)/nrm;
        resultTucker3(j,i) = calculateSSE(tucker3Clusters,D)/nrm;
        resultVenu(j,i) = calculateSSE(venuClusters,D)/nrm;
        resultMatrix(j,i) = calculateSSE(MatrixClusters,D)/nrm;
        resultWeighted(j,i) = calculateSSE(weightedClusters,D)/nrm;
    end
end
plot(sum(resultTucker,2),'DisplayName','Tucker');
hold on;
plot(sum(resultTucker2,2),'DisplayName','Tucker2');
plot(sum(resultTucker3,2),'DisplayName','Tucker3');
plot(sum(resultVenu,2),'DisplayName','Venu');
plot(sum(randomResults,2),'DisplayName','Random');
plot(sum(resultWeighted,2),'DisplayName','Weighted');
plot(sum(resultMatrix,2),'DisplayName','Matrix');
legend();
hold off;
[sum(resultTucker) sum(resultTucker2) sum(resultTucker3) sum(resultVenu) sum(randomResults) sum(resultWeighted) sum(resultMatrix)] 
