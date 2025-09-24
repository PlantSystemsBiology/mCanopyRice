% script for COV dissection analysis
% 2025-08-04
% Qingfeng

%% for 0810, JYY

stage = 3;   % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3

%% Step 0: build 3D model, ca1, CA1 and F1. 
for r = 1:3  % set replicate number
    Os_main('..\M\M_0810-JP69-CA2.xlsx', strcat('..\CM\CM_0810-JP69-CA2-rep',num2str(r),'.txt'), stage);
    cov = calculateModelCOV(strcat('..\CM\CM_0810-JP69-CA2-rep',num2str(r),'.txt'));
        T = table(cov, 'RowNames',{strcat('..\CM\CM_0810-JP69-CA2-rep',num2str(r),'.txt')});
        writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');
        
    Os_main('..\M\M_0810-JY5B-ca1.xlsx', strcat('..\CM\CM_0810-JY5B-ca1-rep',num2str(r),'.txt'), stage);
    cov = calculateModelCOV(strcat('..\CM\CM_0810-JY5B-ca1-rep',num2str(r),'.txt'));
        T = table(cov, 'RowNames',{strcat('..\CM\CM_0810-JY5B-ca1-rep',num2str(r),'.txt')});
        writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');

    Os_main('..\M\M_0810-JYY69-F1.xlsx', strcat('..\CM\CM_0810-JYY69-F1-rep',num2str(r),'.txt'), stage);
    cov = calculateModelCOV(strcat('..\CM\CM_0810-JYY69-F1-rep',num2str(r),'.txt'));
        T = table(cov, 'RowNames',{strcat('..\CM\CM_0810-JYY69-F1-rep',num2str(r),'.txt')});
        writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');
end

%% Step 1: generate M file for virtual canopies.
addpath('virtualPlant');
trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];

for i=1:length(trait)
    % background: ca1,  donor: F1
    virtualCanopy('M_0810-JY5B-ca1.xlsx', 'M_0810-JYY69-F1.xlsx', trait{i}, strcat('M_0810-JY5B-ca1_F1-',trait{i},'.xlsx') );
    % background: CA2,  donor: F1
    virtualCanopy('M_0810-JP69-CA2.xlsx', 'M_0810-JYY69-F1.xlsx', trait{i}, strcat('M_0810-JP69-CA2_F1-',trait{i},'.xlsx') );
end

% for trait "TNLN", representing leaf number per plant. 
% background: ca1-F1-TN, donor: F1's LN
virtualCanopy('M_0810-JY5B-ca1_F1-TN.xlsx', 'M_0810-JYY69-F1.xlsx', 'LN', strcat('M_0810-JY5B-ca1_F1-','TNLN','.xlsx') );
% background: CA2-F1-TN, donor: F1's LN
virtualCanopy('M_0810-JP69-CA2_F1-TN.xlsx', 'M_0810-JYY69-F1.xlsx', 'LN', strcat('M_0810-JP69-CA2_F1-','TNLN','.xlsx') );


%% Step 2: build virtual canopies
% build 3D model for virtual canopies
trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"];
for i=1:length(trait)
    for r = 1:5  % set replicate number
        Os_main(strcat('..\M\M_0810-JY5B-ca1_F1-',trait{i},'.xlsx'), strcat('..\CM\CM_0810-JY5B-ca1_F1-',trait{i},'-rep',num2str(r),'.txt'), stage);
        cov = calculateModelCOV(strcat('..\CM\CM_0810-JY5B-ca1_F1-',trait{i},'-rep',num2str(r),'.txt'));
        T = table(cov, 'RowNames',{strcat('..\CM\CM_0810-JY5B-ca1_F1-',trait{i},'-rep',num2str(r),'.txt')});
        writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');

        Os_main(strcat('..\M\M_0810-JP69-CA2_F1-',trait{i},'.xlsx'), strcat('..\CM\CM_0810-JP69-CA2_F1-',trait{i},'-rep',num2str(r),'.txt'), stage);
        cov = calculateModelCOV(strcat('..\CM\CM_0810-JP69-CA2_F1-',trait{i},'-rep',num2str(r),'.txt'));
        T = table(cov, 'RowNames',{strcat('..\CM\CM_0810-JP69-CA2_F1-',trait{i},'-rep',num2str(r),'.txt')});
        writetable(T,'COV.xlsx','Sheet',1,'WriteRowNames', true, 'WriteMode','Append');
    end
end



