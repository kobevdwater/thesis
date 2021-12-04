function M = reorderMatrix(D,cl)
    [~,sind] = sort(cl);
    M = D(sind,sind,:);
end