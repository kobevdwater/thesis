%Visualizing the chosen fibers.
initialize;
p = OpstellenKansverdeling(Yn);
M = tens2mat(Yn,1);
sz = size(M);
I = datasample(1:sz(2),1000,'Weights',p(:)','Replace',false);
Res = zeros(sz);
Res(:,I) = 1;
imshow(Res);
figure; plot(p(:));