function U = FMCLRA(D,p,k,eps)
    [n,~] = size(D);
    %s = round(10*k/eps);
    s = round(3*k/eps);
    I = datasample(1:n,s,'Weights',p,'Replace',false);
    S = D(:,I);
    scaling = s.*p(I);
    S = transpose(sqrt((1./scaling))).*S;
    [U,~,~] = svds(S,k);
end