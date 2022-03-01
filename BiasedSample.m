%BIASEDSAMPLE Sample tensor X. Uses the Opstellen Kansverdeling function to
% create a distribution for sampling. 
%parameters:
%   X: the tensor being sampled.
%   sr: the samplerate. 
%   intact: true if the first mode needs to be intact. The whole mode will be kept.   
%   distance: ture if the given tensor is a distance tensor. If it is, we
%   can use the OpstellenKansverdelelings functie. Otherwise we use the
%   exact vector norms.
%returns:
%   Xsmall: the sampled tensor. [1,sr,sr].*size(X) == size(Xsmall)
%   I,J,K: the index set of the sampled entries. 
%       Xsmall(i,j,k) = X(I(i),J(j),K(k) 
% See also OPSTELLENKANSVERDELING
function [Xsmall, I,J,K] = BiasedSample(X,sr,intact,distance)
    sz = size(X);
    Ssz = ceil(sz.*sr);
    I = 1:sz(1);
    if distance
        p = OpstellenKansverdeling(X);
        p1 = sum(p,2);
        p2 = p1;
        p3 = sum(p);
    else
        p1 = squeeze(vecnorm(vecnorm(X,2,2),2,3));
        p2 = squeeze(vecnorm(vecnorm(X,2,1),2,3));
        p3 = squeeze(vecnorm(vecnorm(X,2,1),2,2));

    end

    if intact
        I = 1:sz(1);
    else
        I = datasample(1:sz(1),Ssz(1),'Weights',p1,'Replace',false);
    end
    J = datasample(1:sz(2),Ssz(2),'Weights',p2,'Replace',false);
    K = datasample(1:sz(3),Ssz(3),'Weights',p3,'Replace',false);
    Xsmall = X(I,J,K);
end