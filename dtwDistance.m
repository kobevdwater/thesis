%DTWDISTANCE calculate the dtw-distance between 2 timeseries.
%parameters: 
%   a1,a2: timeseries
%   w: the size of the window.
%returns:
%   dist: dtw-distance between a1 and a2
function dist = dtwDistance(a1,a2,w)
    n = length(a1); m= length(a2);

    if nargin < 3
        w = max(n,m);
    end
    if n/m > w
        warning("length of series in incompatible. n: %d, m: %d ",n,m)
    end
    DTW = Inf*ones(n+1,m+1);
    DTW(1,1) = 0;


    for i = 1:n
        ir = floor(i*m/n);
        for j =max(1,ir-w):min(m,ir+w)
            cost = (a1(i)-a2(j))^2;
            DTW(i+1,j+1) = cost + min([DTW(i,j+1),DTW(i+1,j),DTW(i,j)]);
        end
    end
    dist = DTW(i+1,j+1);
    
end