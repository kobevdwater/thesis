%BIASEDSAMPLE Sample tensor X. Uses the Opstellen Kansverdeling function to
% create a distribution for sampling. 
%parameters:
%   X: the tensor being sampled.
%   sr: the samplerate. Either one number smaller than one. Or an array of
%       number smaller than one with one element for each mode of X. Even
%       if the first mode will be kept intact.
%   intact: true if the first mode needs to be intact. The whole mode will be kept. 
%   distance: ture if the given tensor is a distance tensor. If it is, we
%       can use the OpstellenKansverdelelings functie. Otherwise we use the
%       exact vector norms.
%returns:
%   Xsmall: the sampled tensor.
%   IJK: the index set of the index sets of the sampled entries. 
%       In case of a third order tensor: Xsmall(i,j,k) = X(I(i),J(j),K(k)) 
%   Ssz: size of Xsmall.
% See also OPSTELLENKANSVERDELING
function [Xsmall, IJK,Ssz] = BiasedSample(X,sr,intact,distance)
    sz = size(X);
    Ssz = ceil(sz.*sr);
    pi = {};
    if distance
        p = OpstellenKansverdeling(X);
        for i=2:length(sz)
            pi{1,i} = sum(tens2mat(p,i-1),2);
        end
        pi{1,1} = pi{1,2};
    else
        for i=1:length(sz)
            pi{1,i} = vecnorm(tens2mat(X,i),2,2);
            size(pi{1,i})
        end
    end
    IJK = {};
    if intact
        IJK{1,1} = 1:sz(1);
    else
        IJK{1,1} = datasample(1:sz(1),Ssz(1),'Weights',pi{1,1},'Replace',false);
    end
    for i=2:length(sz)
        IJK{1,i} = datasample(1:sz(i),Ssz(i),'Weights',pi{1,i},'Replace',false);
    end
    Xsmall = X(IJK{:});
end