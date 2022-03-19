%Testing different clustering methods and compairing the SSE.
%parameters:
%   k: amount of clusters.
%   retries: the total number each test will be executed. Result will be
%       mean over the retries.
%   TuckerMethods: the methods to test using the Yn tensor based on the
%       Tucker decomposition.
%   CPMethods: the methods to test using the Yn tensor based on the
%       CP decomposition.
%   OtherMethods: the methods to test using the Yn tensor that are not
%       based on a decomposition.
%   jrange: the different decomposition ranks to test.
%result:
%   Shows the total SSE over all slices from the cluster calculated using
%   the different methods in function of the rank of the decomposition.
initialize;
k=3;
retries = 1;
jrange = 5:5:50;

% TuckerMethods = ["Tucker1","Tucker2","Tucker3"];
TuckerMethods = ["Tucker1","Tucker1P"];
% TuckerMethods = [];
% CPMethods = ["CP1","CP2"];
CPMethods = ["CP1"];
% CPMethods = [];
% OtherMethods = ["Ex","Random","Venu","Weighted"];
OtherMethods = ["Ex","Random","Weighted","BestMatrix","SFC","Venu","VenuP",];
am = size(Yn,3);
TuckerResults = zeros(length(jrange),length(TuckerMethods),retries);
CPResults = zeros(length(jrange),length(CPMethods),retries);
OtherResults = zeros(length(jrange),length(OtherMethods),retries);
PResults = zeros(length(jrange),length(OtherMethods),retries);
exerciseClusters = info(2,1:180);
decomp = {};
decomp.Y = Yn;
decomp.P = Pn;
for j=1:am
    D= Yn(:,:,j);
    nrm = norm(D);
    OtherResults(:,1,:) = OtherResults(:,1,:) + calculateSSE(exerciseClusters,D)/nrm;
end
for j = 1:length(jrange)
    j
    R = jrange(j);
    [U,G] = mlsvd(Yn,[R,R,R,R]);
    [Up,Gp] = mlsvd(Pn,[R,R,R]);
    decomp.U = U;
    decomp.G = G;
    decomp.Gp = Gp;
    decomp.Up = Up;
    C = cpd(Yn,R);
    decomp.C = C;

    for ret=1:retries
        for m=1:length(TuckerMethods)
            Clusters = getExactClusters(TuckerMethods(m),decomp,k);
            for i=1:am
                D = Yn(:,:,i);
                nrm = norm(D);
                TuckerResults(j,m,ret) = TuckerResults(j,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
        for m=1:length(CPMethods)
            Clusters = getCPClusters(CPMethods(m),decomp.C,k);
            for i=1:am
                D = Yn(:,:,i);
                nrm = norm(D);
                CPResults(j,m,ret) = CPResults(j,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
        for m= 2:length(OtherMethods)
            Clusters = getExactClusters(OtherMethods(m),decomp,k);
            for i=1:am
                D = Yn(:,:,i);
                nrm = norm(D);
                OtherResults(j,m,ret) = OtherResults(j,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end
meanTucker = sum(TuckerResults,3)./retries;
meanCP = sum(CPResults,3)./retries;
meanOther = sum(OtherResults,3)./retries;
figure('Name',"Tucker"); hold on; plot(jrange,meanOther(:,1:2)); plot(jrange,meanTucker); legend(["Ex","Random",TuckerMethods]);
figure('Name',"CP"); hold on;  plot(jrange,meanOther(:,1:2)); plot(jrange,meanCP); legend(["Ex","Random",CPMethods]);
figure('Name',"Other"); hold on; plot(jrange,meanOther); legend(OtherMethods);
hold off;