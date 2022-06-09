%CALCULATESSE: calculate SSE of a clustering.
%parameters: 
%   clustering: clusters of objects. 
%   D: the distance matrix on which the SSE has to be calculated.
%returns: 
%   sse: The sse of the clustering.
function sse = calculateSSE(clustering,D)
    sse = 0;
    k = max(clustering);
    for i=1:k
        elems = clustering(:) == i;
        sim = elems*elems';
        sse = sse + sum(sim.*D,"all"); 
    end
    sse = sse/2;
end