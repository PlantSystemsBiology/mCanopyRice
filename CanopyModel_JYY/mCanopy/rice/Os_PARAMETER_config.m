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
% The above two parameters are used as default values. The orientation angle of tillers and the tiller angle. 
global MAXIMAL_PLANT_NUM;
MAXIMAL_PLANT_NUM = 9; % the number of measured plants's architectural data as input

% leaf physiological data
global LNC;  % leaf nitrogen content.unit: g/m2，ranging from 0.1 to 5.0, input.
LNC = [1.5826, 1.4742, 1.2574, 1.1599, 0.9702, 0.8564, 0.8564, 0.8564];
global LEAF_SPAD LEAF_SPAD_MEASURE_POINT;  
LEAF_SPAD_MEASURE_POINT = [1/6 1/2 5/6];% relative value from base to tip (0-1)   
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

% canopy level parameters：used in function M_canopy = Os_canopy(paramMatrix)
global STEP_X STEP_Y ROW_NUM COL_NUM;
STEP_X = 20; % row distance of canopy, in the x direction 
STEP_Y = 20; % column distance, y direction  
ROW_NUM = 7; % row number of canopy 
COL_NUM = 7; % col number 

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




