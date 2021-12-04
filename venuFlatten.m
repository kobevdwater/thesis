%Based on paper: A tensor decomposition for geometric grouping and
%segmentation by Govindu.
function simMat = venuFlatten(Y,r)
    [i,j,k] = size(Y);
    p = OpstellenKansverdeling(Y);
    I = datasample(1:j*k,r,'Weights',p,'Replace',false);
    M = tens2mat(Y,1);
    M = M(I,:);
    simMat = M*M';
end