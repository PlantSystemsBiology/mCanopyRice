%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_leaf is used for building a 3D rice leaf model, as a module for build
% a rice tiller.
% Codeded by Qingfeng
% 2020-02-26, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% leafL is the leaf length.
% leafW.relativePosition and leafW.width are two vectors showing the leaf
% width at different relative positions along the leaf from 0 (at leaf base)
% to 1 (at leaf tip). vector length is not limited, recommand 4-7.
% leafA is the leaf angle,
% leafCA is leaf curvature angle. range: 0~pi

function M_data = Os_leaf(leafID, leafBH, leafL, maximalLeafWidth, leafA, leafCA)


global OS_LEAF_SEGMENT_LENGTH;
global OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD;

% generate leafW.relativePosition and leafW.width from maximalLeafWidth and
% leafID
leafW = Os_leafWidth(maximalLeafWidth,leafID);

beta = 0; % initial value for leaf orientation angle

k = 1; % the id of triangles for construction of leaves

% ----------------------------Segmented Triple Hermite Difference---------------------
% Here, the difference is used to fit the contour of the blade, and the input of the difference is half of the actual width of the aforementioned blade at the "base, 1/4, 1/2, 3/4,... tip". because
% Using the main vein of the leaf as the horizontal axis.
x = leafW.relativePosition .* leafL;  
y = leafW.width./2;                  
t = 0:OS_LEAF_SEGMENT_LENGTH:leafL;  

if (leafL - t(end) > OS_LEAF_SEGMENT_LENGTH/10)  
    t = [t,leafL];
end

p = pchip(x,y,t);  

if(p(end)<0)  % 
    p(end) = 0;
end
% 
% -------------------------------------------%

metaAngle = leafCA/(length(t)-1);   %
baseX = 0;
baseZ = 0;

PointCloudOfLeaf = zeros(1,3);                 
positionOnLeaf = zeros(1,1);

    % ------------------- construct a point cloud for a leaf segment ------------ 

for m = 1:length(t)

    if m==1
        x1 = baseX;             %
        z1 = baseZ;             %
    else
        x1 = baseX+(t(m)-t(m-1))*sin(metaAngle*(m-2));     % 작속
        z1 = baseZ+(t(m)-t(m-1))*cos(metaAngle*(m-2));     % 작속
        baseX = x1;
        baseZ = z1;
    end

    ylist = 0: OS_LEAF_SEGMENT_LENGTH :p(m);
    if p(m) - ylist(end) > 0.1        %
        ylist = [ylist,p(m)];         %
    end

    if length(ylist)>1
        ylist = [-fliplr(ylist),ylist(2:end)];
    end


    for i = 1:length(ylist)
        PointCloudOfLeaf(k,:) = [x1, ylist(i),  z1];
        positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH *(m-1) + OS_LEAF_SEGMENT_LENGTH * 1/3;
        k = k+1;
    end

  %  PointCloudOfLeaf

end

PC = PointCloudOfLeaf; % point cloud

%-------------------------------------
[theta,r,h] = cart2pol(PC(:,1),PC(:,3),PC(:,2)); % X, Z, Y
theta = theta - leafA; %

%------------------------------------------
[X,Z,Y] = pol2cart(theta,r,h);

Z = Z + leafBH;

[row2, col2] = size(PC);

M_data = zeros(row2, OS_DATA_MATRIX_COLUMN_NUM_POINTCLOUD); % 8 columns.
% M_data column 1-3 for IDs, column 5 is for supplementary ID.
M_data(:,3) = leafID; % 0 panicles，1 flag leaf, 2 and etc for other leaves, -1 is for stems
M_data(:,4) = positionOnLeaf./leafL;  % relative position along leaf, from 0 to 1. 

%---------------convert the data to 9-columns format---------------------------
M_data(:,6:8) = [X,Y,Z];

% figure;
% ptCloud = pointCloud(M_data(:,6:8));
% pcshow(ptCloud);

%------- End of point cloud construction -------

