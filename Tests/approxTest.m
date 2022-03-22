%Testing different sampling on there ability to generate good clusters.
%Will report the SSE of each methods ifo the sampling rate. 
%Will report the precision an recall of the found clusters compaired with
%   expected clusters. 
%   If no expected clusters are known. No precision and recall will be
%   calculated. 
%parameters:
%   k: amount of clusters.
%   T: The tensor used to create the clusterings.
%   Td: Distance tensor used to measure SSE of clusterings.
%   Tp: The tensor used for Pmethods (clustering third mode).
%   retries: The total number each test will be executed. Result will be
%       mean over the retries.
%   methods: Methods to test using the tensor T (clustering first mode). 
%      See: getApproxClusters for available methods.                                       
%   methodsP: Methods to test using the tensor Tp (clustering third mode). 
%      See: getApproxClusters for available methods. 
%   sinterval: Samplerates to test. 
%   expected: The clustering to use to compute presicion and recall.
%       False if expected clusters are not known.
%   
%result:
%   Shows the total SSE over all slices from the cluster calculated using
%   the different methods in function of the samplerate. Will also report
%   the SSE of the expected clusters or of the clusters calculated on each
%   slice when no expected clusters are known.
%   Shows the precision and recall of the different methods in function of
%   the samplerate compaired to the expected clusters.
initialize;
k=3;
T = Yn;
Td = Y3;
Tp = Pn;
retries = 1;
methods = ["Random","Venu","VenuSVD","VenuSVD3"];
% methods = ["SOLSFC","Random"];
methodsP = ["VenuP"];
sinterval = logspace(-3,-2,10);
% expected = info(2,1:180);
expected = false;

sz = size(Td);
am = prod(sz(3:end),'all');
mi = length(methods);
SSEresult = zeros(length(sinterval),length(methods)+ length(methodsP),retries);
PRresult = zeros(2,length(sinterval),length(methods)+ length(methodsP),retries);
SSEx = zeros(length(sinterval));
Ex = "Expected";
%Calculating methods that are not dependent on samplerate.
if expected
    for j=1:am
        D= Td(:,:,j);
        nrm = norm(D);
        SSEx(:) = SSEx(:) + calculateSSE(expected,D)/nrm; 
    end
else
    Ex = "Matrix";
   for j=1:am
        D= Td(:,:,j);
        nrm = norm(D);
        MatrixClusters = spectralClustering(D,k,"isDist",true);
        SSEx(:) = SSEx(:) + calculateSSE(MatrixClusters,D)/nrm; 
   end
end

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m=1:length(methods)
            methods(m)
            Clusters = getApproxClusters(methods(m),sinterval(si),T,k);
            if expected
                [pr,rc] = BCubed(Clusters,expected);
                PRresult(:,si,m,i) = PRresult(:,si,m,i)+ [pr;rc];
            end
            for j=1:am
                D = Td(:,:,j);
                nrm = norm(D);
                SSEresult(si,m,i) = SSEresult(si,m,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
        for m=1:length(methodsP)
            Clusters = getApproxClusters(methodsP(m),sinterval(si),Tp,k);
            if expected
                [pr,rc] = BCubed(Clusters,expected);
                PRresult(:,si,m+mi,i) = PRresult(:,si,m+mi,i)+ [pr;rc];
            end
            for j=1:am
                D= Td(:,:,j);
                nrm = norm(D);
                SSEresult(si,m+mi,i) = SSEresult(si,m+mi,i) + calculateSSE(Clusters,D)/nrm;
            end
        end
    end
end

SSEmean = sum(SSEresult,3)./retries;
figure('Name','SSE');plot(sinterval,SSEmean);
hold on; plot(sinterval,SSEx,'o');
legend([methods,methodsP,Ex]);
if expected
    PRmean = sum(PRresult,4)./retries;
    figure('Name','Precision');hold on; plot(sinterval,squeeze(PRmean(1,:,:)));legend([methods,methodsP]);
    figure  ('Name','Recall'); hold on; plot(sinterval,squeeze(PRmean(2,:,:)));legend([methods,methodsP]);
end

