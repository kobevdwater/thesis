function [G,A1,A2,A3,sr] = MACH_HOSVD(X,r1,r2,r3,p)
    [I,J,K ] = size(X);
    R = (rand(I,J,K)<p);
    Xh = R.*X(:,:,:)./p;
    sr = sum(R,'All')/(I*J*K);
    [A1,~,~] = svds(tens2mat(Xh,1),r1);
    [A2,~,~] = svds(tens2mat(Xh,2),r2);
    [A3,~,~] = svds(tens2mat(Xh,3),r3);
    U = {A1',A2',A3'};
    G = lmlragen(U,Xh);
end
