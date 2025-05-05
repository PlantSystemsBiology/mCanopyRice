
% run script
% 2024-04-03
% Qingfeng

%% for 0810, JYY

stage = 3;   % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3

%% Step 0: build 3D model, ca1, CA1 and F1. 
for r = 1:5  % set replicate number
    Os_main('..\M\M_0810-JP69-CA2.xlsx', strcat('..\CM\CM_0810-JP69-CA2-rep',num2str(r),'.txt'), stage);
    Os_main('..\M\M_0810-JY5B-ca1.xlsx', strcat('..\CM\CM_0810-JY5B-ca1-rep',num2str(r),'.txt'), stage);
    Os_main('..\M\M_0810-JYY69-F1.xlsx', strcat('..\CM\CM_0810-JYY69-F1-rep',num2str(r),'.txt'), stage);
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
        Os_main(strcat('..\M\M_0810-JP69-CA2_F1-',trait{i},'.xlsx'), strcat('..\CM\CM_0810-JP69-CA2_F1-',trait{i},'-rep',num2str(r),'.txt'), stage);
    end
end

%% Step 3: Ray Tracing

% go to cmd to run jupyter notebook for running FastTracer

%% Step 4: calcualte LAI, PPFD abs and Ac.  
addpath("calculation");
trait = ["TN", "LN", "TNLN", "SH", "LL", "LW", "LS", "LC", "LA"];

replicateNum = 5;
stageID = 2; % stageID; % 1 for 07-24 (07-11 also use it), 2 for 08-07 (08-10), 3 for HS.
AQflag = '';
AQ_fit_param_file = 'AQ_fit_param_JYY.xlsx';

% for virtural canopies with above structrue traits
for i=1:length(trait)
    genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    canopy = calculateAc (strcat('PPFD_0810-JY5B-ca1_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    canopy = calculateAc (strcat('PPFD_0810-JP69-CA2_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
end

% for virtual canopies with AQ trait

AQflag = 'F1-AQ'; % ca1 with F1 AQ
genotypeID = 3;  % genotypeID for AQ param; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JY5B-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
canopy = calculateAc ('PPFD_0810-JP69-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

% for virtual canopies with AQ trait, 2024-11-20
AQflag = 'ca1-AQ'; % ca1 with F1 AQ
genotypeID = 1;  % genotypeID for AQ param; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JYY69-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

AQflag = 'CA2-AQ'; % ca1 with F1 AQ
genotypeID = 2;  % genotypeID for AQ param; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JYY69-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

% for NILs
% for the ca1, CA2 and F1. WTs
AQflag = ''; % ca1 with ca1 AQ
genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JY5B-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = ''; % CA2 with CA2 AQ
genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JP69-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = ''; % F1 with F1 AQ
genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JYY69-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

%% Step 5: summary all results into one file

trait = ["LL", "LW",  "TNLN", "LS", "SH", "LA", "LC"]; 

LAI = zeros(0,2);
Ac = zeros(0,2);

% NILs
res = readtable('..\summary\PPFD_0810-JY5B-ca1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('..\summary\PPFD_0810-JP69-CA2_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('..\summary\PPFD_0810-JYY69-F1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% ca1_F1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('..\summary\PPFD_0810-JY5B-ca1_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('..\summary\PPFD_0810-JY5B-ca1_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% CA2_F1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('..\summary\PPFD_0810-JP69-CA2_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('..\summary\PPFD_0810-JP69-CA2_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% output to file
T = table(LAI(:,1), LAI(:,2), Ac(:,1), Ac(:,2), 'VariableNames',{'LAI','LAI SD','Ac','Ac SD'},'RowNames',{'ca1','CA1','F1',...
    'ca1 with F1 LL', 'ca1 with F1 LW', 'ca1 with F1 TNLN', 'ca1 with F1 LS', 'ca1 with F1 SH', 'ca1 with F1 LA', 'ca1 with F1 LC', 'ca1 with F1 AQ'...
    'CA1 with F1 LL', 'CA1 with F1 LW', 'CA1 with F1 TNLN', 'CA1 with F1 LS', 'CA1 with F1 SH', 'CA1 with F1 LA', 'CA1 with F1 LC', 'CA1 with F1 AQ'...
    });
writetable(T,'..\summary_total\summary_0810_JYY_updateAQ.xlsx','Sheet',1,'WriteRowNames',true);

