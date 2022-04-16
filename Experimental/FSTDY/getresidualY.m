%GETRESIDUALY: get the relative difference between the tensor Y and the approximation
% Yh on one fiber.
%parameters:
%   Y: the tensor that is to be approximated
%   IJK: a {1,N} structure containing the fiber that where previously chosen for
%       each mode.
%   mode: The mode of the resulting fiber.
%returns:
%   E = ((Y-Yh)/Y)(I1,I2,...,Im-1,:,Im+1,...,IN)
%   where:
%       Yh: The approximation of Y created by FSTD when using the fibers in
%           IJK.
%       In: The last index in IJK{1,n}
%       m: the given mode.
function E = getresidualY(Y,IJK,mode)
    sz = size(Y);
    W = Y(IJK{:});
    Ci = {};
    Wi = {};
    for i=1:length(sz)
        idx = IJK;
        idx{1,i} = 1:sz(i);
        Ci{1,i} = tens2mat(Y(idx{:}),i);
        Wi{1,i} = pinv(tens2mat(W,i));
    end
    %indices: contains last elements of IJK.
    indices = {};
    for i=1:length(sz)
        indices{1,i} = IJK{1,i}(end);
    end
    U = {};
    for i=1:length(sz)
        if i==mode
            U{1,i} = Ci{1,i}*Wi{1,i};
        else
            U{1,i} = Ci{1,i}(indices{1,i},:)*Wi{1,i};
        end
    end
    indices{1,mode} = 1:sz(mode);
    Yf = Y(indices{:});
    E = (Yf-lmlragen(U,W))./Yf;
    E(isinf(E)) = 0;
    E(isnan(E)) = 0;
end