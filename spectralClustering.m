function Clusters = spectralClustering(Dist,dim,k)
    sz = size(Dist);
    A = exp(-Dist.^2/(2*1^2));
    A = A- diag(ones(sz(1),1));
    D = diag(sum(A,2));
    L = D^(-1/2)*A*D^(-1/2);
    [V,De] = eig(L);
    [d,ind] = sort(diag(De),'descend');
    X = V(:,ind);
    X= X(:,2:dim+1); %Is het de bedoeling dat we de eerste eigenv. weggooien? Zorgt op eerste zicht wel voor betere restulaten.
    Y = bsxfun(@rdivide,X,(sum(X.^2,2).^(1/2)));
    Clusters = kmeans(transpose(Y),k);

    

end