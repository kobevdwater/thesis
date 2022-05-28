% FSTD: Create a Tucker decomposition based on the FSTD algorithm.
%parameters:
%   Y: Tensor to decompose.
%   r: dimension of the decomposition.
%result:
%   W: The core of the decomposition.
%   Cn: Factor matrices: Cn = {A,B,C}
%   Co: The fibers that were chosen.
%Besed on paper: Generalizing the column-row matrix decomposition to
%multi-way arrays by Caiafa and Cichocki.
function [W,Cn,Co] = FSTD(Y,r)
    warning('off','all')
    sz = size(Y);
    IJK = adaptiveIndexChoise(Y,r);
    W = Y(IJK{:});
    Cn={};
    Co = {};
%     Wis = {};
    for i=1:length(sz)
        indx = IJK;
        indx{1,i} = 1:sz(i);
        C = Y(indx{:});
        C = tens2mat(C,i);
        Co{1,i} = C;
        Wi=tens2mat(W,i);
        Cn{1,i} = C*pinv(Wi);
%         Cn{1,i} = C;
%         Wis{1,i} = pinv(Wi);
%         size(Wis{1,i})
    end
%     W = lmlragen(Wis,W);
    warning('on','all')

end