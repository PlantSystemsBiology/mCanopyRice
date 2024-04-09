%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETER_config is used for setting the CONSTANT as global variables for
% building the model
% Codeded by Qingfeng
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Ground_Sensor_PARAMETER_config()

% 模型矩阵的列数
global X_MIN X_MAX Y_MIN Y_MAX;

% used for ground triangle
X_MIN = 26.1 + 0.1;   % X direction is from
X_MAX = 102.1 - 0.1;
Y_MIN = 19 + 0.1;   
Y_MAX = 98 - 0.1;   

global SENSOR_X SENSOR_Y SENSOR_Z;

% parameter for sensor setting
SENSOR_X = 10;
SENSOR_Y = 10;
SENSOR_Z = 5 ;

end




