function SSEmean = ExactTest(k,T,Td,Tp,Methods,options)
    arguments
        k; T; Td; Tp
        Methods;
        options.retries {mustBeInteger,mustBeNonzero, mustBePositive} = 1
        options.Rrange = false
        options.expected = false
        options.Tm = false
        options.show = true
    end
    if options.Rrange
        Rrange = options.Rrange;
    else
        Rrange = 2:10;
    end
    SSEmean = SSEPrTest(k,T,Td,Tp,Methods,@getExactClusters,Rrange,'retries',options.retries,'Tm',options.Tm,'show',options.show,'expected',options.expected,'precompDecomp',true);

end