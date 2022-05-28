%MACH_HOSVDnan: Create a low rank Tucker decomposition using the MACH HOSVD
%method. Calculates a tucker decomposition without using the zero values.
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
function [G,U,sr] = MACH_HOSVDnan(X,r,p)
    sz = size(X);
    R = (rand(sz)<p);
    Xh = R.*X./p;
    Xh(Xh==0) = nan;
    Xi = fmt(Xh);
    sr = sum(R,'All')/(prod(sz,"all"));
    core_sz = ones(1,length(size(X)))*r;
    %lmlra does not take nan into account.
    [U,G] = lmlra(Xi,core_sz);
end