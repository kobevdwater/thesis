%FMCLRA Approximate the left sigular vectors of D using Fast Monte-Carlo
%   Low Rank Approximation.
%parameters:
%   D: matrix from wich the singular vectors are approximated.
%   p: probablility distribution which is an approximation of the relative
%       column norms.
%   k: rank of the resulting approximation.
%   ep: parameter specifying how accurate the approximation has to be.
%       Lower values will result in a higher sampling-rate of D.
%returns:
%   U: approximation of the first k left singular vectors of D.
%based on thesis of Mathias Pede.
function U = FMCLRA(D,p,k,ep)
    [n,~] = size(D);
    s = round(10*k/ep);
    %s = round(3*k/ep);
    I = datasample(1:n,s,'Weights',p,'Replace',false);
    S = D(:,I);
    scaling = s.*p(I);
    S = transpose(sqrt((1./scaling))).*S;
    [U,~,~] = svds(S,k);
end