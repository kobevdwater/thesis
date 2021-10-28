%BIASEDSAMPLE Sample tensor X.
%parameters:
%   X: the tensor being sampled.
%   sr: the samplerate. 
%returns:
%   Xsmall: the sampled tensor. sr.*size(X) == size(Xsmall)
%   I,J,K: the index set of the sampled entries. 
%       Xsmall(i,j,k) = X(I(i),J(j),K(k) 
%Note: for ParCube: sampling should not happen uniformly, but w.r.t to the
% size of the entries. 
function [Xsmall, I,J,K] = BiasedSample(X,sr)

    sz = size(X);
    Ssz = ceil(sz.*sr);
    I = randperm(sz(1),Ssz(1));
    J = randperm(sz(2),Ssz(2));
    K = randperm(sz(3),Ssz(3));
    Xsmall = X(I,J,K);

    
end