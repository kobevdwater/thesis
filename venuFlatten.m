% VENUFLATTEN: Create a similarity matrix based on a tensor using sampling.
%parameters:
%   Y: Tensor to create similarity matrix from
%   r: fibers to use in the sampling.
%   options.am: amount of retries for OpstellenKnasverdeling. Default: 10
%   options.abs: chose the way the sampled fivers are chosen. Default: 3
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
function [simMat,DisMat] = venuFlatten(Y,r,options)
    arguments
        Y
        r (1,1) {mustBeNumericOrLogical} = false;
        options.am {mustBeNumeric,mustBePositive} = 10;
        options.abc (1,1) {mustBeNumeric} = 3;
    end
    sz = size(Y);
    maxfibers = prod(sz(2:end),'all');
    if r    
        if options.abc==1
            I = randi(maxfibers,r,1);
        elseif options.abc == 2
            I = round(linspace(1,maxfibers,r));
        else
            p = OpstellenKansverdeling(Y,'am',options.am);
            I = datasample(1:maxfibers,r,'Weights',p(:)','Replace',false);
        end

    else
        I = ':';
    end
    M = tens2mat(Y,1);
    M = M(:,I);
    M1t = M'./vecnorm(M');
    D = pdist(M1t','euclidean');
    DisMat = squareform(D);
    simMat = M1t'*M1t;
end