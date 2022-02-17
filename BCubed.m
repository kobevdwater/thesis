%BCUBED: Calculate the precission and recall based on the BCubed method.
%Expected that clusters have the same "base". The numbering of the clusters
%are the same.
%paramets:
%   found: The calculated clusters.
%   expected: The ground truth. The clusters you expect to find.
%result:
%   precission: Gives the "cleanness" of clusters. Higher precission means
%       clusters contain less wrong elements.
%   recall: gives closeness of classes. High recall means more elements are
%   in a cluster.
function [precission,recall] = BCubed(found,expected)
    cl = {};
    for i=1:max(found)
        cl{i} = [];
    end
    %making clusters based on found clusters.
    for i=1:length(found)
        cl{found(i)} = [cl{found(i)} expected(i)];
    end
    [TotalAmount,~] = groupcounts(expected');
    recall = 0;
    precission = 0;

    for i=1:length(cl)
        [Amount,indices] = groupcounts(cl{i}');
        precission = precission + sum(Amount.*Amount./length(cl{i}));
        recall = recall+ sum(Amount.*Amount./TotalAmount(indices));
    end
    precission = precission/length(found);
    recall = recall/length(found);
end

