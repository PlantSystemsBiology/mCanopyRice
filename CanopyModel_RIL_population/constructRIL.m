
%% construct RIL population virtual canopies
% By changing plant Height, leaf length, leaf width, tiller number
% and total leaf number. 

addpath('virtualPlant');

global STEP_X STEP_Y ROW_NUM COL_NUM;

% the basic values of JYY69 at 0810 stage
LBH_JYY = 27.46; 
PH_JYY = 106; % cm
LL_JYY = 37.72;
LW_JYY = 1.33;
TN_JYY = 6.3;
LN_JYY = 31.3;

RIL_params = readtable('RIL-params.xlsx');
[r1,c1] = size(RIL_params);

NamesRIL = RIL_params{:,"Names"};
PH_adj = RIL_params{:,"PlantHeight"}./PH_JYY;
LL_adj = RIL_params{:,"LeafLength"}./LL_JYY;
LW_adj = RIL_params{:,"LeafWidth"}./LW_JYY;
TN_adj = RIL_params{:,"TillerNum"} - TN_JYY;
LN_target = RIL_params{:,"LeafNum"}; % vectors

for i = 1: r1

    % get the virtual canopy model M file
    virtualCanopyForRIL('M_0810-JYY69-F1-forRIL.xlsx', PH_adj(i), TN_adj(i), LN_target(i), LL_adj(i), LW_adj(i), strcat('M_RIL-',NamesRIL{i},'.xlsx'));

    % construct 3d point cloud
    Os_main(strcat('M\M_RIL-',NamesRIL{i},'.xlsx'), strcat('CM\CM_RIL-',NamesRIL{i},'.txt'), 2);

    % cut the center region
    x_min = STEP_X/2; x_max = STEP_X/2 + (ROW_NUM-2)*STEP_X;
    y_min = STEP_Y/2; y_max = STEP_Y/2 + (COL_NUM-2)*STEP_Y;

    % load model
    model_pc = readmatrix(strcat('CM\CM_RIL-',NamesRIL{i},'.txt'));
    idx = model_pc(:,6)>=x_min & model_pc(:,6)<x_max & model_pc(:,7)>=y_min & model_pc(:,7)<y_max;

    xyz = model_pc(idx,6:8);
    % downsampling
    ptCloud = pointCloud(xyz);
    gridStep = 0.1; % unit: cm
    ptCloudCOV = pcdownsample(ptCloud,'gridAverage',gridStep);

    % get the cov value
    cov = ptCloudCOV.Count * gridStep * gridStep * gridStep; % number of points multiplied by the volume of one cell

    % output to file
   % T = table('Size',[r1 1],'VariableTypes',{'double'});
    T = table(cov, 'RowNames',{NamesRIL{i}});
    writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');

end

