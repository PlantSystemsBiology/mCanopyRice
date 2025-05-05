%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_stem is used for building a 3D rice stem model, as a module for build
% a rice tiller.
% Codeded by Qingfeng
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M_stem,radi0] = Os_stem (stemL)

global OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD;
% ---  stem of this tiller --- %    %
Ls = stemL;  % top of the stem  %
x0 = 0; % base of the stem      %
y0 = 0;
% put the stem vertical
z_s_0 = 0;
dem0  = 0.5 + (Ls - z_s_0) * 0.01;
radi0 = dem0/2;  % is the R of stem at base. 

p_s_01 = [radi0 + x0,   0 + y0,               z_s_0];
p_s_02 = [radi0/2 + x0, sqrt(3)*radi0/2 + y0, z_s_0];

z_s_1 = Ls;
dem1  = 0.3 + (Ls - z_s_1) * 0.01;
radi1 = dem1/2;
p_s_11 = [radi1 + x0,   0 + y0,               z_s_1];
p_s_12 = [radi1/2 + x0, sqrt(3)*radi1/2 + y0, z_s_1];


v = p_s_11 - p_s_01;
vLength = sqrt(v(1)^2 + v(2)^2 + v(3)^2); %

global OS_LEAF_SEGMENT_LENGTH; 

M1 = zeros(0,3);

for i = 0 : OS_LEAF_SEGMENT_LENGTH : vLength %  QF point cloud 2024-9-28
     point = p_s_01 + v/vLength * i; 
     M1 = [M1; point]; 
end

% M1 = [p_s_01; p_s_11]; % two points. %  QF point cloud 2024-9-28

% M1 = [p_s_01, p_s_02, p_s_11;
%            p_s_02, p_s_11, p_s_12];

[r0,c0] = size(M1);
M_all = M1;

for rot_stem = pi/3 : pi/3 : 5*pi/3
    X = M1(:,1);
    Y = M1(:,2);
    Z = M1(:,3);
    
    [theta,r,h] = cart2pol(X,Y,Z);
    theta = theta + pi/3;
    [X,Y,Z] = pol2cart(theta,r,h);
    
    M1 = [X, Y, Z]; 
    M_all = [M_all; M1];  % M_all and M1 are both 3 columns matrix.%  QF point cloud 2024-9-28
    
end
[row,col] = size(M_all);
M_stem = zeros(row, OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD); %  QF point cloud 2024-9-28
M_stem(:,3) = -1; % 0 for panicles£¬1 for flag leaf£¬2 and etc for other leaves, -1 for stem
M_stem(:,6:8) = M_all;  %  QF point cloud 2024-9-28

end


