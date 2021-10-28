%SPECTRALCLUSTERING: cluster instances based on its distance/similarity
%       matrix and the spectral clustering method.
%parameters:
%   Dist: Distance or similarity matrix (depending on type parameter)
%   dim: dim. of the used features.
%   k: nb of clusters.
%returns:
%   Clusters: clustering of the instances.
%based on paper: On Spectral Clustering: Analysis and an algorithm. Ng
function Clusters = spectralClustering(Dist,dim,k,type)
    sz = size(Dist);
    A = Dist;
    if ~exist('type','var') || ~strcmp(type,'sim')
     A = exp(-Dist.^2/(2*10^2));
    end
    A = A- diag(ones(sz(1),1));
    D = diag(sum(A,2));
    L = D^(-1/2)*A*D^(-1/2);
    [V,De] = eig(L);
    [~,ind] = sort(diag(De),'descend');
    X = V(:,ind);
    X = X(:,2:dim+1); %Is het de bedoeling dat we de eerste eigenv. weggooien? Zorgt op eerste zicht wel voor betere restulaten.
    Y = bsxfun(@rdivide,X,(sum(X.^2,2).^(1/2)));
    Clusters = kmeans(transpose(Y),k);

    

end