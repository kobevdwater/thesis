%GETEXACTCLUSTERS get clusters based on an exact decomposition
%parameters:
%   method: The method to use
%   decomp: struct containing the tensor and its decompositions.
%       Y: the tensor.              
%       G: core of tucker decomposition.
%       U: factor matrices of the tucker decomposition.
%       C: factor matrices of the CP decomposition.
%   R: the rank of the decomposition. Only for methods that do not use the
%       decomposition in decomp.
%   k: amount of clusters.
%Supported methods:
%   Tucker1: using a Tucker decomposition and ClusterOnTucker1 
%   Tucker2: using a Tucker decomposition and ClusterOnTucker2 
%   Tucker3: using a Tucker decomposition and ClusterOnTucker3
%   Tucker(1/2)D: using a Tucker decomposition and ClusterOnTukcer(1/2) and
%       using the first and second feature matrix to create the similarity
%       matrix.
%   Tucker1P: using a Tucker decomposition and ClusterOnTucker1 for
%       clustering the third mode.
%   CP1: using a CP decomposition and ClusterOnCP.
%   CP2: using a CP decomposition and ClusterOnCP2.
%   CP(1/2)D: using a CP decomposition and ClusterOnCP(2) and using the
%       first and second feature matrix to create the similarity matrix.
%   CPnn1: using a non-negative CP decomposition and ClusterOnCP.
%   NNMF: using a non-negative matrix factorization and ClusterOnCP.
%   SVD: using a svd matrix composition and ClusterOnCP.
%   BestMatrix: chosing the best matrix clustering based on the SSET.
%   Random: random clusters.
%   SFC: Using spectral clustering with the similarity matrix from SFC.
%   Venu: Using spectral clustering with the similarity matrix from Venu.
%   VenuP: Using spectral clustering with the similarity matrix from Venu
%       to cluster the third mode.
function Clusters = getExactClusters(method,R,decomp,k)
    switch method
        case "Tucker1"
            Clusters = clusterOnTucker(decomp.G,decomp.U{1,1},k);
        case "TuckerD1"
            Clusters = clusterOnTucker(decomp.G,decomp.U{1,1},k,decomp.U{1,2});
        case "Tucker2"
            Clusters = clusterOnTucker2(decomp.G,decomp.U{1,1},k);
        case "TuckerD2"
            Clusters = clusterOnTucker2(decomp.G,decomp.U{1,1},k,decomp.U{1,2});
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
        case "CPD1"
            Clusters = clusterOnCP(decomp.C{1,1},k,decomp.C{1,2});
        case "CP2"
            Clusters = clusterOnCP2(decomp.C{1,1},k);
        case "CPD2"
            Clusters = clusterOnCP2(decomp.C{1,1},k,decomp.C{1,2});
        case "CPnn1"
            C = cp_nmu(tensor(decomp.Y),R);
            Clusters = clusterOnCP(C{1,1},k);
        case "NNMF"
            M = tens2mat(decomp.Y,1);
            [W,~] = nnmf(M,R);
            Clusters = clusterOnCP(W,k);
        case "SVD"
            M = tens2mat(decomp.Y,1);
            [U,~,~] = svds(M,R);
            Clusters = clusterOnCP(U,k);
        case "Random"
            [I,~,~] = size(decomp.Y);
            Clusters = randi(k,1,I);
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
        case "Flatten"
            D = sum(decomp.Y,3:length(size(decomp.Y)));
            Clusters = spectralClustering(D,k,"isDist",true);

        otherwise
            error('unexpected method name: '+method);
    end
end