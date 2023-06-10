%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_leaf is used for building a 3D rice leaf model, as a module for build
% a rice tiller.
% Codeded by Qingfeng
% 2020-02-26, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% leafL is the leaf length.
% leafW.relativePosition and leafW.width are two vectors showing the leaf
% width at different relative positions along the leaf from 0 (at leaf base)
% to 1 (at leaf tip). vector length is not limited, recommand 4-7.
% leafA is the leaf angle,
% leafCA is leaf curvature angle. range: 0~pi

function M_data = Os_leaf(leafID, leafBH, leafL, maximalLeafWidth, leafA, leafCA)

global OS_LEAF_SEGMENT_LENGTH;
global OS_DATA_MATRIX_COLUMN_NUM;

% generate leafW.relativePosition and leafW.width from maximalLeafWidth and
% leafID
leafW = Os_leafWidth(maximalLeafWidth,leafID);

beta = 0; %初始值.叶片朝向角，植株旋转方向角的, 用于随机扰动部分。

k = 1; %构建叶子模型时候的三角形id，即叶子模型数据的行标，每行一个三角形

% ----------------------------分段三次Hermite差值---------------------
% 这里，采用差值来拟合叶片的轮廓，差值的输入为上述叶片在“基部，1/4,1/2,3/4,... 尖部”的实际宽度的一半。因为
% 以叶片主叶脉为横轴。
x = leafW.relativePosition .* leafL;  % 实际叶宽测量位置坐标, 差值拟合横坐标
y = leafW.width./2;                   % 实际叶宽除以2，即叶边沿距离主叶脉的距离，差值拟合纵坐标
t = 0:OS_LEAF_SEGMENT_LENGTH:leafL;  %差值点横坐标

if (leafL - t(end) > OS_LEAF_SEGMENT_LENGTH/10)  % 如果上面差值点t的最后一个值距离叶片尖端相距大于1/10的叶片分段长度，补齐叶尖这一点。
    t = [t,leafL];
end

p = pchip(x,y,t);   %差值计算，p为差值点纵坐标 （t为横坐标）

if(p(end)<0)  % 放置叶尖这一点的拟合结果出现很小的负值，更正为零。
    p(end) = 0;
end
% 差值结束，t为叶片长度方向的坐标，p为叶片宽度方向的坐标。（t,p)表示叶片的轮廓。
% ---------------------------/分段三次Hermite差值----------------%

metaAngle = leafCA/(length(t)-1);   %每段叶片对应的叶片弯曲弧圆心角, 即段叶片相对前一段叶片的转角。

baseX = 0;
baseZ = 0;

DataOfLeaf = zeros(1,9);                 %用于存储一片叶子的模型
positionOnLeaf = zeros(1,1);
for m = 1:length(t)-1   %每一段叶子，共为 差值点个数-1 段
    
    x1 = baseX;             %本段叶子起点坐标x
    z1 = baseZ;             %本段叶子起点坐标z
    nextX = baseX+(t(m+1)-t(m))*sin(metaAngle*(m-1));     %下一段叶子起点坐标x
    nextZ = baseZ+(t(m+1)-t(m))*cos(metaAngle*(m-1));     %下一段叶子起点坐标z
    
    x2 = nextX;             %下一段叶子起点坐标x 即为 本段叶子终点坐标x
    z2 = nextZ;             %下一段叶子起点坐标z 即为 本段叶子终点坐标z
    
    ylist = 0: OS_LEAF_SEGMENT_LENGTH :p(m);                   %叶片宽的方向为y坐标轴方向，半片叶子y的数值为0到本段叶子起点对应差指点纵坐标p(m)，间隔metaS
    
    if p(m) - ylist(end) > 0.1        %如果按照metaS等间距分割y方向，剩余零头大于0.1 cm
        ylist = [ylist,p(m)];         %则补加一个数值
    end
    
    ylist_2 = 0: OS_LEAF_SEGMENT_LENGTH :p(m+1);               %对于本段叶子终点位置叶宽方向的分割，与本段叶片起点叶宽分割相同
    
    if p(m+1) - ylist_2(end) > 0.1
        ylist_2 = [ylist_2,p(m+1)];
    end
    
    %------------------------------对一段叶子构建三角形-----------------
    length1 = length(ylist);
    length2 = length(ylist_2);
    
    for i = 1:min(length1,length2)-1          % 从主叶脉开始构建矩形区域
        DataOfLeaf(k,:) = [x1, ylist(i),  z1,   x2, ylist_2(i),z2,   x1, ylist(i+1),z1];
        positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH *(m-1) + OS_LEAF_SEGMENT_LENGTH * 1/3;
        %     positionOnLeaf(k,1)
        k = k+1;
        DataOfLeaf(k,:) = [x1, ylist(i+1),z1,   x2, ylist_2(i),z2,   x2, ylist_2(i+1),z2];
        positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH *(m-1) + OS_LEAF_SEGMENT_LENGTH * 2/3;
        k = k+1;
    end
    
    if(length1 > length2)                       % 构建剩余的三角形部分
        for i=length2:length1-1
            DataOfLeaf(k,:) = [x1, ylist(i),  z1,   x2, ylist_2(length2),z2,   x1, ylist(i+1),z1];
            positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH*(m-1) + OS_LEAF_SEGMENT_LENGTH * 1/3;
            k = k+1;
        end
        
    elseif(length1 < length2)                   % 构建剩余的三角形部分
        for i=length1:length2-1
            DataOfLeaf(k,:) = [x1, ylist(length1),  z1,   x2, ylist_2(i),z2,   x2, ylist_2(i+1),z2];
            positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH*(m-1) + OS_LEAF_SEGMENT_LENGTH * 2/3;
            k = k+1;
        end
    end
    
    %-----------------------------/对一段叶子构建三角形-----------------
    
    baseX = nextX;           %把本段起点位置更新为本段终点位置(下一个循环构建下一段叶片）
    baseZ = nextZ;
end   %/每一段叶子，共为 差值点个数-1 段

M = DataOfLeaf;

%-----------------构建完整叶片------------------
M2 = M;
M2(:,2) = -M2(:,2);                         %y坐标对称为负数
M2(:,5) = -M2(:,5);
M2(:,8) = -M2(:,8);
M = [M;M2];                                 %两半叶合起来为一整片叶子，主叶脉点重合
positionOnLeaf = [positionOnLeaf;positionOnLeaf];
[row2,col2]=size(M);

[X, Y, Z] = convertColumn9to3 (M); % 变换数据结构为3列

%---------------转换为柱坐标系, Y 方向为轴----------------------
[theta,r,h] = cart2pol(X,Z,Y);              % Y 方向为轴
theta = theta - leafA;                    %叶片旋转 叶角 角度

%---------------转换回笛卡尔坐标系---------------------------
[X,Z,Y] = pol2cart(theta,r,h);

Z = Z + leafBH;                          %叶片高度位置调整

M_data = zeros(row2,OS_DATA_MATRIX_COLUMN_NUM);
% M_data column 1-3 for IDs, column 5 is for supplementary ID.
M_data(:,3) = leafID; % 0穗子，1旗叶，2及以后是倒二及以下叶子，-1是茎秆
M_data(:,4) = positionOnLeaf./leafL;  % relative position along leaf, from 0 to 1. 

%---------------数据结构转换回9列---------------------------
M_data(:,6:14) = convertColumn3to9 ([X,Y,Z]);

M_data(:,15:17) = 0;

%% draw the leaf
%Draw3DModel(M_data,5);

%%
end


