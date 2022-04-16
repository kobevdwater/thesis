%Testing different sampling on there ability to generate good clusters.
%Will report the SSE of each methods ifo the sampling rate. 
%Will report the precision an recall of the found clusters compaired with
%   expected clusters. 
%   If no expected clusters are known. No precision and recall will be
%   calculated. 
%parameters:
%   k: amount of clusters.
%   T: The tensor used to create the clusterings.
%   Td: Distance tensor used to measure SSE of clusterings.
%   Tp: The tensor used for Pmethods (clustering third mode).
%   methods: Methods to test using the tensor T (clustering first mode). 
%      See: getApproxClusters for available methods.                                       
%   methodsP: Methods to test using the tensor Tp (clustering third mode). 
%      See: getApproxClusters for available methods. 
%   options.retries: The total number each test will be executed. Result will be
%       mean over the retries.
%   options.sinterval: Samplerates to test. 
%   options.expected: The clustering to use to compute presicion and recall.
%       False if expected clusters are not known. 
%result:
%   Shows the total SSE over all slices from the cluster calculated using
%   the different methods in function of the samplerate. Will also report
%   the SSE of the expected clusters or of the clusters calculated on each
%   slice when no expected clusters are known.
%   Shows the precision and recall of the different methods in function of
%   the samplerate compaired to the expected clusters.
%   SSEmean: matrix containing the mean SSE for the different methods and
%       sampling rates.
function SSEmean = approxTest(k,T,Td,Tp,methods,options)
    arguments
        k; T; Td; Tp
        methods;
        options.retries {mustBeInteger,mustBeNonzero, mustBePositive} = 1
        options.sinterval = false
        options.expected = false
        options.Tm = false
        options.amount {mustBeInteger,mustBeNonzero, mustBePositive} = 10
        options.show = true
    end
    if options.sinterval
        sinterval = options.sinterval;
    else
        sinterval = logspace(-2.5,-1,options.amount);
    end
    SSEmean = SSEPrTest(k,T,Td,Tp,methods,@getApproxClusters,sinterval,'retries',options.retries,'Tm',options.Tm,'show',options.show,'expected',options.expected);
end

