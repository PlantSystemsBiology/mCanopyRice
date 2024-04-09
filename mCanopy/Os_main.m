%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_main is the main function for Rice model. 
% Input, Output to files. Call the Os_canopy for building a canopy.
% Codeded by Qingfeng
% 2020-03-15, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run eg: Os_main('riceStructureParameter.xlsx','riceOutput.txt')
% stage: 0,1,2,3 for the plant structure measurement at 07-11, 07-24, 08-08, and HD stage. 
function Os_main(parameterFilename, canopy3dmodelFilename, stage)

addpath('rice');
addpath('utilities');

% parameters configuration
Os_PARAMETER_config(stage); 

% file input
filename = parameterFilename; % the Excel file name
sheet = 1;
paramMatrix = xlsread(filename,sheet);  % read the parameter matrix from Excel file. 

% calculate leaf curvature angle 
% paramMatrix = solveAngle (paramMatrix); % the leaf curvature angle is pre-calculated. 
paramMatrix1 = paramMatrix (:,1:8);

% call Os_canopy function to build a model
M_canopy = Os_canopy(paramMatrix1);

% output to file

 writematrix(M_canopy,canopy3dmodelFilename,'Delimiter','tab'); %,'precision', '%.2f'

%% draw a canopy figure
% figure;
% Draw3DModel(M_canopy,5);
% axis equal
% view(15,20)

end



