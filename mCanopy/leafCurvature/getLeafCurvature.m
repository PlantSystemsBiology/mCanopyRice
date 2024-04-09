
%% the function for calculating leaf curvature angle

% this function read the xls plant architecture parameter file
% and output to another xls file with leaf curvature angle in the parameter
% file.
% eg. getLeafCurvature('riceStructureParameter-F1.xlsx')
% output: 'M_riceStructureParameter-F1.xlsx'

function getLeafCurvature(xlsfilename)

d = xlsread(strcat('..\M\',xlsfilename), 1); %only data body

leaf_R = d(:,10);
leaf_H = d(:,9);

leafLength = d(:,5);
distanceFromBaseToTip = sqrt(leaf_R.^2 + leaf_H.^2);

hu_Xian_ratio_list = leafLength./distanceFromBaseToTip;

leafCA = searchAngle(hu_Xian_ratio_list);

d(:,7) = leafCA; %
outputfilename = strcat('..\M\M_',xlsfilename);
d_output = d(:,1:8); % remove the leaf tip height and leaf tip R. 

xlswrite(outputfilename, d_output);

end

function leafCAlist = searchAngle(hu_Xian_ratio_list)

theta = 0.01:0.01:pi; %stepwise 0.01

xian = 1*sin(theta/2)*2;
hu = theta*1;
hu_Xian_ratio = hu./xian;


[row2,col2] = size(hu_Xian_ratio_list);
leafCAlist = zeros(row2,1);

for n = 1:row2
    hu_Xian_ratio_input = hu_Xian_ratio_list(n);
    
    if hu_Xian_ratio_input <= 1
        x = 0; % the minimal leaf curvature is 0, which is a straight leaf
        leafCAlist(n) = x; 
    elseif hu_Xian_ratio_input >= hu_Xian_ratio(end)
        x = theta(end); % the maximal leaf curvature is pi/2
        leafCAlist(n) = x;     
    else
        [row,col] = size(hu_Xian_ratio);
        for i=1:col-1
            if hu_Xian_ratio_input >= hu_Xian_ratio(i) && hu_Xian_ratio_input < hu_Xian_ratio(i+1)
                y2 = hu_Xian_ratio(i+1);
                y1 = hu_Xian_ratio(i);
                x2 = theta(i+1);
                x1 = theta(i);
                y = hu_Xian_ratio_input;
                x = (y-y1)*(x2-x1)/(y2-y1) + x1;  % the x is searched leaf curvature angle
                leafCAlist(n) = x;
                break;
            end
        end
    end
    
end

end


