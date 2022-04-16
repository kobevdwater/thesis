%BIASEDSAMPLE Sample tensor X. Choses fibers at random. 
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
function [Xsmall, IJK,Ssz] = BiasedSampleX(X,sr,options)
    arguments 
        X 
        sr {mustBeLessThanOrEqual(sr,1)}
        options.intact {mustBeNumericOrLogical} = false
        options.distance {mustBeNumericOrLogical} = true
    end
    sz = size(X);
    Ssz = ceil(sz.*sr);
    IJK = {};
    for i=1:length(sz)
        IJK{1,i} = datasample(1:sz(i),Ssz(i),'Replace',false);
    end
    if options.intact
        IJK{1,options.intact} = 1:sz(options.intact);
    end
    Xsmall = X(IJK{:});
end