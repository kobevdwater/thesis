% FSTD: Create a Tucker decomposition based on the FSTD algorithm.
%   Choses indexes based on the relative approximation error.
%parameters:
%   Y: Tensor to decompose.
%   r: dimension of the decomposition.
%result:
%   W: The core of the decomposition.
%   Cn: Factor matrices.
%Besed on paper: Generalizing the column-row matrix decomposition to
%multi-way arrays by Caiafa and Cichocki.
function [W,Cn] = FSTDY(Y,r)
    sz = size(Y);
    IJK = adaptiveIndexChoiseY(Y,r);
    W = Y(IJK{:});
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