% FSTD: Create a Tucker decomposition based on the FSTD algorithm.
%parameters:
%   Y: Tensor to decompose.
%   r: dimension of the decomposition.
%result:
%   W: The core of the decomposition.
%   Cn: Factor matrices.
%Besed on paper: Generalizing the column-row matrix decomposition to
%multi-way arrays by Caiafa and Cichocki.
function [W,Cn] = FSTDX(Y,r)
    sz = size(Y);
    IJK ={};
    for i =1:length(sz)
        IJK{1,i} = randi(sz(i),1,r);
    end
    W = Y(IJK{:});
    size(W)
    Cn={};
    for i=1:length(sz)
        indx = IJK;
        indx{1,i} = 1:sz(i);
        C = Y(indx{:});
        C = tens2mat(C,i);
        Wi=tens2mat(W,i);
        Cn{1,i} = C*pinv(Wi);
    end
end