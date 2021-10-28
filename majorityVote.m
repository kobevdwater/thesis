%MAJORITYVOTE compute the majority vote form multiple clusterings.
%Note: clusters have to have the same base. 1 has to denote the same
%   cluster in each clustering.
%parameters:
%   Clusters: matrix with a clustering in each row.
%returns
%   cluster: one cluster where each element is assigned to the majority
%       vote of all the clusterings.
function cluster = majorityVote(Clusters)
    sz = size(Clusters);
    cluster = zeros(sz(2),1);
    k = max(Clusters, [], 'all'); %k = maximum value of Clusters
    for i=1:sz(2)
        amount = zeros(k,1);
        for j=1:sz(1)
            elem = Clusters(j,i);
            amount(elem) = amount(elem)+1;
        end
        [~,cluster(i)] = max(amount); %set cluster(i) to the max index of amount.
    end


end