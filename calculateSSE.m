%CALCULATESSE: calculate SSE of a clustering.
%parameters: 
%   clustering: clusters of objects. 
%   D: the distance matrix on which the sse has to be calculated.
%returns: 
%   sse: The sse of the clustering.
function sse = calculateSSE(clustering,D)
    
    results = zeros(1,length(clustering));
    for i=1:length(clustering)
        for j = (i+1):length(clustering)
            if (clustering(i) == clustering(j))
                results(i) = results(i) + D(i,j)^2;
            end
        end
    end
    sse = sum(results);
end