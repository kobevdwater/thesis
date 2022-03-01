
%DTWDISTANCE calculate the dtw- distance between 2 timeseries.
%parameters: 
%   a1,a2: timeseries
%returns:
%   dist: dtw-distance between a1 and a2
function dist = dtwDistance(a1,a2,w)
    n = length(a1); m= length(a2);
    if nargin < 3
        w = max(n,m);
    end
    %w = max(w,abs(n-m));
    DTW = Inf*ones(n+1,m+1);
    DTW(1,1) = 0;


    for i = 1:n
        for j =max(1,i-w):min(m,i+w)
            cost = (a1(i)-a2(j))^2;
            DTW(i+1,j+1) = cost + min([DTW(i,j+1),DTW(i+1,j),DTW(i,j)]);
        end
    end
    dist = DTW(i+1,j+1);
end