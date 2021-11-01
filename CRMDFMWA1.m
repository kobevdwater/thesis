function Yh = CRMDFMWA1(Y,r)
    [i,j,k] = size(Y);
    [I,J,K] = adaptiveIndexChoise(Y,r)
    %I = randi(i,1,r);J=randi(j,1,r);K=randi(k,r,1,r);
    
    W = Y(I,J,K);
    C1 = Y(:,J,K);C2 = Y(I,:,K);C3 = Y(I,J,:);
    C1 = tens2mat(C1,1);
    C2 = tens2mat(C2,2);
    C3 = tens2mat(C3,3);
    W1 = tens2mat(W,1);W2 = tens2mat(W,2);W3 = tens2mat(W,3);
    Wn = {pinv(W1),pinv(W2),pinv(W3)};
    U = lmlragen(Wn,W);
    Cn = {C1,C2,C3};
    Yh = lmlragen(Cn,U);
end