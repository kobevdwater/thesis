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
    %sdf_check(model, 'print');
    sol = sdf_nls(model);

    
    A = sol.factors.A;
    B = sol.factors.B;
    C = sol.factors.C; 
