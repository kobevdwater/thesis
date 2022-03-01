% VENUFLATTEN: Create a similarity matrix of the third mode based on a tensor using sampling
%parameters:
%   Y: Tensor to create similarity matrix from in the third mode.
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
function [simMat,DisMat] = venuFlattenP(Y,r,am,abc)
    if nargin < 3
        am = 10;
    end
    if nargin < 4
        abc = 3;
    end
    [i,j,k] = size(Y);
    %probability distribution to sample a fiber. Based on the norm of the
    %two fibers running trough the fiber.
    p = OpstellenKansverdeling(Y,'am',am);
    p = sum(p,2);
    p = kron(p,p);
    r = min(r,i*j);
    if nargin >= 2
        if abc==1
            [~,I] = maxk(p(:),r);
        elseif abc == 2
            I = round(linspace(1,i*j,r));
        else
            I = datasample(1:i*j,r,'Weights',p(:)','Replace',false);
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