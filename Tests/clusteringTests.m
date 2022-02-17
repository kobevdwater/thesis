%This needs some love...
initialize;
jr = 4;
k=3;
am = 75;
retries = 10;

% TuckerMethods = ["Tucker1","Tucker2","Tucker3"];
TuckerMethods = ["Tucker1"];
CPMethods = ["CP1","CP2"];
CPMethods = ["CP1"];
OtherMethods = ["Ex","Weighted","Random","Venu"];
OtherMethods = ["Ex","Venu","Random"];
TuckerResults = zeros(jr,length(TuckerMethods),retries);
CPResults = zeros(jr,length(CPMethods),retries);
OtherResults = zeros(jr,length(OtherMethods),retries);
exerciseClusters = info(2,1:180);
for j=1:am
    D= Yn(:,:,j);
            nrm = norm(D);
            OtherResults(:,1,:) = OtherResults(:,1,:) + calculateSSE(exerciseClusters,D)/nrm;
end
for j = 1:jr
    [U,G] = mlsvd(Yn,[10+j,10+j,10+j]);
    Ucp = cpd(Yn,10+j);

    for ret=1:retries
        ret
        for m=1:length(TuckerMethods)
            Clusters = getTuckerClusters(TuckerMethods(m),G,U,k);
            for i=1:am
                D = Yn(:,:,i);
                nrm = norm(D);
                TuckerResults(j,m,ret) = TuckerResults(j,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
        for m=1:length(CPMethods)
            Clusters = getCPClusters(CPMethods(m),Ucp,k);
            for i=1:am
                D = Yn(:,:,i);
                nrm = norm(D);
                CPResults(j,m,ret) = CPResults(j,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
        for m= 2:length(OtherMethods)
            Clusters = getOtherClusters(OtherMethods(m),Yn,k);
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
hold on;
plot(meanTucker);
plot(meanCP);
plot(meanOther);
legend([TuckerMethods,CPMethods,OtherMethods]);
hold off;


