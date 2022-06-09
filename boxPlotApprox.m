%BOXPLOTAPPROX: create a boxplot for the results of the approx clustering
%methods. 
%parameters:
%   T: the dinstancetensor to cluster
%   method: the approx-clustering method to test.
%   sinterval: the sampling rates to test.
%   tries: amount of repetitions
%   k: amount of clusters
%result
%   boxplot for each element in sinterval that gives the variation of the
%   result of the SSE of the method on T. Each samplerate will be repeated
%   tries times.
function boxPlotApprox(T, method, sinterval,tries,k)
    result = zeros(tries,length(sinterval));
    f = waitbar(0,'boxPlotApprox');
    for i=1:tries
        for j=1:length(sinterval)
        Clusters = getApproxClusters(method,sinterval(j),T,k);
        result(i,j) = calculateSSET(Clusters,T);
        end
        waitbar(i/tries,f);
    end
    close(f);
    figure;boxplot(result,sinterval);
end