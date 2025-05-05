%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_calculateLeafCA is a function for calculating rice leaf curvature angle
% Input, Output to files. 
% Codeded by Qingfeng
% 2020-05-06, Shanghai
% DO NOT USE from 2021-4-30
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run eg: Os_calculateLeafCA('riceStructureParameter-JP69.xlsx','riceStructureParameter-JP69-out.xlsx')
function Os_calculateLeafCA(parameterFilename, parameterFilename_output)

addpath('rice');
addpath('utilities');

% parameters configuration
Os_PARAMETER_config(); 

% file input
filename = parameterFilename; % the Excel file name
sheet = 1;
paramMatrix = xlsread(filename,sheet);  % read the parameter matrix from Excel file. 

% calculate leaf curvature angle 
paramMatrix = solveAngle (paramMatrix);
paramMatrix1 = paramMatrix (:,1:9);

xlswrite(parameterFilename_output, paramMatrix1, 1);

end





