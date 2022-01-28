%PARCUBE: Create a low rank CP decomposition using the ParCube algorithm.
%parameters: 
%   X: the tensor to decompose.
%   dim: the amount of dimentions used in the CP decomposition.
%   sr: sampling rate: the fraction of elements used in each mode in the
%       approximation.
%returns:
%   U = {Ah,Bh,Ch}: approximation of the CP decomposition of X.
% based on paper: ParCube: Sparse Parallelizable Tensor Decompositions.
%   Papalexakis.
function U = ParCube(X,dim,sr)
    [Si,Sj,Sk] = size(X);
    [Xsmal,I,J,K] = BiasedSample(X,sr);
    Us = cpd(Xsmal,dim);
    Ah = zeros(Si,dim);Bh = zeros(Sj,dim);Ch = zeros(Sk,dim);
    Ah(I,:) = Us{1,1}; Bh(J,:) = Us{1,2}; Ch(K,:) = Us{1,3};
    U = {Ah,Bh,Ch};
end


    