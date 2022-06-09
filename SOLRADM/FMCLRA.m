%FMCLRA Approximate the left sigular vectors of D using Fast Monte-Carlo
%   Low Rank Approximation.
%parameters:
%   D: matrix from wich the singular vectors are approximated.
%   p: probablility distribution which is an approximation of the relative
%       column norms.
%   k: rank of the resulting approximation.
%   r: amount of rows sampled.
%returns:
%   U: approximation of the first k left singular vectors of D.
%based on thesis of Mathias Pede.
function U = FMCLRA(D,p,k,r)
    [n,~] = size(D);
    I = datasample(1:n,r,'Weights',p,'Replace',false);
    S = D(:,I);
    scaling = r.*p(I);
    S = transpose(sqrt((1./scaling))).*S;
    [U,~,~] = svds(S,k);
end