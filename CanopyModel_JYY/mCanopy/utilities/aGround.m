% this function will add ground into the canopy which will be used for
% the calculating the total absorbed PAR by ground

function [groundPoints, groundFacets, groundIDS] = aGround(Xmin, Xmax, Ymin, Ymax)

% ** ground **
%
% (Xmin,Ymax,0.1)                                    (Xmax,Ymax,0.1)
%  ------------------------------------------------
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  |                                              |
%  ------------------------------------------------
% (Xmin,Ymin,0.1)                                      (Xmax,Ymin,0.1)
%                (unit: cm)

    
    % default constant sensors 1cm*50cm, not using 100cm, because total canopy
    % extension is less than 100cm.
    
    groundPoints =[
        Xmin,  Ymin, 0.1;
        Xmin,  Ymax, 0.1;
        Xmax,  Ymin, 0.1;
        Xmax,  Ymax, 0.1;
        ] ;
    
    groundFacets = [
        1 3 2;
        3 4 2;
        ];
    [ground_row,  ground_col] = size(groundFacets);
    groundIDS = zeros(ground_row, 7);
    groundIDS(:,1) = -20;    % -20 is ground (defined in fastTracer3.7)
    
    % also set Kr and Kt for columns in model (assume total absorbed)
    groundIDS(:,5) = 0;   % Kt
    groundIDS(:,6) = 0;   % Kr
    
    


end




