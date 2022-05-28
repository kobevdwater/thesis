%ARI: calculate the ARI-score of the given clusters.
%parameters:
%   x,y: clusterings that are compaired.
%returns:
%   score: the ARI-score of the given clusterings.
function score = ARI(x,y)
    %contingency table
    table = crosstab(x,y);
    %amount of elements in each cluster
    a = sum(table,2);
    b = sum(table,1);
    n = length(x);
    assert(length(x) == length(y));
    comb = 0;
    for i=1:length(a)
        for j=1:length(b)
            ni = table(i,j);
            comb = comb + ni*(ni-1)/2;
        end
    end
    as = 0;
    %as = sum_i chose(a_i,2)
    for i=1:length(a)
        as = as + a(i)*(a(i)-1)/2;
    end
    bs = 0;
    %bs = sum_i chose(b_i,2)
    for j=1:length(b)
        bs = bs + b(j)*(b(j)-1)/2;
    end
    c = as*bs/(n*(n-1)/2);
    score = (comb-c);
    score = score/(0.5*(as+bs)-c);
