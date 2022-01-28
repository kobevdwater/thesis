%Testing if we can approximate the norm of the rows of the mode 3
%matricization based on the mode 1 and 2 norms. 
%Turns out it works fairly well. Does not capture extreme values.
% Noce for third mode venu.
M3 = tens2mat(Y,3);
realNorm = vecnorm(M3);
norm1 = sum(vecnorm(Y),3);
norm2 = sum(vecnorm(Y),3);
approx = zeros(1,size(M1,1)^2);
km = size(M3,1);
jm = size(M2,1);
im = size(M1,1);
approx = kron(norm1,norm2);
plot(realNorm./norm(realNorm));
hold on; plot(approx./norm(approx));
legend("real","approx")