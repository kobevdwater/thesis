%REGRESSION Use Active Regression via Linear-Sample Sparsification to find
%   a V that minimizes norm(D-U*V).
%parameters:
%   U: left factors of a decomposition of D.
%   D: matrix to be decomposed by V and U.
%   r: specifies amount of rows sampled.
%returns:
%   V: matrix that approximates the solution of argmin(norm(D-V*U))
% based on paper: Active Regression via Linear-Sample Sparsification. Chen.
%Implementation based on work of Mathias Pede.
function V = regression(U,D,r)
    ep = 2;
    [n,k] = size(U);
    p = ones(1,n)./n;
    V = orth(U');
    gamma = sqrt(ep)/3;mid = (4*n/gamma)/(1/(1-gamma)-1/(1+gamma));
    B=zeros(k,k);
    l=-2*k/gamma;u=2*k/gamma;
    weights = [];
    indices = [];
    Vx = V*U';
    for i=1:r
        fie = trace((u.*eye(k)-B)^-1)+trace((B-l.*eye(k))^-1);
        temp1 = (u*eye(k)-B)^-1*Vx;
        temp2 = (B-l*eye(k))^-1*Vx;
        p = Vx'*sum(temp1,2)+Vx'*sum(temp2,2);
        p=abs(p/sum(p)); %mistake??
        ri = datasample(1:n,1,'Weights',p);
        r = U(ri,:);
        s = gamma/p(ri);
        w = s/mid;
        if  ~ismember(ri, indices)
            weights = [weights w];
            indices = [ri indices];
        end
        vr= V*r';
        B = B+s*vr*vr';
        u = u+gamma/(fie*(1-gamma));l = l+gamma/(fie*(1+gamma));
    end
    sqrt_Weights = sqrt(weights);
    Y = D(indices,:).*sqrt_Weights';
    V = zeros(k,n);
    Us = U(indices,:).*sqrt_Weights';
    for i=1:n
        V(:,i) = Us\Y(:,i);
    end
end


