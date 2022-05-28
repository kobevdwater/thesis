%SPECTRALCLUSTERING: cluster instances based on its distance/similarity
%       matrix and the spectral clustering method.
%parameters:
%   Dist: Distance or similarity matrix (depending on type parameter)
%   dim: dim. of the used features.
%   k: nb of clusters.
%returns:
%   Clusters: clustering of the instances.
%based on paper: On Spectral Clustering: Analysis and an algorithm. Ng
function Clusters = spectralClustering(Dist,k,options)
    arguments
        Dist
        k (1,1) {mustBeNonnegative,mustBeNumeric}
        options.isDist (1,1) {mustBeNumericOrLogical} = false
        options.preComputed = true
    end
    if options.preComputed
        A = Dist;
        if options.isDist
            mx = max(Dist,[],"all");
            Dist = Dist./mx;
            A = exp(-Dist.^2/2);
        end
        Clusters = spectralcluster(A,k,'Distance','precomputed','LaplacianNormalization','symmetric');
    else 
        Clusters = spectralcluster(Dist,k);
    end
end