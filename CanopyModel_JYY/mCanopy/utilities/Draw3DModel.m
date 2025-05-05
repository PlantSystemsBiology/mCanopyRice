%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw3DModel is used for drawing a 3D model, eg. a leaf, a tiller, a plant
% or a canopy. 
% Codeded by Qingfeng 
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dataMatrix: the 3d model data, the format should be from column N+1 to N+9,
% total 9 column, to present triangles by three 3D points (total 9 values)
% in each row. The N can be 0 or bigger integer.
% 
% indexColumnNum: the value of N, which is the number of columns that
% not used for the 3D model matrix. These columns should be used for index
% of plant ID, tiller ID, leaf ID or others. 
function Draw3DModel(dataMatrix,indexColumnNum)

[row,col] = size(dataMatrix);

ic = indexColumnNum;
% convert the 9 columns data matrix into 3 columns x y z point vector
X = [dataMatrix(:,ic+1);dataMatrix(:,ic+4);dataMatrix(:,ic+7)];
Y = [dataMatrix(:,ic+2);dataMatrix(:,ic+5);dataMatrix(:,ic+8)];
Z = [dataMatrix(:,ic+3);dataMatrix(:,ic+6);dataMatrix(:,ic+9)];

% assign each group of three points from the above X, Y, Z points by index tri for each triangle
tri = zeros(row,3); % the indexing (x,y,z) points for a triangle.
tri(:,1) = (1:row)';
tri(:,2) = (1:row)' + row;
tri(:,3) = (1:row)' + 2*row;

% color of surface
color = zeros(row,3);
color(:,1) = 0;    % R
color(:,2) = 0;    % G
color(:,3) = 0;     % B
color = color/255;  % convert from 0-255 to 0-1.

% figure;
trisurf(tri,X,Y,Z,color,'FaceAlpha',0.7,'EdgeColor',[0/255,139/255,0/255],'LineWidth',0.1);
% other setting for the trisurf draw 3d figure:
%,metrix(:,[3,6,9]) 'FaceAlpha',0.7,'EdgeColor','interp','LineWidth',0.5);

axis equal;
view (-60,20);

%colormapeditor

% other setting for the figure:

%set(gca,'XLim',[20 130]);
%set(gca,'YLim',[0 115]);

end
