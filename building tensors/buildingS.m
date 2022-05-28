%Create climate tensor compairing the temerature in cities in a specified
%   time interval.
%parameters:
%   options.start: start year of the data used.
%   options.end: last year of the data used.
%   options.allCities: 
%       false: only use 100 biggerst cities.
%       true: use all 3448 cities.
%result:
%   S: tensor compairing cities. S(i,j,k): difference between city i and j
%       in year k.
%   Sp: tensor compairing years. Sp(i,j,k): difference between year i and j
%       in city k.
%   Sm: matrix in which all years are taken together. Sm(i,j): difference
%       between cities i and j from the start till the end date.
%Data from: Climate Change: Earth Surface Temperature Data
% https://redivis.com/datasets/1e0a-f4931vvyg?v=1.0
function [S,Sp,Sm] = buildingS(options)
    arguments
        options.start = 1900
        options.theend = 2000
        options.allCities {mustBeNumericOrLogical} = false
    end
start = options.start;
theend = options.theend;
opts = detectImportOptions('./datasets/weather/archive/GlobalLandTemperaturesByMajorCity.csv');
opts = setvartype(opts,{'City'},'categorical');
if options.allCities
    G = readtable('./datasets/Weather/archive/GlobalLandTemperaturesByCity.csv',opts);
else
    G = readtable('./datasets/Weather/archive/GlobalLandTemperaturesByMajorCity.csv',opts);
end

I = find(year(G{:,1}) >= start);
G = G(I,:);
I = find(year(G{:,1}) <= theend);
G = G(I,:);
Cit = unique(G{:,4});
sz = [length(Cit),length(Cit),theend-start];
S = zeros(sz);
Series = {};
Seriesl = {};
%Get the needed timeseries from the dataset.
for i=1:length(Cit)
    I1 = find(G{:,4} == Cit(i));
    Gi = G(I1,:);
    al = Gi{:,'AverageTemperature'};
    Seriesl{i} = al;
    for k=1:theend-start
        yr = start+k;
        I2 = find(year(Gi{:,1}) == yr);
        a = Gi{I2,'AverageTemperature'};
        Series{i,k} = a;
    end
end
%building S
for k=1:theend-start
    for i=1:length(Cit)
        a1 = Series{i,k};
        for j=1:length(Cit)
            a2 = Series{j,k};
            %Skiping cities with the same name by taking first found year.
            S(i,j,k) = norm(a1(1:12)-a2(1:12));
        end
    end
end

%building Sp
tm = theend-start;
sz = [tm,tm,length(Cit)];
Sp = zeros(sz);
for i=1:tm
    for j=1:tm
        for k=1:length(Cit)
            a1 = Series{k,i};
            a2 = Series{k,j};
            %Skiping cities with the same name by taking first found year.
            Sp(i,j,k) = norm(a1(1:12)-a2(1:12));%./max(norm(a1(1:12)),norm(a2(1:12)));
        end
    end
end
sz = [length(Cit),12,tm];
St = zeros(sz);
for i=1:length(Cit)
    for j=1:tm
        a1 = Series{i,j};
        St(i,:,j) = a1(1:12);
    end
end

%building Sm
sz = [length(Cit)];
Sm = zeros(sz);
for i=1:length(Cit)
    a1 = Seriesl{i};
    for j=1:length(Cit)
        a2=Seriesl{j};
        Sm(i,j) = norm(a1-a2);
    end
end


