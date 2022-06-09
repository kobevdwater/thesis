%SPECTRALCLUSTERING: cluster instances based on its distance/similarity
%       matrix and the spectral clustering method.
%parameters:
%   Dist: Distance or similarity matrix (depending on type parameter)
%   k: nb of clusters.
%   options.isDist: true if the given Dist matrix is a distance matrix.
%       false if it is a similarity matrix.
%   option.preComputed: true if the the Dist matrix 
%returns:
%   Clusters: clustering of the instances.
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