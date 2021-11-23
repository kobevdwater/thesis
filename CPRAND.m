function [lambda,A] = CPRAND(X,r,s)
    sz = size(X);
    A1 = rand(sz(1),r);A2=rand(sz(2),r);A3=rand(sz(3),r);
    A = {A1,A2,A3};
    for i=1:10
        for n=1:3
            k = min(mod(n,3),mod(n+1,3))+1;
            l = max(mod(n,3),mod(n+1,3))+1;
            J = randi([1,sz(k)*sz(l)],s,1);
            %S = [mod(J-1,sz(k))+1 floor((J)/sz(l))+1]
            S = [floor((J-1)/sz(k))+1 mod(J-1,sz(l))+1];
            Zs = SKR(S,{A{1,k},A{1,l}});
            Xst = tens2mat(X,n,[l,k]);
            Xst = Xst(:,J)';
            A{1,n} = (Zs\Xst)';
            lambda = vecnorm(A{1,n});
            A{1,n} = A{1,n}./lambda;
            
        end
    end
end