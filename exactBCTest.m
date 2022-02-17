initialize;
clusterFeatures = 2; %1: person; 2: exercise; 3: execution type
ks = [length(unique(info(1,:))),length(unique(info(2,:))),length(unique(info(3,:)))];
k=ks(clusterFeatures); %amount of features
expected = info(clusterFeatures,1:180); %expected clusters
am = 75; %dimention of the third mode.
retries = 5; %amount of times we repeat the test. Result will be averaged over these tests.
jr = 5;
TuckerMethods = ["Tucker1","Tucker2","Tucker3"];
TuckerMethods = ["Tucker1"];
CPMethods = ["CP1","CP2"];
CPMethods = ["CP1"];
OtherMethods = ["Weighted","Random","Venu"];
OtherMethods = ["Venu","Random"];
TuckerResults = zeros(2,jr,length(TuckerMethods),retries);
CPResults = zeros(2,jr,length(CPMethods),retries);
OtherResults = zeros(2,jr,length(OtherMethods),retries);
for j = 1:jr
    [U,G] = mlsvd(Yn,[10+j,10+j,10+j]);
    Ucp = cpd(Yn,10+j);
    for ret=1:retries
        ret
        for m=1:length(TuckerMethods)
            Clusters = getTuckerClusters(TuckerMethods(m),G,U,k);
            [pr,rc] = BCubed(Clusters,expected);
            TuckerResults(:,j,m,ret) = TuckerResults(:,j,m,ret) + [pr;rc];
        end
        for m=1:length(CPMethods)
            Clusters = getCPClusters(CPMethods(m),Ucp,k);
            [pr,rc] = BCubed(Clusters,expected);
            CPResults(:,j,m,ret) = CPResults(:,j,m,ret) + [pr;rc];
        end
        for m= 1:length(OtherMethods)
            Clusters = getOtherClusters(OtherMethods(m),Yn,k);
            [pr,rc] = BCubed(Clusters,expected);
            OtherResults(:,j,m,ret) = OtherResults(:,j,m,ret) + [pr;rc];
        end
    end
end
TuckerMean = sum(TuckerResults,4)./retries;
CPMean = sum(CPResults,4)./retries;
OtherMean = sum(OtherResults,4)./retries;
figure('Name','Precision');
hold on
plot(squeeze(TuckerMean(1,:,:)));
plot(squeeze(CPMean(1,:,:)));
plot(squeeze(OtherMean(1,:,:)));
legend([TuckerMethods,CPMethods,OtherMethods]);
figure('Name','Recall');
hold on;
plot(squeeze(TuckerMean(2,:,:)));
plot(squeeze(CPMean(2,:,:)));
plot(squeeze(OtherMean(2,:,:)));
legend([TuckerMethods,CPMethods,OtherMethods]);
hold off;
