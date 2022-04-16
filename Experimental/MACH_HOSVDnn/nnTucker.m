function [U,G] = nnTucker(Y,size_core)
    U = {};
    Ut = {};
    for i=1:length(size_core)
        [A,~] = nnmf(tens2mat(Y,i),size_core(i));
        Ut{1,i} = A';
        U{1,i} = A;
    end
    G = lmlragen(Ut,Y);