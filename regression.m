%REGRESSION Use Active Regression via Linear-Sample Sparsification to find
%   a V that minimizes norm(D-U*V).
%parameters:
%   U: left factors of a decomposition of D.
%   D: matrix to be decomposed by V and U.
%   ep: parameter specifying how accurate the approximation has to be.
%       Lower values will result in a higher sampling-rate of D.
%returns:
%   V: matrix that approximates the solution of argmin(norm(D-V*U))
% based on paper: Active Regression via Linear-Sample Sparsification. Chen.
%Implementation based on work of Mathias Pede.
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
    while (u-l) < 8*k/gamma
        fie = trace((u.*eye(k)-B)^-1)+trace((B-l.*eye(k))^-1);
        temp1 = (u*eye(k)-B)^-1*Vx;
        temp2 = (B-l*eye(k))^-1*Vx;
        p = Vx'*sum(temp1,2)+Vx'*sum(temp2,2);
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
    end
    Y = D(indices,:);
    V = zeros(k,n);
    Us = U(indices,:);
    for i=1:n
        V(:,i) = Us\Y(:,i);
    end
    

end


