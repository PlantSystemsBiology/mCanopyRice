%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_plant is used for building a 3D rice plant model, as a module for build
% a rice canopy.
% Codeded by Qingfeng
% 2020-03-04, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M_canopy = Os_canopy(paramMatrix)

global STEP_X STEP_Y ROW_NUM COL_NUM;
global OS_DATA_MATRIX_COLUMN_NUM;
global MAXIMAL_PLANT_NUM;
global PlantIDs;
M_canopy = zeros(0,OS_DATA_MATRIX_COLUMN_NUM);
plantID = 0;

for id_row  = 0:ROW_NUM - 1     %行循环
    x_shift = STEP_X * id_row;  %行方向的位移，为当前构建的一株水稻的位置x坐标。
    for id_col  = 0:COL_NUM - 1 %列循环
        y_shift = STEP_Y * id_col;  %列方向的位移，同上, y坐标。

        %  plantID, measured 9 plants, use these 9 plants to build a
        %  canopy, if the canopy is more than 9 plants, use from the first plant
        %  again.
        %   plantID = plantID+1;
        %   if plantID > MAXIMAL_PLANT_NUM
        %       plantID = 1;
        %   end
        plantID = PlantIDs(id_row+1,id_col+1);
        paramMatrix_plant = paramMatrix(paramMatrix(:,1) == plantID,:);
        plantID

        M_plant = Os_plant (paramMatrix_plant); %构建一个植物单株

        % plant routation QF;2020-4-15
        [X, Y, Z] = convertColumn9to3 (M_plant(:,6:14));
        [theta,r,h] = cart2pol(X,Y,Z);                % Z 方向为轴, -转换为柱坐标系,
        theta = theta + rand*(2*pi);            % 单株植物自传随机角度
        [X,Y,Z] = pol2cart(theta,r,h); %转换回笛卡尔坐标系
        M_plant(:,6:14) = convertColumn3to9 ([X, Y, Z]);
        %

        M_plant(:,6:14) = [M_plant(:,6)+ x_shift, M_plant(:,7)+ y_shift, M_plant(:,8), ...
            M_plant(:,9)+x_shift,  M_plant(:,10)+y_shift, M_plant(:,11), ...
            M_plant(:,12)+x_shift, M_plant(:,13)+y_shift, M_plant(:,14)];
        M_canopy = [M_canopy; M_plant]; %加入到植物冠层中
    end
end

end



