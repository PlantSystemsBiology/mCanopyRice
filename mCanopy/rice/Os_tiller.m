%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_tiller is used for building a 3D rice tiller model, as a module for build
% a rice plant.
% Codeded by Qingfeng
% 2020-03-03, Shanghai
% 2020-03-18, modified.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M_data, radi0] = Os_tiller(paramMatrix)

global OS_DATA_MATRIX_COLUMN_NUM;
global S_adj_ratio;
beta = 0; % leaf orientation angle, initial value.

M_data = zeros(0,OS_DATA_MATRIX_COLUMN_NUM);

tillerID = paramMatrix(1,2); % µÚ2ÁÐÊÇtillerID

leafOrSpikeID_v = paramMatrix(:,3); % 0 for panicles£¬1 for flag leaf£¬2 and etc for other leaves, -1 for stem
leafBH_v = paramMatrix(:,4);        % leaf base height
leafL_v = paramMatrix(:,5) * sqrt(S_adj_ratio);         % leaf length
leafmaximalW_v = paramMatrix(:,6) * sqrt(S_adj_ratio);  % leaf width (max.)
leafCA_v = paramMatrix(:,7);        % leaf curvature angle
leafA_v = paramMatrix(:,8);         % leaf angle

leafNum = max(leafOrSpikeID_v);

for n = 1: leafNum
    %n
    leafBH = leafBH_v(n);
    leafL = leafL_v(n);
    leafmaximalW = leafmaximalW_v(n);
    leafA = leafA_v(n);
    leafCA = leafCA_v(n);
    leafID = n;
    % call Os_leaf function.
    M_data_leaf = Os_leaf(leafID, leafBH, leafL, leafmaximalW, leafA, leafCA);
    
    [X, Y, Z] = convertColumn9to3 (M_data_leaf(:,6:14)); % 
    [theta,r,h] = cart2pol(X,Y,Z);                % 
    theta = theta + beta;                         % 
    beta = beta + pi + randn*(pi*15/180);       % 
    [X,Y,Z] = pol2cart(theta,r,h); %
    
    M_data_leaf(:,6:14) = convertColumn3to9 ([X,Y,Z]); % 
    M_data = [M_data;M_data_leaf];
end
stemL = 0; %

if leafBH_v(1)>leafBH_v(end)
    if sum(leafOrSpikeID_v==0)==1     % 
        stemL = leafBH_v(leafOrSpikeID_v == 0);
    elseif sum(leafOrSpikeID_v==0)==0 % 
        stemL = leafBH_v(leafOrSpikeID_v == 1);
    elseif sum(leafOrSpikeID_v==1)==0 % 
        stemL = leafBH_v(leafOrSpikeID_v == 2);
    else  % 
        stemL = leafBH_v(leafOrSpikeID_v == 3);
    end
else
    stemL = leafBH_v(end);
end
[M_stem, radi0] = Os_stem (stemL); % 
M_data = [M_data;M_stem]; % 
M_data(:,2) = tillerID; % 

end


