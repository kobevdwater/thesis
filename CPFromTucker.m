function B = CPFromTucker(G,U)
    A = cpd(G,length(G));
    B = {};
    for i=1:length(A)
        B{1,i} = U{1,i}*A{1,i};
    end
end