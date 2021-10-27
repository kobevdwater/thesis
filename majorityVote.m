function cluster = majorityVote(Clusters)
    sz = size(Clusters);
    cluster = zeros(sz(2),1);
    k = max(Clusters, [], 'all');
    for i=1:sz(2)
        amount = zeros(k,1);
        for j=1:sz(1)
            elem = Clusters(j,i);
            amount(elem) = amount(elem)+1;
        end
        [~,cluster(i)] = max(amount);


end