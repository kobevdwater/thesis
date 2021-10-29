function V = regression(U,D,ep)
    [n,k] = size(U);
    p = ones(1,n)./n;
    V = orth(U');
    gamma = sqrt(ep)/3;mid = (4*n/gamma)/(1/(1-gamma)-1/(1+gamma));
    B=zeros(k,k);
    l=-2*k/gamma;u=2*k/gamma;
    weights = [];
    indices = [];
    Vx = V*U';
    j=0;
    while (u-l) < 8*k/gamma
        fie = trace((u.*eye(k)-B)^-1)+trace((B-l.*eye(k))^-1);
        temp1 = (u*eye(k)-B)^-1*Vx;
        temp2 = (B-l*eye(k))^-1*Vx;
        p = max(Vx'*sum(temp1,2)+Vx'*sum(temp2,2),0);%Problem: negative p.
        p=p/sum(p);
        ri = datasample(1:n,1,'Weights',p);
        r = U(ri,:);
        s = gamma/p(ri);
        w = s/mid;
        weights = [weights w];
        indices = [ri indices];
        vr= V*r';
        B = B+s*vr*vr';
        u = u+gamma/(fie*(1-gamma));l = l+gamma/(fie*(1+gamma));
        j=j+1
    end
    Y = D(indices,:);
    V = zeros(k,n);
    Us = U(indices,:);
    for i=1:n
        V(:,i) = Us\Y(:,i);
    end
    

end


