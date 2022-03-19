%GETEXACTCLUSTERS get clusters based on an exact decomposition
%parameters:
%   method: The method to use
%   decomp: struct containing the tensor and ist decompositions.
%       G: core of tucker decomposition.
%       U: factor matrices of the tucker decomposition.
%       C: factor matrices of the CP decomposition.
%   k: amount of clusters.
function Clusters = getExactClusters(method,decomp,k)
    switch method
        case "Tucker1"
            Clusters = clusterOnTucker(decomp.G,decomp.U{1,1},k);
        case "Tucker2"
            Clusters = clusterOnTucker2(decomp.G,decomp.U{1,1},k);
        case "Tucker3"
            Clusters = clusterOnTucker3(decomp.G,decomp.U{1,1},k);
        case "Tucker1P"
            G = decomp.Gp;
            sz = size(G);
            temp = sz(3);
            sz(3) = sz(1);
            sz(1) = temp;
            Gt = tens2mat(G,3);
            Gt = mat2tens(Gt,sz,1);
            Clusters = clusterOnTucker(Gt,decomp.Up{1,3},k);
        case "CP1"
            Clusters = clusterOnCP(decomp.C{1,1},k);
        case "CP2"
            Clusters = clusterOnCP2(decomp.C{1,1},k);
        case "Random"
            [I,~,~] = size(decomp.Y);
            Clusters = randi(k,1,I);
        case "Ex"
            [I,~,~] = size(decomp.Y);
            Clusters = info(2,1:I);
        case "Weighted"
            Clusters = SSEWeightedClustering(decomp.Y,k,10);
        case "BestMatrix"
            Clusters = BestMatrixSSEClustering(decomp.Y,k,10);
        case "Venu"
            Sim = venuFlatten(decomp.Y);
            Clusters = spectralClustering(Sim,k);
        case "VenuP"
            Sim = venuFlattenP(decomp.P);
            Clusters = spectralClustering(Sim,k);
        case "SFC"
            Clusterings = clusterTensor(decomp.Y,k);
            Sim = SimFromClusterings(Clusterings);
            Clusters = spectralClustering(Sim,k);
        otherwise
            warning('unexpected method name'+method);
    end
end