function score = ARI(x,y)
    table = crosstab(x,y);
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
    for i=1:length(a)
        as = as + a(i)*(a(i)-1)/2;
    end
    bs = 0;
    for j=1:length(b)
        bs = bs + b(j)*(b(j)-1)/2;
    end
    c = as*bs/(n*(n-1)/2);
    score = (comb-c);
    score = score/(0.5*(as+bs)-c);
