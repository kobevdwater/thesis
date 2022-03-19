
initialize;
T = S;
Tp = Sp;
Tm = Sm;
useTm = true;
clusterFeatures = 2; %1: person; 2: exercise; 3: execution type
ks = [length(unique(info(1,:))),length(unique(info(2,:))),length(unique(info(3,:)))];
k=ks(clusterFeatures); %amount of features
% expected = info(clusterFeatures,1:180); %expected clusters
expected = false;
sz = size(T);
am = prod(sz(3:end),'all');
retries = 1; %amount of times we repeat the test. Result will be averaged over these tests.
Rrange = 5:5:50;
% Rrange = 5:10:15;

% Methods = ["Ex","Tucker1","CP1","Venu","Random","SFC","VenuP"];
Methods = ["Ex","Random","VenuP","Tucker1","SFC","Venu"];
PrResults = zeros(2,length(Rrange),length(Methods),retries);
SSEResults = zeros(length(Rrange),length(Methods),retries);
decomp = {};
decomp.Y = T;
decomp.P = Tp;
if expected
    [pr,rc] = BCubed(expected,expected);
    PrResults(:,:,1,:) = PrResults(:,:,1,:) + [pr;rc];
    for j=1:am
        D= T(:,:,j);
        nrm = norm(D);
        SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(expected,D)/nrm;
        
    end
elseif useTm
    Methods(1) = 'FromMatrix';
    Clusters = spectralClustering(Tm,k,'isDist',true);
    for j=1:am
        D= T(:,:,j);
        nrm = norm(D);
        SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(Clusters,D)/nrm; 
    end
else    
    Methods(1) = "Matrix";
    for j=1:am
        D= T(:,:,j);
        nrm = norm(D);
        MatrixClusters = spectralClustering(D,k,"isDist",true);
        SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(MatrixClusters,D)/nrm; 
    end
end
for r = 1:length(Rrange)
    r
    R = Rrange(r);
    rank = ones(size(sz)).*R;
    [U,G] = mlsvd(T,rank);
    [Up,Gp] = mlsvd(Tp,rank);
    decomp.U = U;
    decomp.G = G;
    decomp.Gp = Gp;
    decomp.Up = Up;
    C = cpd(T,R);
    decomp.C = C;

    for ret=1:retries
        for m=2:length(Methods)
            Clusters = getExactClusters(Methods(m),decomp,k);
            if expected
                [pr,rc] = BCubed(Clusters,expected);
                PrResults(:,r,m,ret) = PrResults(:,r,m,ret) + [pr;rc];
            end
            for j = 1:am
                D = T(:,:,j);
                nrm = norm(D);
                SSEResults(r,m,ret) = SSEResults(r,m,ret)+calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end
meanSSE = sum(SSEResults,3)./retries;
if expected
    MeanPr = sum(PrResults,4)./retries;
    figure('Name','Precision');
    hold on
    plot(Rrange,squeeze(MeanPr(1,:,1)),'o');
    plot(Rrange,squeeze(MeanPr(1,:,2:end)));
    legend(Methods);
    figure('Name','Recall');
    hold on;
    plot(Rrange,squeeze(MeanPr(2,:,1)),'o');
    plot(Rrange,squeeze(MeanPr(2,:,2:end)));
    legend(Methods);
    hold off;
end
figure('Name',"SSE"); hold on;
plot(Rrange,meanSSE(:,1),'o');
plot(Rrange,meanSSE(:,2:end));
legend(Methods);
