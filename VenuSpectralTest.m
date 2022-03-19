%VenuSpectralTest
initialize
K = 6;
Rmax = 50;
Rrange = 5:5:Rmax;
R = length(Rrange);
T = Mo;
[i,j,k] = size(T);
p = OpstellenKansverdeling(T);
I = datasample(1:j*k,Rmax,'Weights',p(:)','Replace',false);
M = tens2mat(T,1);
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
    SSERes(j) = calculateSSET(T,Clusters);
%     [U,G] = mlsvd(Yn,[R,R,R]);
%     Clusters = getTuckerClusters("Tucker1",G,U,K);
%     SSEResT(j) = calculateSSET(Yn,Clusters);
    
end
plot(Dres');
figure(); hold on; plot(SSERes);plot(SSEResT); legend(["Venu","Tucker"]);
hold off;
