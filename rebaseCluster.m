%REBASECLUSTER: Set two clusters to the same base. Permutates the second
%   cluster to find a cluster close to first.
%parameters:
%   c1,c2: clusters to rebase.
%   k: number of clusters.
%returns
%   best: best permutation of c2.
function best = rebaseCluster(c1,c2,k)
    permutations = perms([1:k]);
    bestDist = 0;
    best = zeros(1,max(size(c1)));
    for j=1:size(permutations,1)
        ttcluster = c2;
        for i=1:max(size(c2))
            ttcluster(i) = permutations(j,ttcluster(i));
        end
        nr = sum(c1 == ttcluster);
        if nr > bestDist
            best = ttcluster;
            bestDist = nr;
        end
    end
end