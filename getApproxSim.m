%GETAPPROXSIM get a similarity matrix based on a sampling method.
%parameters:
%   method: The method to use.
%   samplerate: The samplerate to be used in th sampling method.
%   tensor: distance tensor to compute a similarity matrix from.
%result
%   Sim: Similarity matrix of the first mode of the tensor.
%Supported methods:
%   Venu.
%   FSTD
%   ParCube
%   MACH
%   SOLSFC: Unsing SOLRADM and SFC
%Eperimental methods:
%   VenuRa: Using random fibers.
%   VenuSp: Chosing fibers that are spread out as far as
%       possible.
%   FSTDX: using random fibers.
%   FSTDY: using fibers chosen with largest relative error
%   FSTDZ: using fibers chosen based on a distribution proportional to
%       relative error.
%   ParCubenn
%   ParCubennX
%   ParCubeX
%   MACH_HOSVDnn
function Sim = getApproxSim(method, samplerate,tensors,k)
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
            Sim = venuFlatten(Y,r);
        case "FSTD1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r);
            S2 = tmprod(W,Cn{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;
        case "FSTD2"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r); 
            M = Cn{1,1}';
            M = M./vecnorm(M);
            Sim = M'*M;
        case "ParCube1"
            U = ParCube(Y,samplerate^(1/(length(sz)-1)),'intact',1);
            M = A1';
            M = M./vecnorm(M);
            Sim = M'*M;
        case "MACH1"
            [G,U] = MACH_HOSVD(Y,15,samplerate);
            S2 = tmprod(G,U{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;
        case "MACH2"
            [G,U] = MACH_HOSVD(Y,15,samplerate);
            M = U{1,1}';
            M = M./vecnorm(M);
            Sim = M'*M;
        case "SOLSFC"
            a = sqrt(samplerate/2);
            Clusterings = getSOLRADMClusters(Y,a,k);
            Sim = SimFromClusterings(Clusterings);
 %Experimental
        case "VenuRa"
            r  = floor(samplerate*prod(sz(2:end),'all'));
            Sim = venuFlatten(Y,r,'abc',1);
        case "VenuSp"
            r  = floor(samplerate*prod(sz(2:end),'all'));
            Sim = venuFlatten(Y,r,"abc",2);
        case "FSTDX1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDX(Y,r);
            S2 = tmprod(W,Cn{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;
        case "FSTDY1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDY(Y,r);
            S2 = tmprod(W,Cn{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;        
        case "FSTDZ1"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDZ(Y,r);
            S2 = tmprod(W,Cn{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;
        case "ParCubenn1"
            U = ParCubenn(Y,samplerate^(1/(length(sz)-1)),'intact',1,'k',15);
            M = A1';
            M = M./vecnorm(M);
            Sim = M'*M;
        case "ParCubeX1"
            U = ParCubeX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'k',15);
            M = A1';
            M = M./vecnorm(M);
            Sim = M'*M;        case "ParCubeX2"
            U = ParCubeX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'R',15);
            Clusters = clusterOnCP2(U{1,1},k);
        case "ParCubennX1"
            U1 = ParCubennX(Y,samplerate^(1/(length(sz)-1)),'intact',1,'R',15);
            M = A1';
            M = M./vecnorm(M);
            Sim = M'*M;
        case "MACHnn1"
            [G,U] = MACH_HOSVDX(Y,15,samplerate);
            S2 = tmprod(G,U{1,1},1);
            ln = length(size(S2));
            %split the frontal slices and vectorise and normalize them.
            M = tens2mat(S2,2:ln,1);
            M = M./vecnorm(M);
            Sim = M'*M;        
        otherwise 
            warning('unexpected method name '+ method)
    end
end