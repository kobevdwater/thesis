function [precision,recall] = BCubed(found,expected)
    cl = {};
    for i=1:max(found)
        cl{i} = [];
    end
    for i=1:length(found)
        cl{found(i)} = [cl{found(i)} expected(i)];
    end
    [TotalAmount,~] = groupcounts(expected');
    recall = 0;
    precision = 0;

    for i=1:length(cl)
        [Amount,indices] = groupcounts(cl{i}');
        precision = precision + sum(Amount.*Amount./length(cl{i}));
        recall = recall+ sum(Amount.*Amount./TotalAmount(indices));
    end
end

