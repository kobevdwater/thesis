%Calculate a probability distribution proportional to a approximation of
%   the column norm of a distance tensor.
%parameters:
%   D: a distance tensor. 
%returns:
%   p: probability distribution where each entry is proportional to the
%   relative norm of the corresponding fiber of D.
% based on thesis Mathias Pede.
function p = OpstellenKansverdeling(D,options)
    arguments
        D
        options.am (1,1) {mustBeNumeric} = 10
        options.slice (1,1) {mustBeNumeric} = 0
    end
    sz = size(D);
    slicesz = sz(1:2);
    n = sz(1);
    k = sz(2);
    othersz = sz(3:end);
    if length(sz) == 2
        othersz=[1];
    end
    am = options.am;
    p = zeros([slicesz(1),othersz]);
    c = prod(othersz,"all");
    for i=1:c
        Di = D(:,:,i);
        I = randi(n,am,1);
        rows = Di(:,I');
        norms = sum(rows.^2);
        [~,idx] = min(norms);
        is = I(idx);
        js = randi(k);
        rowMean = 1/k*sum(Di(is,:).^2);
        p(:,i) = Di(:,js).^2+Di(is,js).^2+rowMean;
%         p(:,i) = pr./(sum(pr)*c);
    end
    p = p./sum(p,"all");
end 