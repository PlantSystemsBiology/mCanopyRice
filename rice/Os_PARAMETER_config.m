%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSTANT_config is used for setting the CONSTANT as global variables for
% building the model
% Codeded by Qingfeng
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Os_PARAMETER_config(stage)

% 模型矩阵的列数
global OS_DATA_MATRIX_COLUMN_NUM;
OS_DATA_MATRIX_COLUMN_NUM = 17;

% 叶片面元尺寸参数 used in function M_data = Os_leaf(leafID, leafBH, leafL, maximalLeafWidth, leafA, leafCA)
global OS_LEAF_SEGMENT_LENGTH; 
OS_LEAF_SEGMENT_LENGTH = 2; %三角形尺寸，cm，直角三角形直角边长度，这个是输入参数，用户可调节

% 单叶形状参数 used in function leafWidth = Os_leafWidth(maximalLeafWidth,leafID)
global IDX_LEAF_POSITION;
global IDX_FLAG_LEAF_WIDTH; 
global IDX_OTHER_LEAF_WIDTH;
IDX_LEAF_POSITION    = [0, 1/4, 1/2, 3/4, 1];
IDX_FLAG_LEAF_WIDTH  = [0.209 1     0.965 0.651 0]; % 常数.表示叶片的基部，1/4,1/2,3/4,尖部，的宽度/2. （flag 旗叶与其他不同，单独列出）
IDX_OTHER_LEAF_WIDTH = [0.214 0.738 1     0.881 0]; % leaf shape parameters from Watanabe, T. et al. Annals of botany 95, 1131–43 (2005).  常数。表示叶片的基部，1/4,1/2,3/4,尖部，的相对宽度. （其他叶片，形状一样）

% 单株参数 used in function Os_plant (plantID, paramMatrix)
global DIRECTION_ORIENTATION;
global TILLER_ANGLE;
DIRECTION_ORIENTATION = [pi/6, 7*pi/6, -pi/3, 2*pi/3, pi, 4*pi/3, pi/3, 0, -pi/6, pi/2, 5*pi/6, -pi/2, -5*pi/6, pi/6, -2*pi/3, pi/3, pi, 0, 2*pi/3, -pi/3];  % tiller angle and orientation angle, defined and used in Song et al, 2013
TILLER_ANGLE_0 = [0.00, 0.1309, 0.1309, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618];
TILLER_ANGLE_1 = [0.00, 0.1309, 0.1309, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618];
TILLER_ANGLE_2 = [0.06, 0.06, 0.1309, 0.1309, 0.1309, 0.1309, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618];
TILLER_ANGLE_3 = [0.06, 0.06, 0.1309, 0.1309, 0.1309, 0.1309, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618, 0.2618];

if stage == 0
    TILLER_ANGLE = TILLER_ANGLE_0;
elseif stage == 1
    TILLER_ANGLE = TILLER_ANGLE_1;
elseif stage == 2
    TILLER_ANGLE = TILLER_ANGLE_2;
elseif stage == 3
    TILLER_ANGLE = TILLER_ANGLE_3;
else
    TILLER_ANGLE = TILLER_ANGLE_3; % other later stage used the 3 stage
end
% 上述两个参数也是常数。表示分蘖的方向角，和与轴心的夹角。（水稻有很多分蘖，大的分蘖居中，小的分蘖围在大分蘖周围，这里从前往后一次从大到小分蘖）

global MAXIMAL_PLANT_NUM;
MAXIMAL_PLANT_NUM = 9; 
% 输入的数据中有多少株的测量株型数据

% 叶片生理参数
global LNC;  %leaf nitrogen content.测量的叶片氮含量。单位是g/m2，范围从0.1-5.0， 用户输入参数。
LNC = [1.5826, 1.4742, 1.2574, 1.1599, 0.9702, 0.8564, 0.8564, 0.8564];
global LEAF_SPAD LEAF_SPAD_MEASURE_POINT;  
LEAF_SPAD_MEASURE_POINT = [1/6 1/2 5/6];% relative value from base to tip (0-1)   % 叶绿素的测量位置，在叶片从基部到尖部的位置，0表示基部，1表示尖部。这里有3个测量位置。常数，固定值。
LEAF_SPAD = [  %WT in booting stage
    41.18 40.85 39.77; % Flag Leaf
    42.55 43.67 41.68; % L2
    46.10 46.05 43.70; % L3
    48.60 47.13 45.85; % L4
    48.60 47.13 45.85; % L5
    48.60 47.13 45.85; % L6
    48.60 47.13 45.85; % L7
    48.60 47.13 45.85];% L8

global Chl_CONC; 
Chl_CONC = 317; % unit: umol.m-2 leaf area

% 冠层level的参数：used in function M_canopy = Os_canopy(paramMatrix)
global STEP_X STEP_Y ROW_NUM COL_NUM;
STEP_X = 20; % row distance of canopy, in the x direction  行距离，单位cm，这个是输入参数，用户可调节。
STEP_Y = 20; % column distance, y direction  列距离，单位cm，这个是输入参数，用户可调节。
ROW_NUM = 7; % row number of canopy 行数，即构建几行水稻，这个是输入参数，用户可调节。
COL_NUM = 7; % col number 列数。这个是输入参数，用户可调节。
%构建的水稻的冠层(canopy)为num_row行，num_col列的一块方田地。这里每一株水稻的输入参数是同一个数据文件。但是每一株水稻的构建过程
%中包括了一些随机扰动。

global S_adj_ratio;
S_adj_ratio = 1;


global PlantIDs;
PlantIDs = [1 2 3 4 5 6 7
3 4 5 6 7 8 9
8 9 1 2 3 4 5
5 6 7 8 9 1 2
2 3 4 5 6 7 8
7 8 9 1 2 3 4
4 5 6 7 8 9 1
];


end




