%Just some tests to handle stock data

s1 = 10;
s2  = 50;
AllStocks = dir('./stocks/archive/stock_market_data/sp500/csv/');
AllStocks = {AllStocks.name};
AllStocks = AllStocks(3:end);
st1 = append('./stocks/archive/stock_market_data/sp500/csv/',AllStocks{1,s1});
D1 = readtable(st1);
D1 = D1{:,2:end};
plot(D1(:,[1,2,4,5]));
minl = inf;
mins = "";
for i=1:length(AllStocks)
    st = append('./stocks/archive/stock_market_data/sp500/csv/',AllStocks{1,i});
    D = readtable(st);
    sz = size(D,1)
    if sz < minl
        minl = sz;
        mins = AllStocks{1,i};
    end
end

