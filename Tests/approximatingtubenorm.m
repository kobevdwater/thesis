%Testing if we can approximate the norm of the rows of the mode 3
%matricization based on the mode 1 and 2 norms. 
%Turns out it works fairly well. Does not capture extreme values.
initialize;
M3 = tens2mat(Yn,3);
realNorm = vecnorm(M3);
norm1 = sum(vecnorm(Yn),3);
norm2 = sum(vecnorm(Yn),3);
nrm = squeeze(vecnorm(Yn));
approx2 = kron(nrm,nrm);
approx2 = sum(approx2,2);
% approx = kron(norm1,norm2);
approx = OpstellenKansverdeling(Yn);
approx = approx(:);
plot(realNorm./norm(realNorm));
hold on; plot(approx./norm(approx));
plot(approx2./norm(approx2));
legend("real","approx","approx2");