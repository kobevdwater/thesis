Ts = {x,y,u,v,w};
initialize;
k=3;
retries = 1;
jrange = 5:5:50;

TuckerMethods = ["Tucker1"];
OtherMethods = ['Random',"SFC","Venu"];
am = 10;
TuckerResults = zeros(length(Ts),length(TuckerMethods),retries);
OtherResults = zeros(length(Ts),length(OtherMethods),retries);
exClusters = info(2,1:3:90);
exRes = zeros(length(Ts),1);
randRes = zeros(length(Ts),1);
for t =1:length(Ts)
    Y = Ts{1,t};
    am = size(Y,3);
    for i=1:am
        D = Y(:,:,i);
        nrm = norm(D);
        exRes(t) = exRes(t)+calculateSSE(exClusters,D)/nrm;
    end
end
for t = 1:length(Ts)
    Y = Ts{1,t};
    am = size(Y,3);
    for i=1:am
        D = Y(:,:,i);
        nrm = norm(D);
        for j=1:100
            Clusters = getOtherClusters('Random',Y,k);
            randRes(t) = randRes(t)+calculateSSE(Clusters,D)/nrm;
        end
    end
end
randRes = randRes./100;



for t=1:length(Ts)
    Y = Ts{1,t};
    R = 5;
    [U,G] = mlsvd(Y,[R,R,R]);
    am = size(Y,3);
    for ret=1:retries
        for m=1:length(TuckerMethods)
            Clusters = getTuckerClusters(TuckerMethods(m),G,U,k);
            for i=1:am
                D = Y(:,:,i);
                nrm = norm(D);
                TuckerResults(t,m,ret) = TuckerResults(t,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
        for m= 1:length(OtherMethods)
            Clusters = getOtherClusters(OtherMethods(m),Y,k);
            for i=1:am
                D = Y(:,:,i);
                nrm = norm(D);
                OtherResults(t,m,ret) = OtherResults(t,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end
randRes
exRes

OtherResults
X = categorical({'x','y','u','v','w'});
X = reordercats(X,{'x','y','u','v','w'});
randRes = randRes-exRes;
TuckerResultsR = TuckerResults-exRes;
OtherResultsR = OtherResults-exRes;
TuckerResultsR = TuckerResultsR./randRes;
OtherResultsR = OtherResultsR./randRes;

figure('Name',"Tucker"); bar(X,TuckerResultsR);
figure('Name',"Other"); bar(X,OtherResultsR); legend(OtherMethods);