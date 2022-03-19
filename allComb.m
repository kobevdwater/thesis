%ALLCOMB: make all possible combinations between different array chosing
%one element from each array.
%parameters:
%   elements: set of arrays.
%result:
%   result: a matrix where each row contains a possible ordered combination 
%       when we take one element from each array.
%function taken from: https://nl.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
function result = allComb(elements)
 combinations = cell(1, numel(elements)); %set up the varargout result
 [combinations{:}] = ndgrid(elements{:});
 combinations = cellfun(@(x) x(:), combinations,'uniformoutput',false); %there may be a better way to do this
 result = [combinations{:}]; % NumberOfCombinations by N matrix. Each row is unique.
end