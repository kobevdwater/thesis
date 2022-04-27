function SSEmean = SSEPrTest(ks,T,Td,Tp,methods,clusterFunction,evalPoints,options)
    arguments
        ks; T; Td; Tp
        methods;clusterFunction;evalPoints
        options.retries {mustBeInteger,mustBeNonzero, mustBePositive} = 1
        options.expected = false
        options.Tm = false
        options.amount {mustBeInteger,mustBeNonzero, mustBePositive} = 10
        options.show = true
        options.precompDecomp = false;
        options.tensorNames = false;
    end
    expected = options.expected;
    Tm = options.Tm;
    if length(ks) > 1 && options.expected
        error("you can not use multiple k's  and expected clusters at the same time.");
    end
    amTensors = 1;
    if iscell(T)
        amTensors = length(T);
        if ~isstring(options.tensorNames)
            options.tensorNames = append("T",string([1:amTensors]));
        end
    else
        T = {T};
    end


    SSEresult = zeros(length(ks),length(evalPoints),length(methods)*amTensors,options.retries);
    PRresult = zeros(2,length(evalPoints),length(methods)*amTensors,options.retries);
    decomp = {};
    decomp.Y = T;
    decomp.P = Tp;
    if sum(Tm,'all')
        SSEx = zeros(length(ks),length(evalPoints),2);
        Ex = ["Expected","FromMatrix"];
    else
        SSEx = zeros(length(ks),length(evalPoints),1);
        Ex = ["Expected"];
    end
    %Calculating methods that are not dependent on samplerate.
    if expected
        SSEx(:,:,1) = calculateSSET(expected,Td); 
    else
        Ex(1) = "Matrix";
        for k=1:length(ks)
            SSEx(k,:,1) = calcMatrixSSE(ks(k),Td);
        end

    end
    if sum(Tm,"all")
        for k=1:length(ks)
            Clusters = spectralClustering(Tm,ks(k),'isDist',true);
            SSEx(k,:,2) = calculateSSET(Clusters,Td); 
        end
    end


    f = waitbar(0,"SSEPrTest");
    for tens = 1:amTensors
        decomp.Y = T{1,tens};
        for si = 1:length(evalPoints)
            if options.precompDecomp
                decomp = preComputeDecomp(decomp,evalPoints(si));
            end
            for i=1:options.retries
                frac = sub2ind([options.retries,length(evalPoints),amTensors],i,si,tens)/(options.retries*length(evalPoints)*amTensors);
                waitbar(frac,f);
                for m=1:length(methods)
                    mt = sub2ind([length(methods),amTensors],m,tens);
                    for k=1:length(ks)
                        Clusters = clusterFunction(methods(m),evalPoints(si),decomp,ks(k));
                        if expected
                            [pr,rc] = BCubed(Clusters,expected);
                            PRresult(:,si,mt,i) = PRresult(:,si,mt,i)+ [pr;rc];
                        end
                        SSEresult(k,si,mt,i) = calculateSSET(Clusters,Td);
                    end
                end
            end
        end
    end

    SSEmean = sum(SSEresult,4)./options.retries;
    methodsT = methods;
    if amTensors>1
        methodsT = append(methods',options.tensorNames);
        methodsT = methodsT(:);
    end
    methodsT = methodsT(:);
    if options.show
        for k=1:length(ks)
            figure('Name','SSE');title('SSE');hold on;plot(evalPoints,squeeze(SSEmean(k,:,:)));
             plot(evalPoints,squeeze(SSEx(k,:,:)),'o');
            legend([methodsT',Ex]);
        end
        if expected
            PRmean = sum(PRresult,4)./options.retries;
            figure('Name','Precision');title('Precision');hold on; plot(evalPoints,squeeze(PRmean(1,:,:)));legend([methodsT']);
%             figure  ('Name','Recall'); title('Reccall');hold on; plot(evalPoints,squeeze(PRmean(2,:,:)));legend([methodsT]);
        end
    end
    close(f);
end




function SSE = calcMatrixSSE(k,T)
    sz = size(T);
    am = prod(sz(3:end),'all');
    SSE = 0;
    for j=1:am
        D= T(:,:,j);
        nrm = norm(D);
        MatrixClusters = spectralClustering(D,k,"isDist",true);
        SSE = SSE + calculateSSE(MatrixClusters,D)/nrm; 
    end
end


