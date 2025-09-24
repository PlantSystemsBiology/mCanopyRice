
% calculation of COV with canopy model
% 2025-08-04
% Qingfeng

function cov = calculateModelCOV(CMfile)

addpath('virtualPlant');
global STEP_X STEP_Y ROW_NUM COL_NUM;

% cut the center region
    x_min = STEP_X/2; x_max = STEP_X/2 + (ROW_NUM-2)*STEP_X;
    y_min = STEP_Y/2; y_max = STEP_Y/2 + (COL_NUM-2)*STEP_Y;
    % load model
    model_pc = readmatrix(CMfile);
    idx = model_pc(:,6)>=x_min & model_pc(:,6)<x_max & model_pc(:,7)>=y_min & model_pc(:,7)<y_max;

    xyz = model_pc(idx,6:8);
    % downsampling
    ptCloud = pointCloud(xyz);
    gridStep = 0.1; % unit: cm
    ptCloudCOV = pcdownsample(ptCloud,'gridAverage',gridStep);

    % get the cov value
    cov = ptCloudCOV.Count * gridStep * gridStep * gridStep; % number of points multiplied by the volume of one cell
end
