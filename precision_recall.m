precision = zeros(1,20);
recall = zeros(1,20);
for i=1:20
    cl = spectralClustering(D(:,:),10,i*50);
    [precision(i),recall(i)] = BCubed(cl,expected); 
end
plot(precision,recall);