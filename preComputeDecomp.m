% Precompute the Tucker and CP decomposition of the Y and P tensors.
%parameters:
%       decomp: structure containing Y and P tensors.
%       R: rank of de decompositions.
%returs: 
%       decomp: structure containing Y and P tensors and theire decompositions. 
function decomp = preComputeDecomp(decomp,R)
        sz = size(decomp.Y);
        rank = ones(size(sz)).*R;
        rank = min(rank,sz);
        [U,G] = mlsvd(decomp.Y,rank);
        if isfield(decomp,'P')
            [Up,Gp] = mlsvd(decomp.P,rank);
            decomp.Gp = Gp;
            decomp.Up = Up;
        end
        decomp.U = U;
        decomp.G = G;

        C = cpd(decomp.Y,R);
        decomp.C = C;
end