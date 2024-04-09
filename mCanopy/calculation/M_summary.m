
%% the function for summarizing tiller number and leaf area per plant based on a given canopy architectural parameter file. 

function [tillerNum,tillerNum_avg,leafareaPerPlant,leafareaPerPlant_avg] = M_summary(xlsfilename)

d = xlsread(strcat('M\',xlsfilename), 1); %only data body

tillerNum = zeros(1,9);
leafareaPerPlant=zeros(1,9);
leafareaPerPlant_avg = 0;
leafS = d(:,5) .* d(:,6) * 0.7;
for i=1:9

    tillerNum(1,i) = max(d(d(:,1)==i,2));
    leafareaPerPlant(1,i) = sum( leafS(d(:,1)==i,:) );

end

tillerNum_avg = mean(tillerNum);
leafareaPerPlant_avg = mean(leafareaPerPlant);


end


