%Create climate tensor
start = 1900;
theend = 2000;
opts = detectImportOptions('./weather/archive/GlobalLandTemperaturesByMajorCity.csv');
opts = setvartype(opts,{'City'},'categorical');
G = readtable('./weather/archive/GlobalLandTemperaturesByMajorCity.csv',opts);
I = find(year(G{:,1}) >= start);
G = G(I,:);
I = find(year(G{:,1}) <= theend);
G = G(I,:);
Cit = unique(G{:,4});
sz = [length(Cit),length(Cit),theend-start];
S = zeros(sz);
Series = {};
Seriesl = {};
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
for k=1:theend-start
    yr = start+k;
    for i=1:length(Cit)
        i
        a1 = Series{i,k};
        for j=1:length(Cit)
            a2 = Series{j,k};
            %Skiping cities with the same name by taking first found year.
            S(i,j,k) = norm(a1(1:12)-a2(1:12))./max(norm(a1(1:12)),norm(a2(1:12)));
        end
    end
end

tm = theend-start;
sz = [tm,tm,length(Cit)];
Sp = zeros(sz);
for i=1:tm
    i
    for j=1:tm
        for k=1:length(Cit)
            a1 = Series{k,i};
            a2 = Series{k,j};
            %Skiping cities with the same name by taking first found year.
            Sp(i,j,k) = norm(a1(1:12)-a2(1:12))./max(norm(a1(1:12)),norm(a2(1:12)));
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

sz = [length(Cit)];
Sm = zeros(sz);
for i=1:length(Cit)
    a1 = Seriesl{i};
    for j=1:length(Cit)
        a2=Seriesl{j};
        Sm(i,j) = norm(a1-a2);
    end
end


