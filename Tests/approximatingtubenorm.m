%Testing if we can approximate the norm of the rows of the mode 3
%matricization based on the mode 1 and 2 norms. 
%Turns out it works fairly well. Does not capture extreme values.
initialize;
norm_Yn = Yn;
% for i=1:size(Yn,3)
%     norm_Yn(:,:,i) = Yn(:,:,i)./norm(Yn(:,:,i));
% end
M3 = tens2mat(norm_Yn,1);
realNorm = vecnorm(M3);
nrm = squeeze(vecnorm(Yn));
approx = OpstellenKansverdeling(Yn);

approx = approx(:)';
realNorm_normalized = realNorm./norm(realNorm);
approxNorm_normalized = approx./norm(approx);
plot(realNorm_normalized);
hold on; plot(approxNorm_normalized);
legend("real","approx");
relative_error = abs(approxNorm_normalized-realNorm_normalized)./realNorm_normalized;
figure; plot(relative_error);legend("relative error");