%FINDINGRELATEDSENSORS find the similarity of different sensors and cluster
%   similar sensors. By creating a TUCKER-2 decomp.
%parameters: 
%   D: distance tensor with modes (person x person x sensor)
%returns:
%   similarity: similarity matrix of sensors (sensor x sensor)
%   clusters: clustering of different sensor based on 
%       spectral clustering of the similarity matrix 
%based on paper: Tensor decompositions for feature extraction and
%   classification of high dimensional datasets. Phan and Cichocki
function [similarity,clusters,sensorClusters] = findingRelatedSensors(D,k)
    %First we get a low rank TUCKER-2 decomp. (via TUCKER-3)
    [U,S,~] = lmlra(D(:,:,:),[10,10,size(D,3)]);
    S2 = tmprod(S,U{1,3},3);
    %split the frontal slices and vectorise and normalize them.
    M = tens2mat(S2,[1,2],3);
    M = M./vecnorm(M);
    similarity = M'*M;
    %we can use this similarity matrix to cluster the sensors.
    clusters = spectralClustering(similarity,4,k,'sim');
%     low_dimM = tsne(M');
%     gscatter(low_dimM(:,1),low_dimM(:,2),clusters)
    AllSensors = h5read('amie/amie-kinect-data.hdf','/skeleton_90/axis0');
    sensorClusters = {};
    for i=1:k
        sensorClusters{i} = [];
    end

    for i=1:size(D,3)
        sensorClusters{clusters(i)} = [sensorClusters{clusters(i)} AllSensors(i)];


    

end