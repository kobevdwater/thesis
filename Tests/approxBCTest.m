%APPROXBCTEST: Finding the precission and recall for different approximate
%methods. Clusters are compaired to the expected clusters from info from
%the AMIE dataset. Wich can create a cluster based on the person, excercise
%and execution type.
initialize;
clusterFeatures = 2; %1: person; 2: exercise; 3: execution type
ks = [length(unique(info(1,:))),length(unique(info(2,:))),length(unique(info(3,:)))];
k=ks(clusterFeatures); %amount of features
expected = info(clusterFeatures,1:180); %expected clusters
am = 75; %dimention of the third mode.
retries = 15; %amount of times we repeat the test. Result will be averaged over these tests.
%methods = ["Venu","FSTD1","ParCube1","MACH1","MACH2","Random"];
methods = ["FSTD1","FSTD11"];
%sinterval = [0.02,0.05,0.1,0.2,0.33,0.5]; %sampling rates used.
sinterval = [0.02,0.05,0.1];
result = zeros(2,length(sinterval),length(methods),retries);

for si = 1:length(sinterval)
    si
    for i=1:retries
        for m = 1:length(methods)
            Clusters = getApproxClusters(methods(m),sinterval(si),Yn,k);
            [pr,rc] = BCubed(Clusters,expected);
            result(:,si,m,i) = result(:,si,m,i)+ [pr;rc];
        end
    end
end

sresult = sum(result,4)./retries;
figure('Name','Precision');plot(sinterval,squeeze(sresult(1,:,:)));legend(methods)
figure  ('Name','Recall');plot(sinterval,squeeze(sresult(2,:,:)));legend(methods)
