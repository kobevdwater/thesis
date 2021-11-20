%Based on paper: A tensor decomposition for geometric grouping and
%segmentation by Govindu.
function simMat = venuFlatten(Y)
    P = tens2mat(Y,1);
    simMat = P*P';
end