% 
% for m = 1:length(t)-1   %
% 
%     x1 = baseX;             %
%     z1 = baseZ;             %
%     nextX = baseX+(t(m+1)-t(m))*sin(metaAngle*(m-1));     %
%     nextZ = baseZ+(t(m+1)-t(m))*cos(metaAngle*(m-1));     %
% 
% 
%     ylist = 0: OS_LEAF_SEGMENT_LENGTH :p(m);                   %
% 
%     if p(m) - ylist(end) > 0.1        %
%         ylist = [ylist,p(m)];         %
%     end
% 
%     ylist_2 = 0: OS_LEAF_SEGMENT_LENGTH :p(m+1);               %
% 
%     if p(m+1) - ylist_2(end) > 0.1
%         ylist_2 = [ylist_2,p(m+1)];
%     end
% 
% 
% 
% 
%     %------------------------------construct a triangle for a leaf segment-----------------
%     length1 = length(ylist);
%     length2 = length(ylist_2);
% 
%     for i = 1:min(length1,length2)-1          % 
%         DataOfLeaf(k,:) = [x1, ylist(i),  z1,   x2, ylist_2(i),z2,   x1, ylist(i+1),z1];
%         positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH *(m-1) + OS_LEAF_SEGMENT_LENGTH * 1/3;
%         %     positionOnLeaf(k,1)
%         k = k+1;
%         DataOfLeaf(k,:) = [x1, ylist(i+1),z1,   x2, ylist_2(i),z2,   x2, ylist_2(i+1),z2];
%         positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH *(m-1) + OS_LEAF_SEGMENT_LENGTH * 2/3;
%         k = k+1;
%     end
% 
%     if(length1 > length2)                       % 
%         for i=length2:length1-1
%             DataOfLeaf(k,:) = [x1, ylist(i),  z1,   x2, ylist_2(length2),z2,   x1, ylist(i+1),z1];
%             positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH*(m-1) + OS_LEAF_SEGMENT_LENGTH * 1/3;
%             k = k+1;
%         end
% 
%     elseif(length1 < length2)                   % 
%         for i=length1:length2-1
%             DataOfLeaf(k,:) = [x1, ylist(length1),  z1,   x2, ylist_2(i),z2,   x2, ylist_2(i+1),z2];
%             positionOnLeaf(k,1) = OS_LEAF_SEGMENT_LENGTH*(m-1) + OS_LEAF_SEGMENT_LENGTH * 2/3;
%             k = k+1;
%         end
%     end
% 
%     %----------------------------------------------
% 
%     baseX = nextX;           %
%     baseZ = nextZ;
% end   %
% 
% M = DataOfLeaf;
% 
% %-----------------construct a whole leaf------------------
% M2 = M;
% M2(:,2) = -M2(:,2);                         
% M2(:,5) = -M2(:,5);
% M2(:,8) = -M2(:,8);
% M = [M;M2];                                 
% positionOnLeaf = [positionOnLeaf;positionOnLeaf];
% [row2,col2]=size(M);
% 
% [X, Y, Z] = convertColumn9to3 (M); %
% 
% %-------------------------------------
% [theta,r,h] = cart2pol(X,Z,Y);            %
% theta = theta - leafA;                    %
% 
% %------------------------------------------
% [X,Z,Y] = pol2cart(theta,r,h);
% 
% Z = Z + leafBH;                         
% 
% M_data = zeros(row2,OS_DATA_MATRIX_COLUMN_NUM);
% % M_data column 1-3 for IDs, column 5 is for supplementary ID.
% M_data(:,3) = leafID; % 0 panicles，1 flag leaf, 2 and etc for other leaves, -1 is for stems
% M_data(:,4) = positionOnLeaf./leafL;  % relative position along leaf, from 0 to 1. 
% 
% %---------------convert the data to 9-columns format---------------------------
% M_data(:,6:14) = convertColumn3to9 ([X,Y,Z]);
% 
% M_data(:,15:17) = 0;

%% draw the leaf
%Draw3DModel(M_data,5);

%%
end


