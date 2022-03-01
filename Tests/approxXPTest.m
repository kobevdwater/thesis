%Testing sampling methodes on the XP tensor. The methods are
%compaired with the random clusters and the best matrix clusters.
%parameters:
%   k: amount of clusters.
%   retries: the total number each test will be executed. Result will be
%       mean over the retries.
%   methods: the methods to test using the XP tensor.
%   sinterval: the samplerates to test. 
%result:
%   Shows the total SSE over all slices from the cluster calculated using
%   the different methods in function of the samplerate.
initialize;
k=6;
retries = 1;
methods = ["Matrix","Random","Venu","MACH1"];
% methods = ["Matrix","ex","Venu"];
sinterval = logspace(-4,-0,20);
am = size(XPn,3)*size(XPn,4);
result = zeros(length(sinterval),length(methods),retries);
randomClusters = randi(k,1,size(XPn,1));

%Calculating methods that are not dependent on samplerate.
for j=1:am
            D = XPn(:,:,j);
            mx = max(D,[],"all");
            MatrixClusters = spectralClustering(D./mx,k,"isDist",true);
            nrm = norm(D);
            result(:,1,:) = result(:,1,:) + calculateSSE(MatrixClusters,D)/nrm;
            result(:,2,:) = result(:,2,:) + calculateSSE(randomClusters,D)/nrm;
end

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m=3:length(methods)
            Clusters = getApproxClusters(methods(m),sinterval(si),XPn,k);
            for j=1:am
                D = XPn(:,:,j);
                nrm = norm(D);
                result(si,m,i) = result(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end

mean = sum(result,3)./retries;
plot(sinterval,mean);
hold on;
legend(methods);

