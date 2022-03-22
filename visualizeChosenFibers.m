%Visualizing the chosen fibers.
%Used for testing purposes: 
% Problem with opstellenKansverdeling: fibers tend to be grouped together
% due to badly chosen entries and it also tends to focus on outliers.
initialize;
p = OpstellenKansverdeling(Yn);
M = tens2mat(Yn,1);
szM = size(M);
szY = size(Yn);
I = datasample(1:szM(2),1000,'Weights',p(:)','Replace',false);
Res = zeros(szY(2:3));
Res(I) = 1;
imshow(Res);
figure; plot(p(:));