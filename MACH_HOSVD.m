%MACH_HOSVD: Create a low rank Tucker decomposition using the MACH HOSVD
%method.
%parameters:
%   X: The tensor to decompose.
%   r1,r2,r3: the rank of the decomposition in the first, second and third
%   mode.
%   p: probobility to keep an entry.
%result:
%   G: Core of the decomposition.
%   A1,A2,A3: Factor matrices.
%   sr: fraction of elements of X that are read.
%Based om paper: MACH: Fast Randomized Tensor Decompositions.By
%Tsourakakis.
function [G,U,sr] = MACH_HOSVD(X,r,p)
    sz = size(X);
    R = (rand(sz)<p);
    Xh = R.*X./p;
    sr = sum(R,'All')/(prod(sz,"all"));
    U = {};
    Ut = {};
    for i = 1:length(sz)
        [A,~,~] = svds(tens2mat(Xh,i),r);
        Ut{1,i} = A';
        U{1,i} = A;
    end
    G = lmlragen(Ut,Xh);
end
