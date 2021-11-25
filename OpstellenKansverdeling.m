%Calculate a probability distribution proportional to a approximation of
%   the column norm of a distance matrix.
%parameters:
%   D: a distance matrix. 
%returns:
%   p: probability distribution where each entry is proportional to the
%   relative norm of the corresponding column of D.
% based on thesis Mathias Pede.
function p = OpstellenKansverdeling(D)
    
    [n,~,c] = size(D);
    p = zeros(n,c);
    for i=1:c
        is = randi(n);
        %[minS,is] = min(sum(D(:,:),2).^2);
        rowMean = 1/n*sum(D(is,:,i).^2);
        %rowMean = 1/n*minS;
        pr = D(:,is,i).^2+rowMean;
        p(:,i) = pr./(sum(pr)*c);
    end
end