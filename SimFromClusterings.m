%SIMFROMCLUSTERINGS: Create one similarity matrix based on multiple clusterings.
%parameters:
%   Clusterings: matrix containing the different clusterings in the rows.
%result:
%   simMatrix: the similarity matrix created.
function simMatrix = SimFromClusterings(Clusterings)
    [clsz, sz] = size(Clusterings);
    simMatrix = zeros(sz);
    for cl=1:clsz
        cluster = Clusterings(cl,:);
        for i=1:sz
            for j=i:sz
                if (cluster(i) == cluster(j))
                    simMatrix(i,j)  = simMatrix(i,j)+1;
                end
            end
        end
    end
    simMatrix = simMatrix + simMatrix' - diag(diag(simMatrix));
    simMatrix = simMatrix./max(simMatrix,[],"all");
end