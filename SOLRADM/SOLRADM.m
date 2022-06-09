%SOLRADM create an approximation of a distance matrix using Sample-Optimal
%   Low-Rank Approximation for Distance Matrices.
%parameters: 
%   D: the distance matrix to be approximated.
%   k: rank of the approximation.
%   r: Specifies the amount of rows and cols sampled. Total amount of rows
%   and colls sampled will be 2r.
%retruns: 
%   Dh: approximation of the matrix D.
%Based on paper: Sample-Optimal Low-Rank Approximation of Distance
%   Matrices. P. Indyk.
%Implementation based on work of Mathias Pede.
function Dh = SOLRADM(D, k, r)
    p = OpstellenKansverdeling(D);
    U = FMCLRA(D,p,k,r);
    V = regression(U,D,r);
    Dh = U*V;