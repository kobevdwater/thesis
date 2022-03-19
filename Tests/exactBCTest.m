
initialize;
clusterFeatures = 2; %1: person; 2: exercise; 3: execution type
ks = [length(unique(info(1,:))),length(unique(info(2,:))),length(unique(info(3,:)))];
k=ks(clusterFeatures); %amount of features
expected = info(clusterFeatures,1:180); %expected clusters
am = 75; %dimention of the third mode.
retries = 1; %amount of times we repeat the test. Result will be averaged over these tests.
Rrange = 10:10:50;
Methods = ["Tucker1","CP1","Venu","Random","SFC","VenuP"];
Results = zeros(2,length(Rrange),length(Methods),retries);
decomp = {};
decomp.Y = Yn;
decomp.P = Pn;
for r = 1:length(Rrange)
    r
    R = Rrange(r);
    [U,G] = mlsvd(Yn,[R,R,R,8]);
    C = cpd(Yn,R);
    decomp.U = U;decomp.G = G;decomp.C = C;

    for ret=1:retries
        for m=1:length(Methods)
            Clusters = getExactClusters(Methods(m),decomp,k);
            [pr,rc] = BCubed(Clusters,expected);
            Results(:,r,m,ret) = Results(:,r,m,ret) + [pr;rc];
        end
    end
end
Mean = sum(Results,4)./retries;
figure('Name','Precision');
hold on
plot(squeeze(Mean(1,:,:)));
legend([Methods]);
figure('Name','Recall');
hold on;
plot(squeeze(Mean(2,:,:)));
legend([Methods]);
hold off;
