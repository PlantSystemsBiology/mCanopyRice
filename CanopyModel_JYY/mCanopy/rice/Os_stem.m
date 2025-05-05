%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_stem is used for building a 3D rice stem model, as a module for build
% a rice tiller.
% Codeded by Qingfeng
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M_stem,radi0] = Os_stem (stemL)
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

M1 = [p_s_01, p_s_02, p_s_11;
           p_s_02, p_s_11, p_s_12];

[r0,c0] = size(M1);
M_all = M1;

for rot_stem = pi/3 : pi/3 : 5*pi/3
    X = [M1(:,1);M1(:,4);M1(:,7)];
    Y = [M1(:,2);M1(:,5);M1(:,8)];
    Z = [M1(:,3);M1(:,6);M1(:,9)];
    
    [theta,r,h] = cart2pol(X,Y,Z);
    theta = theta + pi/3;
    [X,Y,Z] = pol2cart(theta,r,h);
    
    M1 = [X(1:r0,:), Y(1:r0,:), Z(1:r0,:), X(r0+1: 2*r0, :), Y(r0+1: 2*r0, :), Z(r0+1: 2*r0, :), X(2*r0+1: 3*r0, :), Y(2*r0+1: 3*r0, :), Z(2*r0+1: 3*r0, :)];
    
    M_all = [M_all; M1];  % M_all and M1 are both 9 columns matrix.
    
end
[row,col] = size(M_all);
M_stem = zeros(row,17);
M_stem(:,3) = -1; % 0 for panicles£¬1 for flag leaf£¬2 and etc for other leaves, -1 for stem
M_stem(:,6:14) = M_all;

end


