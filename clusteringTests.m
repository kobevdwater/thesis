jr = 5;
k=5;
am = 75;
randomResults = zeros(jr,am);
resultTucker = zeros(jr,am);
resultTucker2 = zeros(jr,am);
resultTucker3 = zeros(jr,am);
resultVenu = zeros(jr,am);
resultTuckerVenu = zeros(jr,am);
resultMatrix = zeros(jr,am);
resultWeighted = zeros(jr,am);
resultCP = zeros(jr,am);
resultCP2 = zeros(jr,am);
parfor j = 1:jr
    [U,S] = mlsvd(Yp,[10,10,10]);
    j
    randomClusters = randi(k,1,180);
    tuckerClusters = cluserOnTucker(S,U{1,1},k,3);
    tucker2Clusters = cluserOnTucker2(S,U{1,1},k,3);
    tucker3Clusters = cluserOnTucker3(S,U{1,1},k);
    Ucp = cpd(Yp,10);
    cpClusters = cluserOnCP(Ucp{1,1},k,3);
    cpClusters2 = cluserOnCP2(Ucp{1,1},k,3);
    Sim = venuFlatten(Yp);
    A1 = U{1,1};
    SimTucker = A1*A1';
    venuClusters = spectralClustering(Sim,3,k,'sim');
    venuTuckerClusters = spectralClustering(SimTucker,3,k,'sim');
    weightedClusters = SSEWeightedClustering(Yp,k,3);
    for i=1:am
        D= Yp(:,:,i);
        MatrixClusters = spectralClustering(D,3,k);
        nrm = norm(D);
        randomResults(j,i) = calculateSSE(randomClusters,D)/nrm;
        resultTucker(j,i) = calculateSSE(tuckerClusters,D)/nrm;
        resultTucker2(j,i) = calculateSSE(tucker2Clusters,D)/nrm;
        resultTucker3(j,i) = calculateSSE(tucker3Clusters,D)/nrm;
        resultVenu(j,i) = calculateSSE(venuClusters,D)/nrm;
        resultTuckerVenu(j,i) = calculateSSE(venuTuckerClusters,D)/nrm;
        resultMatrix(j,i) = calculateSSE(MatrixClusters,D)/nrm;
        resultWeighted(j,i) = calculateSSE(weightedClusters,D)/nrm;
        resultCP(j,i) = calculateSSE(cpClusters,D)/nrm;
        resultCP2(j,i) = calculateSSE(cpClusters2,D)/nrm;
    end
end
dir = 1;
plot(sum(resultTucker,dir),'DisplayName','Tucker');
hold on;
plot(sum(resultTucker2,dir),'DisplayName','Tucker2');
plot(sum(resultTucker3,dir),'DisplayName','Tucker3');
plot(sum(resultCP,dir),'DisplayName','Cp');
plot(sum(resultCP2,dir),'DisplayName','Cp2');
plot(sum(resultVenu,dir),'DisplayName','Venu');
plot(sum(resultTuckerVenu,dir),'DisplayName','VenuTucker');
plot(sum(randomResults,dir),'DisplayName','Random');
plot(sum(resultWeighted,dir),'DisplayName','Weighted');
plot(sum(resultMatrix,dir),'DisplayName','Matrix');
yl = ylim; % Get current limits.
ylim([0, yl(2)]); % Replace lower limit only with a y of 0.
legend();
hold off;
res = [   "Tucker: ", num2str(sum(resultTucker,'all')) ;
    "Tucker2: ", num2str(sum(resultTucker2,'all'));
    "Tucker3: ", num2str(sum(resultTucker3,'all'));
    "CP: ",num2str(sum(resultCP,'all'));
    "CP2: ",num2str(sum(resultCP2,'all'));
    "Venu: ", num2str(sum(resultVenu,'all'));
    "TuckerVenu ", num2str(sum(resultTuckerVenu,'all'));
    "Random: ",num2str(sum(randomResults,'all'));
    "Weighted:", num2str(sum(resultWeighted,'all'))
    "Matrix:", num2str(sum(resultMatrix,'all'))] ;
disp(res);
