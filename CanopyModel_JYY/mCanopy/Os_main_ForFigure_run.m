


% draw single tiller plant
% Only for Figures

% 还不能执行
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('..\M\M_0810-JY5B-ca1-singleTiller.xlsx', strcat('..\CM\CM_0810-JY5B-ca1-drawFigure-singleTiller.txt'), stage);
axis off

% JYY 可以执行
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('..\M\M_0810-JY5B-ca1.xlsx', strcat('..\CM\CM_0810-JY5B-ca1-drawFigure.txt'), stage);
axis equal
axis off
xlim([-35,115]);ylim([-35,115]);zlim([0,100]);

% 这个还不能执行
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('..\M\M_0810-JY5B-ca1_F1-LL.xlsx', strcat('..\CM\CM_0810-JY5B-ca1_F1-LL-drawFigure.txt'), stage);
axis equal
axis off
xlim([-35,115]);ylim([-35,115]);zlim([0,100]);

% 可以执行
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('..\M\M_0810-JP69-CA2.xlsx', strcat('..\CM\CM_0810-JP69-CA2-drawFigure.txt'), stage);
axis equal
view(30,20)
axis off
xlim([-35,75]);ylim([-35,75]);zlim([0,100]);

%可以执行
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('..\M\M_0810-JYY69-F1.xlsx', strcat('..\CM\CM_0810-JYY69-F1-drawFigure.txt'), stage);
axis equal
axis off
xlim([-35,115]);ylim([-35,115]);zlim([0,100]);

