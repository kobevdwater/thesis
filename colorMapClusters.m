%COLORMAPCLUSTERS: Color the different cities based on a clustering. Cities
%in the same cluster will have the same color.
%parameters:
%   Clusters: a clustering of the cities.
%   options.allCities: Should be true if the clustering contains all cities
%       and false if it only contains the major cities.
function colorMapClusters(Clusters,options)
    arguments
        Clusters
        options.allCities {mustBeNumericOrLogical} = false
    end
    lnspecs = ["r+","g+",'b+','c+','m+','y+',"r*","g*",'b*','c*','m*','y*'];
    opts = detectImportOptions('./weather/archive/GlobalLandTemperaturesByMajorCity.csv');
    opts = setvartype(opts,{'City'},'categorical');
    if options.allCities
        G = readtable('./weather/archive/GlobalLandTemperaturesByCity.csv',opts);
    else
        G = readtable('./weather/archive/GlobalLandTemperaturesByMajorCity.csv',opts);
    end
    I = find(year(G{:,1}) == 1999);
    G = G(I,:);

    Img = imread('./weather/world.jpg');
    Cit = unique(G{:,4});
    imshow(Img);
    sz = size(Img);
    np = sz(1:2)./2;
    ppdv = sz(1)/180;
    ppdh = sz(2)/360;
    hold on;
    
    for c = 1:length(Cit)
        index = find(G{:,4}==Cit(c),1,'first');
        lat = G{index,6};
        lat = lat{1,1};
        long = G{index,7};
        long = long{1,1};
        south = 1; east = 1;
        if lat(end) == 'N'
            south = -1;
        end
        if long(end) == 'W'
            east = -1;
        end 
        co = [south*str2double(lat(1:end-1)),east*str2double(long(1:end-1))];
        offset = co.*[ppdv,ppdh];
        pix=np+offset;
        plot(pix(2),pix(1), lnspecs(Clusters(c)), 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off;