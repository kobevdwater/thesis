%SOLRADM create an approximation of a distance matrix using Sample-Optimal
%   Low-Rank Approximation for Distance Matrices.
%parameters: 
%   D: the distance matrix to be approximated.
%   k: rank of the approximation.
%   ep: parameter specifying how accurate the approximation has to be.
%       Lower values will result in a higher sampling-rate of D.
%retruns: 
%   Dh: approximation of the matrix D.
%Based on paper: Sample-Optimal Low-Rank Approximation of Distance
%   Matrices. P. Indyk.
%Implementation based on work of Mathias Pede.
function Dh = SOLRADM(D, k, ep)
    p = OpstellenKansverdeling(D);
    U = FMCLRA(D,p,k,ep);
    V = regression(U,D,ep);
    Dh = U*V;