function E = getresidual(Y,I,J,K,mode,index1,index2)
    [i,j,k] = size(Y);
    W = Y(I,J,K);
    C1 = Y(:,J,K);C2 = Y(I,:,K);C3 = Y(I,J,:);
    C1 = tens2mat(C1,1);
    C2 = tens2mat(C2,2);
    C3 = tens2mat(C3,3);
    W1 = pinv(tens2mat(W,1));W2 = pinv(tens2mat(W,2));W3 = pinv(tens2mat(W,3));
    if mode == 1
        U = {C1*W1,C2(index1,:)*W2,C3(index2,:)*W3};
        E = Y(:,index1,index2) - lmlragen(U,W);
    end
    if mode == 2
        U = {C1(index1,:)*W1,C2*W2,C3(index2,:)*W3};
        E = Y(index1,:,index2) - lmlragen(U,W);
    end
    if mode == 3
        U = {C1(index1,:)*W1,C2(index2,:)*W2,C3*W3};
        E = squeeze(Y(index1,index2,:))-squeeze(lmlragen(U,W));
    end

end