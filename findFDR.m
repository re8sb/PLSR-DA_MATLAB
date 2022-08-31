function [pAdj, indAccepted] = findFDR(pValArr, m, alpha, varargin)

% [pAdj, indAccepted] = findFDR(pValArr, m, alpha, varargin)
% Given a pValue array, a number of tests, and a target alpha value, return
% the FDR adjusted p-value and the indexes in the pValArray that meet the
% criteria
% Kristen Naegle

cm = 1; %correlation of dependence for AFDR (Benjamini and Yuketilli)
if(nargin > 3)
cm = varargin{1};
end

pValSort = sort(pValArr);
pAdj = 0; %assuming there are no rejected hypotheses at all

for i =1:length(pValSort)
pi = pValSort(i);
j = i;
if(pi <= (j/(cm*m))*alpha)
pAdj = pi;
else
break; %whatever was set last will be value accepted
end
end
indAccepted = find(pValArr <= pAdj);
% i need to translate

end