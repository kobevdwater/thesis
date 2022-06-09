%SKR: I have no clue what this function is used for. 
function Zs = SKR(S,A)
    warning("The function SKR is run. Find out where and see why it is used.")
    [s,~] = size(S);
    [~,r ] = size(A{1,1});
    [~,N ] = size(A);
    Zs = ones(s,r);
    for m=1:N
        Asm = A{1,m}(S(:,m),:);
        Zs = Zs.*Asm;
    end
end