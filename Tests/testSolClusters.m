initialize;
k=3;
retries = 1;
sinterval = logspace(-1,0.3,10);
T = Yn;
sz = size(T);
am = prod(sz(3:end),'all');
result = zeros(length(sinterval),4,retries);
PRresult = zeros(length(sinterval),1,retries);
exerciseClusters = info(2,1:180);
% exerciseClusters = false;

%Calculating methods that are not dependent on samplerate.
for j=1:am
            D= T(:,:,j);
            mx = max(D,[],"all");
            MatrixClusters = spectralClustering(D./mx,k,'isDist',true);
            nrm = norm(D);
            result(:,1,:) = result(:,1,:) + calculateSSE(MatrixClusters,D)/nrm;
            if exerciseClusters
                result(:,2,:) = result(:,2,:) + calculateSSE(exerciseClusters,D)/nrm; 
            end
end

for si = 1:length(sinterval)
    r = floor(sinterval(si)*size(T,1)./2)
    for i=1:retries
        Clusters = getSOLRADMClusters(T,r,k);
        ClustersE = clusterTensor(T,k);
        for j=1:am
            D = T(:,:,j);
            Clu = Clusters(j,:);
            nrm = norm(D);
            result(si,3,i) = result(si,3,i)+ calculateSSE(Clu,D)/nrm;
            CluE = ClustersE(j,:);
            result(si,4,i) = result(si,4,i)+calculateSSE(CluE,D)/nrm;
            [pr,~] = BCubed(Clu,CluE);
            PRresult(si,1,i) = PRresult(si,1,i)+pr;
        end
    end
end

mean = sum(result,3)./retries;
prmean = sum(PRresult,3)./(retries*am);
plot(sinterval,mean);
legend(["Matrix","Ex","Sol","Exact"]);
figure("Name","precision"); plot(sinterval,prmean);


