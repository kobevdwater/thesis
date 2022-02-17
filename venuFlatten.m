% VENUFLATTEN: Create a similarity matrix based on a tensor using sampling.
%parameters:
%   Y: Tensor to create similarity matrix from
%   r: fibers to use in the sampling.
%   am: amount of retries for OpstellenKnasverdeling. Default: 10
%   abs: chose the way the sampled fivers are chosen. Default: 3
%       possible options:
%           1: take r fibers with the highest chance.
%           2: take r fibers uniformly spaced from eachother.
%           3: take r fibers chosen with probablilty distribution
%result:
%   simMat: similarity matrix
%   disMat: distance matrix
%Based on paper: A tensor decomposition for geometric grouping and
%segmentation by Govindu.
%
% See also OPSTELLENKANSVERDELING
function [simMat,DisMat] = venuFlatten(Y,r,am,abc)
    if nargin < 3
        am = 10;
    end
    if nargin < 4
        abc = 3;
    end
    [i,j,k] = size(Y);
    p = OpstellenKansverdeling(Y,'am',am);
    if nargin >= 2
        if abc==1
            I = randi(j*k,r,1);
        elseif abc == 2
            I = round(linspace(1,j*k,r));
        else
            I = datasample(1:j*k,r,'Weights',p(:)','Replace',false);
        end

    else
        I = ':';
    end
    M = tens2mat(Y,1);
    M = M(:,I);
    M1t = M'./vecnorm(M');
    D = pdist(M1t','euclidean');
    DisMat = squareform(D);
%     simMat = M*M';
%     M = (M'./vecnorm(M'))';
    simMat = M1t'*M1t
end