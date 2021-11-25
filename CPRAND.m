function [lambda,A] = CPRAND(X,r,s,isDistance)
    sz = size(X);
    A1 = rand(sz(1),r);A2=rand(sz(2),r);A3=rand(sz(3),r);
    A = {A1,A2,A3};
    I = [randi(sz(1),50,1) randi(sz(2),50,1) randi(sz(3),50,1)];
    best = inf;
    bestIteration = 0;
    if nargin < 4
        isDistance = false;
    end
    if isDistance
        p = OpstellenKansverdeling(X);
    end
    for i=1:4*r
        for n=1:3
            k = min(mod(n,3),mod(n+1,3))+1;
            l = max(mod(n,3),mod(n+1,3))+1;
            if isDistance && n~=3
                J = datasample(1:sz(k)*sz(l),s,'Weights',p(:))';
            else
                J = randi([1,sz(k)*sz(l)],s,1);
            end
            S = [floor((J-1)/sz(l))+1 mod(J-1,sz(l))+1];
            Zs = SKR(S,{A{1,k},A{1,l}});
            Xst = tens2mat(X,n,[l,k]);
            Xst = Xst(:,J)';
            A{1,n} = (Zs\Xst)';
            lambda = vecnorm(A{1,n});
            A{1,n} = A{1,n}./lambda;
        end
        A1=A{1,1};A2=A{1,2};A3=A{1,3};
        Xhi = sum(A1(I(:,1),:).*A2(I(:,2),:).*A3(I(:,3),:).*lambda,2);
        idx = sub2ind(size(X), I(:,1), I(:,2),I(:,3));
        Xh = X(idx);
        e = norm(Xh-Xhi)/norm(Xh);
        if (e > best)
            if (i-bestIteration >= 4)
                break;
            end
        else
            best = e;
            bestIteration = i;
        end
    end
    i
end