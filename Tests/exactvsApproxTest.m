function SSEmean = exactvsApproxTest(k,T,Td,Tp,exactMethod,methods,options)
    arguments
        k; T; Td; Tp
        exactMethod; methods;
        options.retries {mustBeInteger,mustBeNonzero, mustBePositive} = 1
        options.sinterval = false
        options.Tm = false
        options.amount {mustBeInteger,mustBeNonzero, mustBePositive} = 10
        options.show = true
    end
    if options.sinterval
        sinterval = options.sinterval;
    else
        sinterval = logspace(-2.5,-1,options.amount);
    end
    decomp.Y = T;
    decomp = preComputeDecomp(decomp,4);
    expected = getExactClusters(exactMethod,k,decomp,k);
    SSEmean = SSEPrTest(k,T,Td,Tp,methods,@getApproxClusters,sinterval,'retries',options.retries,'Tm',options.Tm,'show',options.show,'expected',expected);
end
