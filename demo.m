
% this code is used for drawing Figure 1 models. 

stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('plantArchitectureParameters\ProcessedData\M_0810-JY5B-ca1.xlsx', strcat('canopy3DModel\demo\CM_0810-JY5B-ca1-drawFigure.txt'), stage);
axis off

stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('plantArchitectureParameters\ProcessedData\M_0810-JP69-CA2.xlsx', strcat('canopy3DModel\demo\CM_0810-JP69-CA2-drawFigure.txt'), stage);
axis equal
view(30,20)
axis off

stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('plantArchitectureParameters\ProcessedData\M_0810-JYY69-F1.xlsx', strcat('canopy3DModel\demo\CM_0810-JYY69-F1-drawFigure.txt'), stage);
axis equal
view(30,20)
axis off
xlim([-35,35]);ylim([-35,35]);zlim([0,100]);

% JY5B with F1 leaf length
trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
i=4; % LL is or leaf length
virtualCanopy('plantArchitectureParameters\ProcessedData\M_0810-JY5B-ca1.xlsx', 'plantArchitectureParameters\ProcessedData\M_0810-JYY69-F1.xlsx', trait{i}, strcat('plantArchitectureParameters\SubstitutedData\M_0810-JY5B-ca1_F1-',trait{i},'.xlsx') );
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('plantArchitectureParameters\SubstitutedData\M_0810-JY5B-ca1_F1-LL.xlsx', strcat('canopy3DModel\demo\CM_0810-JY5B-ca1_F1-LL-drawFigure.txt'), stage);
axis off

% JP69 with F1 leaf number
trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
i=1; % TNLN is or tiller number and leaf number (leaf number per plant)
virtualCanopy('plantArchitectureParameters\ProcessedData\M_0810-JP69-CA2.xlsx', 'plantArchitectureParameters\ProcessedData\M_0810-JYY69-F1.xlsx', trait{i}, strcat('plantArchitectureParameters\SubstitutedData\M_0810-JP69-CA2_F1-',trait{i},'.xlsx') );
i=2; % leaf number
virtualCanopy('plantArchitectureParameters\SubstitutedData\M_0810-JP69-CA2_F1-TN.xlsx', 'plantArchitectureParameters\ProcessedData\M_0810-JYY69-F1.xlsx', trait{i}, strcat('plantArchitectureParameters\SubstitutedData\M_0810-JP69-CA2_F1-TNLN.xlsx') );
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
Os_main('plantArchitectureParameters\SubstitutedData\M_0810-JP69-CA2_F1-TNLN.xlsx', strcat('canopy3DModel\demo\CM_0810-JP69-CA2_F1-TNLN-drawFigure.txt'), stage);
axis off




