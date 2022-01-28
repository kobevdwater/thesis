%load('./data/groteMatrix.mat');
%load('./amie/info.mat');
persons = 50;
sensors = 20;
index = 1:persons*sensors;
expectedPerson = ceil(index/sensors);
expectedSensor = mod(index-1,sensors)+1;
expectedcl = info(2,expectedPerson);
k=length(unique(expectedcl));
cl = spectralClustering(D(:,:),3,k);
clNumbers = unique(expectedcl);
mapping = zeros(1,max(cl));
for i=1:length(clNumbers)
    mapping(clNumbers(i)) = i;
end
expectedCl2 = mapping(expectedcl);
[pr,re] = BCubed(cl,expectedCl2)

