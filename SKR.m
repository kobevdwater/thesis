function Zs = SKR(S,A)
    [s,~] = size(S);
    [~,r ] = size(A{1,1});
    [~,N ] = size(A);
    Zs = ones(s,r);
    for m=1:N
        Asm = A{1,m}(S(:,m),:);
        Zs = Zs.*Asm;
    end
end