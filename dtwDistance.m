%DTWDISTANCE calculate the dtw-distance between 2 timeseries.
%parameters: 
%   a1,a2: timeseries
%   w: the size of the window.
%returns:
%   dist: dtw-distance between a1 and a2
function dist = dtwDistance(a1,a2,w,options)
    arguments
        a1
        a2
        w = false
        options.visualize {mustBeNumericOrLogical} = false
    end
    n = length(a1); m= length(a2);
    if ~w
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
            cost = absd(a1(i)-a2(j));
            DTW(i+1,j+1) = cost + min([DTW(i,j+1),DTW(i+1,j),DTW(i,j)]);
        end
    end
    dist = DTW(i+1,j+1);

    if options.visualize
        plot(a1);
        [~,I] = min(DTW);
        hold on;
        plot(I(1:end-1),a2);
        figure;imshow(DTW./(10*dist));
    
end