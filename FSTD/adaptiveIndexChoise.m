%ADAPTIVEINDEXCHOISE adaptively chose indiches for FSTD algorithm.
% Indiches will be chosen based on the approximation error of the
% previously chosen fibers. 
%parameters:
%   Y: Tensor to which FSTD is applied.
%   r: amount of fibers/indices chosen in each mode.
%returns
%   I,J,K: chosen indices.
function IJK = adaptiveIndexChoise(Y,r)
    sz = size(Y);
    IJK = {};
    str={1:sz(1)};
    for i=2:length(sz)
        IJK{1,i} = randi(sz(i));
        str{1,i} = IJK{1,i};
    end
    [~,maxi] = max(abs(Y(str{:})));
    IJK{1,1} = maxi;
    for p=2:r
        for q=1:length(sz)
            [~,maxi] = max(abs(getresidual(Y,IJK,q)));
            IJK{1,q} = [IJK{1,q} maxi];
        end
    end
end



