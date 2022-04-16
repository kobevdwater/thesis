%PARCUBEnnX: Create a low rank CP decomposition using the ParCube algorithm.
%    Uses a non-negative approximation of the CP decomposition by using a 
%    non-negative matrix factorization. 
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
%   U1: approximation of the first factor matrix of the CP decomposition of X.
% based on paper: ParCube: Sparse Parallelizable Tensor Decompositions.
%   Papalexakis.
function U1 = ParCubennX(X,sr,options)
    arguments
        X
        sr (1,1) {mustBeNumeric} = 1
        options.intact (1,1) {mustBeNumericOrLogical} = false
        options.distance (1,1) logical = true
        options.R (1,1) {mustBeNumeric} = 10
    end
    [Xs,~,~] = BiasedSample(X,sr,'intact',options.intact,'distance',options.distance);
    size(Xs)
    Xs = squeeze(Xs);
    M = tens2mat(Xs,1);
    dim = options.R;
    U1 = nnmf(M,dim);
end


    