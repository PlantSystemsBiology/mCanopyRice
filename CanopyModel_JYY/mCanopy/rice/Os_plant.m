%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_plant is used for building a 3D rice plant model, as a module for build
% a rice canopy.
% Codeded by Qingfeng
% 2020-03-04, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M_plant = Os_plant (paramMatrix)

global DIRECTION_ORIENTATION;
global TILLER_ANGLE;
global OS_DATA_MATRIX_COLUMN_NUM;

plantID = paramMatrix(1,1); % the first column is plantID and the same. 

M_plant = zeros(0,OS_DATA_MATRIX_COLUMN_NUM); % empty single plant data matrix£¬one plant data¡£
tillerNum = max(paramMatrix(:,2)); % total tiller number.¡£

for tillerID = 1:tillerNum 
%    tillerID
    paramMatrix_aTiller = paramMatrix(paramMatrix(:,2) == tillerID,:);
    [M_tiller,radi0] = Os_tiller(paramMatrix_aTiller);
    
    if tillerID <= 2
        X_move_outter = 0.5 * radi0;
    elseif tillerID <= 8
        X_move_outter = 2 * radi0;
    elseif tillerID <= 20
        X_move_outter = 3 * radi0;
    else
        X_move_outter = 4 * radi0;
    end
    
    X = [M_tiller(:,6);M_tiller(:,9) ;M_tiller(:,12)];
    X = X + X_move_outter;  
    Y = [M_tiller(:,7);M_tiller(:,10);M_tiller(:,13)];
    Z = [M_tiller(:,8);M_tiller(:,11);M_tiller(:,14)];

    da = DIRECTION_ORIENTATION(tillerID);
    oa = TILLER_ANGLE(tillerID);
    
    [theta,r,h] = cart2pol(X,Y,Z);
    theta = theta+pi;
    [X,Y,Z] = pol2cart(theta,r,h);
    [theta,r,h] = cart2pol(X,Z,Y);
    theta = theta+oa;                   % tiller angle
    [X,Z,Y] = pol2cart(theta,r,h);
    [theta,r,h] = cart2pol(X,Y,Z);
    theta = theta+da;                   % tiller orientation angle
    [X,Y,Z] = pol2cart(theta,r,h);
    [row3,col3] = size(X);
    M = [X, Y, Z];
    M_tiller(:,6:8)  = M(1         :row3/3  ,: );
    M_tiller(:,9:11) = M(row3/3+1  :row3*2/3,: );
    M_tiller(:,12:14)= M(row3*2/3+1:row3    ,: );
    M_plant = [M_plant; M_tiller];
    
end
M_plant(:,1) = plantID;

% CHECK face is face, not line

smallFace_index = ...
    (M_plant(:,6) - M_plant(:,9 )).^2 + (M_plant(:,7 ) - M_plant(:,10)).^2 + (M_plant(:, 8) - M_plant(:,11)).^2 < 0.01 ...
  | (M_plant(:,6) - M_plant(:,12)).^2 + (M_plant(:,7 ) - M_plant(:,13)).^2 + (M_plant(:, 8) - M_plant(:,14)).^2 < 0.01 ...
  | (M_plant(:,9) - M_plant(:,12)).^2 + (M_plant(:,10) - M_plant(:,13)).^2 + (M_plant(:,11) - M_plant(:,14)).^2 < 0.01;
NumberOfSmallFacesDelete = sum(smallFace_index);
%NumberOfSmallFacesDelete  % for print
M_plant = M_plant(~smallFace_index,:);

end



