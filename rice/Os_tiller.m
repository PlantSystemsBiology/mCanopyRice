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

tillerID = paramMatrix(1,2); % 第2列是tillerID

leafOrSpikeID_v = paramMatrix(:,3); % ID，穗0， flag leaf 1， second leaf 2. etc
leafBH_v = paramMatrix(:,4);        % 叶基部高度
leafL_v = paramMatrix(:,5) * sqrt(S_adj_ratio);         % 叶片长度
leafmaximalW_v = paramMatrix(:,6) * sqrt(S_adj_ratio);  % 叶片最宽宽度
leafCA_v = paramMatrix(:,7);        % 叶片弯曲的的弧对应圆心角
leafA_v = paramMatrix(:,8);         % 叶片角度，叶基部与茎秆之间的角度

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
    
    [X, Y, Z] = convertColumn9to3 (M_data_leaf(:,6:14)); % 将9列的矩阵转换为3列的
    [theta,r,h] = cart2pol(X,Y,Z);                % Z 方向为轴, -转换为柱坐标系,
    theta = theta + beta;                         % 叶子沿着茎秆旋转到beta度到某一方向
    beta = beta + pi + randn*(pi*15/180);       % beta加上pi，为下一叶片的方向
    [X,Y,Z] = pol2cart(theta,r,h); %转换回笛卡尔坐标系
    
    M_data_leaf(:,6:14) = convertColumn3to9 ([X,Y,Z]); % 将3列的矩阵转换为9列的
    M_data = [M_data;M_data_leaf];
end
stemL = 0; %初始化

if leafBH_v(1)>leafBH_v(end)
    if sum(leafOrSpikeID_v==0)==1     % 如果有1个穗子
        stemL = leafBH_v(leafOrSpikeID_v == 0);
    elseif sum(leafOrSpikeID_v==0)==0 % 如果没有穗子
        stemL = leafBH_v(leafOrSpikeID_v == 1);
    elseif sum(leafOrSpikeID_v==1)==0 % 如果没有旗叶
        stemL = leafBH_v(leafOrSpikeID_v == 2);
    else  % 其它情况，选择第三叶基部高度为茎秆长度
        stemL = leafBH_v(leafOrSpikeID_v == 3);
    end
else
    stemL = leafBH_v(end);
end
[M_stem, radi0] = Os_stem (stemL); % 调用Os_stem来生成一个stem
M_data = [M_data;M_stem]; % 将stem的结构加入到分蘖数据中
M_data(:,2) = tillerID; % 2,分蘖编号

end


