%BIASEDSAMPLE Sample tensor X. Uses the Opstellen Kansverdeling function to
% create a distribution for sampling. 
%parameters:
%   X: the tensor being sampled.
%   sr: the samplerate. 
%returns:
%   Xsmall: the sampled tensor. [1,sr,sr].*size(X) == size(Xsmall)
%   I,J,K: the index set of the sampled entries. 
%       Xsmall(i,j,k) = X(I(i),J(j),K(k) 
% See also OPSTELLENKANSVERDELING
function [Xsmall, I,J,K] = BiasedSample(X,sr)
    sz = size(X);
    Ssz = ceil(sz.*sr);
    I = 1:sz(1);
    p = OpstellenKansverdeling(X);
    p1 = sum(p,2);
    p2 = sum(p);
    J = datasample(1:sz(2),Ssz(2),'Weights',p1,'Replace',false);
    K = datasample(1:sz(3),Ssz(3),'Weights',p2,'Replace',false);
    Xsmall = X(I,J,K);
end