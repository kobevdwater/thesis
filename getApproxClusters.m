%GETAPPROXCLUSTERS get a clustering based on a sampling method.
%parameters:
%   method: The method to use.
%   samplerate: The samplerate to be used in th sampling method.
%       When the method used the P tensor. sampling rate will be used that
%       result in the same amount of entries used as the Y tensor of the
%       same dataset using the given samplerate.
%   tensors: Struct that contains the Y and P tensors.
%   k: amount of clusters.
%result
%   Clusters: clustering of the first mode of tensor Y consisting of k
%   clusters.
%Supported methods:
%   Venu: using venuflattening and spectral clustering.
%   VenuP: using venuflattening to cluster the third mode.
%   VenuD: using venuflattening to cluster based on distance matrix.
%   VenuHi: the same as Venu, but using random fibers.
%   VenuSp: the same as Venu, but using fibers that are spread out as far
%   as possible.
%   FSTD1: using FSTD and ClusterOnTucker1
%   FSTD2: using FSTD and ClusterOnTucker2
%   FSTD3: using FSTD and ClusterOnTucker3
%   ParCube1: using ParCube and ClusterOnCP
%   ParCube2: using ParCube and ClusterOnCP2
%   MACH1: using MACH_HOSVD and ClusterOnTucker1
%   MACH2: using MACH_HOSVD and ClusterOnTucker2
%   MACH3: using MACH_HOSVD and ClusterOnTucker3
%   MACHP1: using MACH_HOSVD and ClusterOnTucker1 to cluster the third mode
%   SOLSFC: Unsing SOLRADM and SFC
%   Random: return random clusters.
%   XYZ: for sensors. Groups sensors in the x,y,z directions.
%Eperimental methods:
%   VenuD: using venuflattening th cluster based on the distance matrix.
%   VenuRa: using Venu, but using random fibers.
%   VenuSp: using Venu, but chosing fibers that are spread out as far as
%       possible.
%   FSTDX1: using FSTDX and ClusterOnTucker1.
%   FSTDY1: using FSTDY and ClusterOnTucker1.
%   FSTDZ1: using FSTDZ and ClusterOnTucker1.
%   ParCubenn1: using ParCubenn and ClusterOnCP.
%   ParCubennX1: using ParCubennX and ClusterOnCP.
%   ParCubeX1: using ParCubeX and ClusterOnCP.
%   MACH_HOSVDnn1: using HACH_HOSVDnn and ClusterOnTucker1.
function Clusters = getApproxClusters(method, samplerate,tensors,k)
    if (isfield(tensors,'Y'))
        Y = tensors.Y;
    else
        Y = tensors;
    end
    if (isfield(tensors,'P'))
        P = tensors.P;
    end
    sz = size(Y);
    switch method
        case "Venu"
            r = floor(samplerate*prod(sz(2:end),'all'));
            simMatrix = venuFlatten(Y,r);
            Clusters = spectralClustering(simMatrix,k);
        case "VenuP"
            %limit r to same amount as dataentries when we would use P
            %instead of Y.
            r = floor(samplerate*prod(sz(1:end),'all')/sz(3));
            simMatrix = venuFlattenP(P,r);
            Clusters = spectralClustering(simMatrix,k);
        case "FSTD1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k);
        case "FSTD2"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker2(W,Cn{1,1},k);
        case "FSTD3"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r);
            Clusters = clusterOnTucker3(W,Cn{1,1},k);
        case "FSTDP1"
            psr = samplerate*prod(sz,'all')/prod(size(P),'all');
            psr = min(1,psr);
            sz = size(P);
            r = floor(sqrt(psr*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(P,r);
            Wt = turnCore(W);
            Clusters = clusterOnTucker(Wt,Cn{1,3},k);
        case "ParCube1"
            U = ParCube(Y,samplerate^(1/(length(sz)-1)),'intact',1);
            Clusters = clusterOnCP(U{1,1},k);
        case "ParCube2"
            U = ParCube(Y,samplerate^(1/(length(sz)-1)),'intact',1);
            Clusters = clusterOnCP2(U{1,1},k);
        case "ParCubeP2"
            psr = samplerate*prod(sz,'all')/prod(size(P),'all');
            psr = min(1,psr);
            U = ParCube(P,psr^(1/(length(sz)-1)),'intact',3);
            Clusters = clusterOnCP(U{1,3},k);
        case "MACH1"
            [G,U] = MACH_HOSVD(Y,15,samplerate);
            Clusters = clusterOnTucker(G,U{1,1},k);
        case "MACHP1"
            %Higher sr so amount of entries used is the same as a "normal
            %tensor".
            sr = samplerate*sz(1)/sz(3);
            sr = min(sr,1);
            [G,U] = MACH_HOSVD(P,15,sr);
            %turning core around
            Gt = turnCore(G);
            Clusters = clusterOnTucker(Gt,U{1,3},k);
        case "MACH2"
            [G,U] = MACH_HOSVD(Y,15,samplerate);
            Clusters = clusterOnTucker2(G,U{1,1},k);
        case "MACH3"
            [G,U] = MACH_HOSVD(Y,15,samplerate);
            Clusters = clusterOnTucker3(G,U{1,1},k);
        case "Random"
            Clusters = randi(k,size(Y,1),1);
        case "XYZ"
            Clusters = repmat([1;2;3],75/3,1);
        case "SOLSFC"
            a = sqrt(samplerate/2);
            Clusterings = getSOLRADMClusters(Y,a,k);
            Sim = SimFromClusterings(Clusterings);
            Clusters = spectralClustering(Sim,k);
        case "FSTDSFC"
            r = floor(sqrt(samplerate*size(Y,1)*size(Y,2)*size(Y,3)/(size(Y,1)+size(Y,2)+size(Y,3))));
            Clusterings = getFSTDClusters(Y,r,k);
            Sim = SimFromClusterings(Clusterings);
            Clusters = spectralClustering(Sim,k);
 %Experimental
        case "VenuD"
            r = floor(samplerate*prod(sz(2:end),'all'));
            [~,Dist] = venuFlatten(Y,r);
            Clusters = spectralClustering(Dist,k,'isDist',true);
        case "VenuRa"
            r  = floor(samplerate*prod(sz(2:end),'all'));
            simMatrix = venuFlatten(Y,r,'abc',1);
            simMatrix = max(simMatrix,0);
            Clusters = spectralClustering(simMatrix,k);
        case "VenuSp"
            r  = floor(samplerate*prod(sz(2:end),'all'));
            simMatrix = venuFlatten(Y,r,"abc",2);
            Clusters = spectralClustering(simMatrix,k);
        case "VenuSpP"
            %limit r to same amount as dataentries when we would use P
            %instead of Y.
            r = floor(samplerate*prod(sz(1:end),'all')/sz(3));
            simMatrix = venuFlattenP(P,r,"abc",2);
            Clusters = spectralClustering(simMatrix,k);
        case "FSTDX1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDX(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k);
        case "FSTDY1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDY(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k);
        case "FSTDY2"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDY(Y,r);
            Clusters = clusterOnTucker2(W,Cn{1,1},k); 
        case "FSTDYP1"
            psr = samplerate*prod(sz,'all')/prod(size(P),'all');
            psr = min(1,psr);
            sz = size(P);
            r = floor(sqrt(psr*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDY(P,r);
            Wt = turnCore(W);
            Clusters = clusterOnTucker(Wt,Cn{1,3},k);
        case "FSTDZ1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDZ(Y,r);
            Clusters = clusterOnTucker(W,Cn{1,1},k);
        case "ParCubenn1"
            U = ParCubenn(Y,samplerate^(1/(length(sz)-1)),'intact',1,'k',15);
            Clusters = clusterOnCP2(U{1,1},k);
        case "ParCubeX1"
            U = ParCubeX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'k',15);
            Clusters = clusterOnCP(U{1,1},k);
        case "ParCubeX2"
            U = ParCubeX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'R',15);
            Clusters = clusterOnCP2(U{1,1},k);
        case "ParCubennX1"
            U1 = ParCubennX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'R',15);
            Clusters = clusterOnCP(U1,k);
        case "MACHnn1"
            [G,U] = MACH_HOSVDX(Y,15,samplerate);
            Clusters = clusterOnTucker(G,U{1,1},k);
        case "MACHnan1"
            [G,U] = MACH_HOSVDnan(Y,15,samplerate);
            Clusters = clusterOnTucker(G,U{1,1},k);
        otherwise 
            warning('unexpected method name '+ method)
    end
end

function Gt = turnCore(G)
    sz = size(G);
    temp = sz(3);
    sz(3) = sz(1);
    sz(1) = temp;
    Gt = tens2mat(G,3);
    Gt = mat2tens(Gt,sz,1);
end