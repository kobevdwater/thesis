%SIMFROMCLUSTERINGS: Create one similarity matrix based on the clusterings.
% 
%parameters:
%   Clusterings: matrix containing the different clusterings in the rows.
%result:
%   simMatrix: the similarity matrix created. The entrie (i,j) will contain
%   the similarity between the i'th en j'th clustering.
function simMatrix = SimFromClusteringsP(Clusterings)
    [clsz, ~] = size(Clusterings);
    simMatrix = zeros(clsz);
    for i=1:clsz
        clustera = Clusterings(i,:);
        for j=1:clsz
            clusterb = Clusterings(j,:);
            pr = BCubed(clustera,clusterb);
            simMatrix(i,j) = simMatrix(i,j)+pr;
        end
    end
    simMatrix = (simMatrix+simMatrix')/2;
end