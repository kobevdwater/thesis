%PARCUBE Create an approximation of the given tensor using only a subset of
%   its values.
%parameters: 
%   X: the tensor to be approximated.
%   dim: the amount of dimentions used in the CP decomposition.
%   sr: sampling rate: the fraction of elements used in each mode in the
%       approximation.
%returns:
%   Xhat: approximation of the tensor X.
% based on paper: ParCube: Sparse Parallelizable Tensor Decompositions.
%   Papalexakis.
function Xhat = ParCube(X,dim,sr)
    [Si,Sj,Sk] = size(X);
    [Xsmal,I,J,K] = BiasedSample(X,sr);
    Us = cpd(Xsmal,dim);
    Ah = zeros(Si,dim);Bh = zeros(Sj,dim);Ch = zeros(Sk,dim);
    Ah(I,:) = Us{1,1}; Bh(J,:) = Us{1,2}; Ch(K,:) = Us{1,3};
    U = {Ah,Bh,Ch};
    Xhat = cpdgen(U);

end


    