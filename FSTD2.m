% FSTD2: Create a Tucker decomposition based on the FSTD algorithm.
%parameters:
%   Y: Tensor to decompose.
%   r1,r2: dimension of the decomposition in the first and second and thrid mode.
%result:
%   F: The core of the decomposition.
%   Cn: Factor matrices: Cn = {B,C}
%Besed on paper: Generalizing the column-row matrix decomposition to
%multi-way arrays by Caiafa and Cichocki.
function [F,Cn] = FSTD2(Y,r1,r2)
    switch nargin
        case 2
            r2 = r1;
    end
    [i,j,k] = size(Y);
    [I,J,K] = adaptiveIndexChoise(Y,r1,r2);
    F = Y(I,J,K);
    C1 = Y(:,J,K);
    C2 = Y(I,:,K); C3 = Y(I,J,:);
    C1 = tens2mat(C1,1);
    C2 = tens2mat(C2,2);
    C3 = tens2mat(C3,3);
    W1 = tens2mat(F,1);
    W2 = tens2mat(F,2);W3 = tens2mat(F,3);
    F = tmprod(F,pinv(W1),1);
    F = tmprod(F,pinv(W2),2);
    F = tmprod(F,pinv(W3),3);
%     C1 = C1*pinv(W1);
%     C2 = C2*pinv(W2);C3 = C3*pinv(W3);
    Cn = {C1,C2,C3};
end