% this function will add some sensor into the canopy which will be used for
% the comparion with PAR sensor measured data in the real field.

function [sensorPoints, sensorFacets, sensorIDS] = aPPFDsensor(sensorX, sensorY, sensorZ)

% ** sensor **
%
% (X,Y+1,Z)                                    (X+50,Y+1,Z)
%   ===============================================
% (X,Y,Z)                                      (X+50,Y,Z)
%                (unit: cm)
%
    
    % default constant sensors 1cm*50cm, not using 100cm, because total canopy
    % extension is less than 100cm.
    
    sensorPoints =[
        1.514,       0.1,       0;
        0.1,        1.514,      0;
        1.514+35.4, 0.1+35.4,   0;
        0.1+35.4,   1.514+35.4, 0;
        ];
    
    sensorFacets = [
        1 3 2;
        3 4 2;
        ];
    [sensor_row,  sensor_col] = size(sensorFacets);
    sensorIDS = zeros(sensor_row, 7);
    sensorIDS(:,1) = -30;    % -30 is sensor (defined in fastTracer3.7)
    
    % also set Kr and Kt for columns in model
    sensorIDS(:,5) = 0;   % Kt
    sensorIDS(:,6) = 0.9; % Kr
    
    sensorPoints(:,1) = sensorPoints(:,1) + sensorX;
    sensorPoints(:,2) = sensorPoints(:,2) + sensorY;
    sensorPoints(:,3) = sensorPoints(:,3) + sensorZ;


end




