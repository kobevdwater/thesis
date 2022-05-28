%ADAPTIVEINDEXCHOISE adaptively chose indiches for FSTD algorithm.
% Indiches will be chosen based on the approximation error of the
% previously chosen fibers.
%parameters:
%   Y: Tensor to which FSTD is applied.
%   r: amount of indices that are chosen in each mode.
%returns
%   IJK: chosen indices.
function IJK = adaptiveIndexChoiseX(Y,r)
    sz = size(Y);
    IJK = {};
    str={1:sz(1)};
    %Chose random initial indices.
    for i=2:length(sz)
        IJK{1,i} = randi(sz(i));
        str{1,i} = IJK{1,i};
    end
    [~,maxi] = max(abs(Y(str{:})));
    IJK{1,1} = maxi;
    for p=2:r
        for q=1:length(sz)
            [~,maxi] = max(abs(getresidualX(Y,IJK,q)));
            IJK{1,q} = [IJK{1,q} maxi];
        end
    end
end



