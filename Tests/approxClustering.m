%Testing different sampling methods and compairing the SSE. The methods are
%compaired with the exercice clusters and the best matrix clusters.
%parameters:
%   k: amount of clusters.
%   retries: the total number each test will be executed. Result will be
%       mean over the retries.
%   methods: the methods to test using the Yn tensor.
%   methodsP: the methods to test using the P tensor. 
%   sinterval: the samplerates to test. 
%result:
%   Shows the total SSE over all slices from the cluster calculated using
%   the different methods in function of the samplerate.
initialize;
k=3;
retries = 1;
methods = ["Matrix","ex","Venu","FSTD1","ParCube1","MACH1","Random"];
% methods = ["Matrix","ex","FSTD1","FSTDX1"];
% methods = ["Matrix","ex","Venu"];
methodsP = ["VenuP"];
% methodsP = [];
sinterval = logspace(-2.5,-0.5,10);
am = size(Yn,3);
result = zeros(length(sinterval),length(methods),retries);
resultP = zeros(length(sinterval),length(methodsP),retries);
exerciseClusters = info(2,1:180);

%Calculating methods that are not dependent on samplerate.
for j=1:am
            D= Yn(:,:,j);
            mx = max(D,[],"all");
            MatrixClusters = spectralClustering(D./mx,k,'isDist',true);
            nrm = norm(D);
            result(:,1,:) = result(:,1,:) + calculateSSE(MatrixClusters,D)/nrm;
            result(:,2,:) = result(:,2,:) + calculateSSE(exerciseClusters,D)/nrm; 
end

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m=3:length(methods)
            Clusters = getApproxClusters(methods(m),sinterval(si),Yn,k);
            for j=1:am
                D = Yn(:,:,j);
                nrm = norm(D);
                result(si,m,i) = result(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
        for m=1:length(methodsP)
            Clusters = getApproxClusters(methodsP(m),sinterval(si),Pn,k);
            for j=1:am
                D= Yn(:,:,j);
                nrm = norm(D);
                resultP(si,m,i) = resultP(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end

mean = sum(result,3)./retries;
plot(sinterval,mean);
meanP = sum(resultP,3)./retries;
hold on;
plot(sinterval,meanP);
legend([methods,methodsP]);
hold off;

