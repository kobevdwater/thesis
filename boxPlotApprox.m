function boxPlotApprox(T, method, sinterval,tries,k)
    result = zeros(tries,length(sinterval));
    f = waitbar(0,'boxPlotApprox');
    for i=1:tries
        for j=1:length(sinterval)
        Clusters = getApproxClusters(method,sinterval(j),T,k);
        result(i,j) = calculateSSET(T,Clusters);
        end
        waitbar(i/tries,f);
    end
    close(f);
    figure;boxplot(result,sinterval);
end