function p = OpstellenKansverdeling(D)
    [n,~] = size(D);
    is = randi(n);
    p = 1:n;
    rowMean = 1/n*sum(D(is,:).^2);
    p = D(p,is).^2+rowMean;
    p = p./sum(p);
end