%CALCULATESSET: Calculate the SSE for the given clustering for the complete tensor.
% Calculates the SSE for each third order slice. The SSE of each slice is
% normalized wrt. the norm of the slice.
%parameters:
%   Y: The distance tensor.
%   Clusters: the clusters.
%result:
%   SSE: the sum of the normalized SSE of all slices. 
function SSE = calculateSSET(Clusters,Y)
    sz = size(Y);
    am = prod(sz(3:end),'all');
    T = zeros(sz(1:2));
    for i=1:am
        D = Y(:,:,i);
        nrm = norm(D);
        T = T+D./nrm;
    end
    SSE = calculateSSE(Clusters,T);
end