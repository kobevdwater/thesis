% VENUFLATTENP: Create a similarity matrix of the third mode based on a tensor using sampling
%parameters:
%   Y: Tensor to create similarity matrix from in the third mode.
%   r: amount of fibers to use in the sampling.
%   am: amount of retries for OpstellenKnasverdeling. Default: 10
%   abs: chose the way the sampled fivers are chosen. Default: 3
%       possible options:
%           1: take r fibers at random.
%           2: take r fibers uniformly spaced from eachother.
%           3: take r fibers chosen with probablilty distribution
%result:
%   simMat: similarity matrix
%   disMat: distance matrix
%Based on paper: A tensor decomposition for geometric grouping and
%segmentation by Govindu.
%
% See also OPSTELLENKANSVERDELING
function [simMat,DisMat] = venuFlattenP(Y,r,options)
    arguments
        Y
        r (1,1) {mustBeNumericOrLogical} = false;
        options.am {mustBeNumeric,mustBePositive} = 10;
        options.abc (1,1) {mustBeNumeric} = 3;
    end
    sz = size(Y);
    maxfibers = prod(sz,'all')./sz(3);
    %probability distribution to sample a fiber. Based on the norm of the
    %two fibers running trough the fiber.
    p = OpstellenKansverdeling(Y,'am',options.am);
    p = sum(p,2);
    pa = permute(p,[2,1,3]);
    p = pagemtimes(p,pa);
    if r
        r = min(r,maxfibers);
        if options.abc==1
            I = randi(maxfibers,1,r);
        elseif options.abc == 2
            I = round(linspace(1,maxfibers,r));
        else
            I = datasample(1:maxfibers,r,'Weights',p(:)','Replace',false);
        end
    else
        I = ':';
    end
    M = tens2mat(Y,3);
    M = M(:,I);
    M1t = M'./vecnorm(M');
    D = pdist(M1t','euclidean');
    DisMat = squareform(D);
    simMat = M1t'*M1t;
end