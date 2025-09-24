%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_plant is used for building a 3D rice plant model, as a module for build
% a rice canopy.
% Codeded by Qingfeng
% 2020-03-04, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M_canopy = Os_canopy(paramMatrix)

global STEP_X STEP_Y ROW_NUM COL_NUM;
global OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD;
global MAXIMAL_PLANT_NUM;
global PlantIDs;
M_canopy = zeros(0,OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD);
plantID = 0;

for id_row  = 0:ROW_NUM - 1     % rows
    x_shift = STEP_X * id_row;  % the shift of distance in the direction of rows, x-axis
    for id_col  = 0:COL_NUM - 1 % cols
        y_shift = STEP_Y * id_col;  % the shift of distance in the direction of cols, y-axis

        %  plantID, measured 9 plants, use these 9 plants to build a
        %  canopy, if the canopy is more than 9 plants, use from the first plant
        %  again.
        %   plantID = plantID+1;
        %   if plantID > MAXIMAL_PLANT_NUM
        %       plantID = 1;
        %   end
        plantID = PlantIDs(id_row+1,id_col+1);
        paramMatrix_plant = paramMatrix(paramMatrix(:,1) == plantID,:);
    %    plantID

        M_plant = Os_plant (paramMatrix_plant); % constructing a plant

        % plant routation QF;2020-4-15
        % [X, Y, Z] = M_plant(:,6:8);%  QF point cloud 2024-9-28
        X = M_plant(:,6);
        Y = M_plant(:,7);
        Z = M_plant(:,8);
        
        [theta,r,h] = cart2pol(X,Y,Z);                % rolling around Z-axis, convert to Cylindrical coordinate system
        theta = theta + rand*(2*pi);            % random angle for self-turning of one plant
        [X,Y,Z] = pol2cart(theta,r,h); % convert to rectangular cartesian coordinate system
        M_plant(:,6:8) = [X, Y, Z];%  QF point cloud 2024-9-28
        %

        M_plant(:,6:8) = [M_plant(:,6)+ x_shift, M_plant(:,7)+ y_shift, M_plant(:,8)]; %  QF point cloud 2024-9-28

        % M_plant(:,6:14) = [M_plant(:,6)+ x_shift, M_plant(:,7)+ y_shift, M_plant(:,8), ...
        %     M_plant(:,9)+x_shift,  M_plant(:,10)+y_shift, M_plant(:,11), ...
        %     M_plant(:,12)+x_shift, M_plant(:,13)+y_shift, M_plant(:,14)];
        M_canopy = [M_canopy; M_plant]; % add one plant to the canopy
    end
end

end



