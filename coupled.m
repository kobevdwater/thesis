%COUPLED create a coupled matrix decomposition of X and Y.
%parameters:
%   X: matrix of size [I,J]. Will be decomposed as X ~ A*B'
%   Y: matrix of size [I,K]. Will be decomposed as Y ~ A*C'
%   R: dimention of the decomposition
%returns: 
%   A: matrix of size [I,R]
%   B: matrix of size [J,R]
%   C: matrix of size [K,R]
function [A,B,C] = coupled(X,Y,R)
    model = struct;
    model.variables.b = randn(size(X,2),R);
    model.variables.a = randn(size(X,1),R);
    model.variables.c = randn(size(Y,2),R);
    model.factors.A = 'a';
    model.factors.B = 'b';
    model.factors.C = 'c';
    model.factorizations.matrix1.data = X;
    model.factorizations.matrix1.cpd  = {'A', 'B'};
    model.factorizations.matrix2.data = Y;
    model.factorizations.matrix2.cpd  = {'A', 'C'};
    sol = sdf_nls(model);

    
    A = sol.factors.A;
    B = sol.factors.B;
    C = sol.factors.C; 
