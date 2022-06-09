%PARCUBE: Create a low rank CP decomposition using the ParCube algorithm.
%parameters: 
%   X: the tensor to decompose.
%   options.intact: keep the first mode intact. Makes samplerate of the
%       first mode 1.
%   options.distance: true if the tensor X is a distance tensor.
%       see: BiasedSample.
%   options.sr: sampling rate: the fraction of elements used in each mode in the
%       approximation.
%   options.k: the dimention of the decomposition.
%returns:
%   U = {Ah,Bh,Ch}: approximation of the CP decomposition of X.
% based on paper: ParCube: Sparse Parallelizable Tensor Decompositions.
%   Papalexakis.
function U = ParCube(X,sr,options)
    arguments
        X
        sr (1,1) {mustBeNumeric} = 1
        options.intact (1,1) {mustBeNumericOrLogical} = false
        options.distance (1,1) logical = true
        options.k (1,1) {mustBeNumeric} = 15
    end
    sz = size(X);
    [Xs,IJK,originalsz] = BiasedSample(X,sr,'intact',options.intact,'distance',options.distance);
    Xs = squeeze(Xs);
    dim = options.k;
    Us = cpd(Xs,dim);
    j=1;
    U = {};
    %Sizing up decomposition.
    for i=1:length(originalsz)
        if originalsz(i) == 1
            M = zeros(sz(i),dim);
            M(IJK{1,i},:) = 1;
            U{1,i} = M;
        else
            M = zeros(sz(i),dim);
            M(IJK{1,i},:) = Us{1,j};
            U{1,i} = M;
            j = j+1;
        end
    end
end


    