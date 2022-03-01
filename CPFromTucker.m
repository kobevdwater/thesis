%CPFROMTUCKER: Create a CP decomposiion based on a Tucker decomposition.
%parameters:
%   G: Core of the Tucker decomposition.
%   U: factor matrices of the decomposition. Given in a 1xn struct.
%result:
%   B: factor matrices of the CP decomposition. Given in a 1xn stuct.
function B = CPFromTucker(G,U)
    A = cpd(G,length(G));
    B = {};
    for i=1:length(A)
        B{1,i} = U{1,i}*A{1,i};
    end
end