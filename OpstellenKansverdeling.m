%Calculate a probability distribution proportional to a approximation of
%   the column norm of a distance matrix.
%parameters:
%   D: a distance matrix. 
%returns:
%   p: probability distribution where each entry is proportional to the
%   relative norm of the corresponding column of D.
% based on thesis Mathias Pede.
function p = OpstellenKansverdeling(D)
    [n,~] = size(D);
    is = randi(n);
    rowMean = 1/n*sum(D(is,:).^2);
    p = D(:,is).^2+rowMean;
    p = p./sum(p);
end