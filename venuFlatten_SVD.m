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

% This function is only used for testing purposes.
function [simMat,DisMat] = venuFlatten_SVD(Y,r,options)
    arguments
        Y
        r (1,1) {mustBeNumeric} = -1
        options.am (1,1) {mustBeNumeric} = 10
        options.abc (1,1) {mustBeNumeric} = 3
    end
    am = options.am;
    abc = options.abc;
    [i,j,k] = size(Y);
    p = OpstellenKansverdeling(Y,'am',am);
    
    if r > 0
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
    [A,~,~] = svds(M,50);
    A1t = A'./vecnorm(A');
    D = pdist(A1t','euclidean');
    DisMat = squareform(D);
    simMat = max(0,A1t'*A1t)
%     M = (M'./vecnorm(M'))';
%     simMat = M*M';
end