%MACH_HOSVD: Create a low rank Tucker-2 decomposition using the MACH HOSVD
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
function [F,A2,A3,sr] = MACH_HOSVD2(X,r2,r3,p)
    [I,J,K ] = size(X);
    R = (rand(I,J,K)<p);
    Xh = R.*X(:,:,:)./p;
    sr = sum(R,'All')/(I*J*K);
    %[A1,~,~] = svds(tens2mat(Xh,1),r1);
    [A2,~,~] = svds(tens2mat(Xh,2),r2);
    [A3,~,~] = svds(tens2mat(Xh,3),r3);
%     U = {A1',A2',A3'};
    F = tmprod(Xh,A2',2);
    F = tmprod(F,A3',3);
end
