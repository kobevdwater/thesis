%VenuSpectralTest
initialize
[i,j,k] = size(Yn);
K = 4;
Rmax = 500;
Rrange = 5:5:Rmax;
R = length(Rrange);
p = OpstellenKansverdeling(Yn);
I = datasample(1:j*k,Rmax,'Weights',p(:)','Replace',false);
M = tens2mat(Yn,1);
Dres = zeros(K,R);
SSERes = zeros(R,1);
SSEResT = zeros(R,1);
for j=1:R
    j
    r = Rrange(j);
    Mr = M(:,I(1:r));
    Mrt = Mr'./vecnorm(Mr');
    simMat = Mrt'*Mrt;
    [Clusters,V,D] = spectralcluster(simMat,K,'Distance','precomputed','LaplacianNormalization','symmetric');
    Dres(:,j) = D;
    SSERes(j) = calculateSSET(Yn,Clusters);
%     [U,G] = mlsvd(Yn,[R,R,R]);
%     Clusters = getTuckerClusters("Tucker1",G,U,K);
%     SSEResT(j) = calculateSSET(Yn,Clusters);
    
end
plot(Dres');
figure(); hold on; plot(SSERes);plot(SSEResT); legend(["Venu","Tucker"]);
hold off;
