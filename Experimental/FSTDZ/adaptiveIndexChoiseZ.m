%ADAPTIVEINDEXCHOISEZ adaptively chose indiches for FSTD algorithm.
% Indiches will be chosen based on a distribution proportional to the relative ressidual. 
%parameters:
%   Y: Tensor to which FSTD is applied.
%   r: amount of fibers/indices chosen in each mode.
%returns
%   I,J,K: chosen indices.
function IJK = adaptiveIndexChoiseZ(Y,r)
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
            pi = abs(getresidualY(Y,IJK,q));
            maxi = datasample(1:length(pi),1,'Weights',pi(:));
            IJK{1,q} = [IJK{1,q} maxi];
        end
    end
end
