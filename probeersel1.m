%collection of tests on tensors. Just to get a feeling.

r = 5;
inc = 0.1;

%Creating a dataset of 3 random clusters. Each with 100 elements
set1 = ones(100,2)*rand(2)*5+randn(100,2)*rand;
set2 = ones(100,2)*rand(2)*5+randn(100,2)*rand;
set3 = ones(100,2)*rand(2)*5+randn(100,2)*rand;
seta = [set1;set2;set3];
%shuffle entries
perm = randperm(300);
clustra = zeros(300,1);
clustr = zeros(300,1);
clustra(1:100) = 1;
clustra(101:200) = 2;
clustra(201:300) = 3;
set = zeros(300,2);
for i=1:300
    set(i,:) = seta(perm(i),:);
    clustr(i) = clustra(perm(i));
end
%plot correct clustering
figure(1);
gscatter(set(:,1),set(:,2),clustr);
%Making distance matrix
D = pdist(set);
D = squareform(D);
%plotting clustering based on correct distance matrix.
%Putting everything in a tensor
T = ones(300,300,2);
T(:,:,1) = D;
for i=1:300
    for j=1:i
        if clustr(i) ==clustr(j)
            T(i,j,2) = 0;
            T(j,i,2) = 0;
        end
    end
end

clusterAndPlot(T,set,2,"exact decomposition")

%creating low-rank approximation
Uhat = cpd(T,r);
That = cpdgen(Uhat);
Dhat = That(:,:,1);

Z = linkage(Dhat);
Cl = cluster(Z,'maxclust',3);
%clusters based on approximated distance matrix
figure(3);
gscatter(set(:,1),set(:,2),Cl);

%Creating incomplete tensor 
Tpart = NaN(300,300,2);
for i=1:300
    for j=1:i
        if rand<= inc
            Tpart(i,j,:) = T(i,j,:);
            Tpart(j,i,:) = T(i,j,:);
        end
    end
end
Tpart = fmt(Tpart);

Uhat = cpd(Tpart,r);
Tparthat = cpdgen(Uhat);
Dparthat = Tparthat(:,:,1);
Z = linkage(Dparthat);
Cl = cluster(Z,'maxclust',3);
%clusters based on low-rank approximation from an incomplete tensor
figure(4);
gscatter(set(:,1),set(:,2),Cl);

%creating incomplete tensor with complete expert knowledge
Tpart2 = NaN(300,300,2);
Tpart2(:,:,2) = T(:,:,2);
for i=1:300
    for j=1:i
        if rand<= inc
            Tpart2(i,j,1) = T(i,j,1);
            Tpart2(j,i,1) = T(i,j,1);
        end
    end
end
Tpart2 = fmt(Tpart2);

Uhat = cpd(Tpart2,r);
Tpart2hat = cpdgen(Uhat);
Dpart2hat = Tpart2hat(:,:,1);
Z = linkage(Dpart2hat);
Cl = cluster(Z,'maxclust',3);
%clusters based on low-rank approximation from an incomplete tensor
figure(5);
gscatter(set(:,1),set(:,2),Cl);

norm(D-Dhat,'fro')/norm(D,'fro')
norm(D-Dparthat,'fro')/norm(D,'fro')
norm(D-Dpart2hat,'fro')/norm(D,'fro')

function clusterAndPlot(T,set,i,title)
    Z = linkage(T(:,:,1));
    Cl = cluster(Z,'maxclust',3);
    figure("Name",title);
    gscatter(set(:,1),set(:,2),Cl);
end


