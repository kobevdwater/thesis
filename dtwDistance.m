%DTWDISTANCE calculate the dtw- distance between 2 timeseries.
%parameters: 
%   a1,a2: timeseries
%returns:
%   dist: dtw-distance between a1 and a2
function dist = dtwDistance(a1,a2)
    n = max(size(a1)); m= max(size(a2));
    DTW = Inf*ones(n+1,m+1);
    DTW(1,1) = 0;

    for i = 1:n
        for j =1:m
            cost = (a1(i)-a2(j))^2;
            DTW(i+1,j+1) = cost + min([DTW(i,j+1),DTW(i+1,j),DTW(i,j)]);
        end
    end
    %sqrt to bring distances closer together. Can I do that?
    %- already not a distance, so i guess so.
    dist = sqrt(DTW(i+1,j+1));


end