
% used to map two vectors with different length
% when compare different tiller numbers and leaf numbers
function targetIndex = heteroMapping (queryNum, targetNum)
% targetIndex = heteroMapping (queryNum, targetNum)

queryList = (1/queryNum/2): (1/queryNum) : 1;  % generate the query quantiles

targetList = (1/targetNum/2) : (1/targetNum) : 1; % generate the target quantiles

targetIndex = zeros(queryNum,1); % output vector


for i = 1:queryNum
    diff_minimal = 1; % maximal initial
    for j = 1:targetNum
        diff = abs(queryList(i)-targetList(j));
        
        if diff<=diff_minimal
            diff_minimal = diff; % update the diff_minimal
            targetIndex(i) = j;
        end
    end
end


end


