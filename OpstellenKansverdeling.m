%Calculate a probability distribution proportional to a approximation of
%   the column norm of a distance tensor.
%parameters:
%   D: a distance tensor. 
%returns:
%   p: probability distribution where each entry is proportional to the
%   relative norm of the corresponding fiber of D.
%   Each slice is taken to have the same norm.
% based on thesis Mathias Pede.
function p = OpstellenKansverdeling(D,options)
    arguments
        D
        options.am (1,1) {mustBeNumeric} = 10
        options.slice (1,1) {mustBeNumeric} = 0
    end
    [n,k,c] = size(D);
    if options.slice
        c=1;
    end
    am = options.am;
    p = zeros(n,c);
    for i=1:c
        I = randi(n,am,1);
        rows = D(:,I');
        norms = sum(rows.^2);
        [~,idx] = max(norms);
        is = I(idx);
        js = randi(k);
        rowMean = 1/n*sum(D(is,:,i).^2);
        pr = D(:,js,i).^2+D(is,js,i).^2+rowMean;
        p(:,i) = pr./(sum(pr)*c);
    end
end 