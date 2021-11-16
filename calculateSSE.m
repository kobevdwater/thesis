function sse = calculateSSE(clustering,D)

    results = zeros(1,length(clustering));
    for i=1:length(clustering)
        for j = (i+1):length(clustering)
            if (clustering(i) == clustering(j))
                results(i) = results(i) + D(i,j);
            end
        end
    end
    sse = sum(results);


end