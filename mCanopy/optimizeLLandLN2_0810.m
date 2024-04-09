

%% script of the pipeline for simulation of changing LN and LL, while keeping leaf area constant
% 2024-4-6
% Qingfeng

%% 0810 stage

%% Step 6: adjust LN and LL together with leaf area constant
addpath('virtualPlant');
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
adjValues = [0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8];
adjustTrait = "LNLL2"; % adjust LL

for i=1:length(adjValues)
    LN_adjustValue = adjValues(i);
    LN_adjustValue
     virtualCanopyLN_LL_Adjust2('M_0810-JY5B-ca1.xlsx', LN_adjustValue, strcat('M_0810-JY5B_ca1-',adjustTrait, '_', num2str(LN_adjustValue),'.xlsx'))
     virtualCanopyLN_LL_Adjust2('M_0810-JP69-CA2.xlsx', LN_adjustValue, strcat('M_0810-JP69_CA2-',adjustTrait, '_', num2str(LN_adjustValue),'.xlsx'))
     virtualCanopyLN_LL_Adjust2('M_0810-JYY69-F1.xlsx', LN_adjustValue, strcat('M_0810-JYY69_F1-',adjustTrait, '_', num2str(LN_adjustValue),'.xlsx'))
end

%% Step 7: build virtual canopies
% build 3D model for virtual canopies
stage=3;% 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"];
adjValues = [0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8];
adjustTrait = "LNLL2"; % adjust LL

for i=1:length(adjValues)
    LN_adjustValue = adjValues(i);

    for r = 1:5  % set replicate number
       Os_main(strcat('..\M\M_0810-JY5B_ca1-',adjustTrait,'_', num2str(LN_adjustValue),'.xlsx'), strcat('..\CM\CM_0810-JY5B_ca1-',adjustTrait,'_', num2str(LN_adjustValue),'-rep',num2str(r),'.txt'), stage);
       Os_main(strcat('..\M\M_0810-JP69_CA2-',adjustTrait,'_', num2str(LN_adjustValue),'.xlsx'), strcat('..\CM\CM_0810-JP69_CA2-',adjustTrait,'_', num2str(LN_adjustValue),'-rep',num2str(r),'.txt'), stage);  
       Os_main(strcat('..\M\M_0810-JYY69_F1-',adjustTrait,'_', num2str(LN_adjustValue),'.xlsx'), strcat('..\CM\CM_0810-JYY69_F1-',adjustTrait,'_', num2str(LN_adjustValue),'-rep',num2str(r),'.txt'), stage);
      
    end
end

%% step 8,  ray tracing run with python script. 



%% step 9, calcualte LAI, PPFD abs and Ac. 

addpath("calculation");

replicateNum = 5;
stageID = 2; % stageID; % 1 for 07-24 (07-11 also use it), 2 for 08-07 (08-10), 3 for HS.
AQflag = '';
AQ_fit_param_file = 'AQ_fit_param_JYY.xlsx';

% for virtural canopies with above structrue traits
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"];
adjValues = [-18, -15, -12, -9, -6, -3, 0, 3, 6, 9, 12, 15, 18, 21];
adjustTrait = "LNLL"; % adjust LL


for i=1:length(adjValues)
    i
    LN_adjustValue = adjValues(i);

    genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    %strcat('PPFD_0810-JY5B_ca1-',adjustTrait,'_',adjustValues(i))
    canopy = calculateAc (strcat('PPFD_0810-JY5B_ca1-',adjustTrait,'_', num2str(LN_adjustValue)), replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    %strcat('PPFD_0810-JP69_CA2-',adjustTrait,'_',adjustValues(i))
  %  canopy = calculateAc (strcat('PPFD_0810-JP69_CA2-',adjustTrait,'_', num2str(LN_adjustValue)), replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    %strcat('PPFD_0810-JYY69_F1-',adjustTrait,'_',adjustValues(i))
  %  canopy = calculateAc (strcat('PPFD_0810-JYY69_F1-',adjustTrait,'_', num2str(LN_adjustValue)), replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
end


%% Step 5: summary all results into one file 
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"]; 
adjValues = [-18, -15, -12, -9, -6, -3, 0, 3, 6, 9, 12, 15, 18, 21]; 
adjustTrait = "LNLL"; % adjust LL 


LAI = zeros(0,2);
Ac = zeros(0,2);


for i=1:length(adjValues)
    adjustValue = adjValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JY5B_ca1-',adjustTrait,'_',num2str(adjustValue),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


for i=1:length(adjValues)
    adjustValue = adjValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JP69_CA2-',adjustTrait,'_',num2str(adjustValue),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


for i=1:length(adjValues)
    adjustValue = adjValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JYY69_F1-',adjustTrait,'_',num2str(adjustValue),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


% output to file
T = table(LAI(:,1), LAI(:,2), Ac(:,1), Ac(:,2), 'VariableNames',{'LAI','LAI SD','Ac','Ac SD'},'RowNames',{...
    'ca1 LNLL -18','ca1 LNLL -15','ca1 LNLL -12', 'ca1 LNLL -9','ca1 LNLL -6','ca1 LNLL -3', 'ca1 LNLL 0', 'ca1 LNLL 3', 'ca1 LNLL 6', 'ca1 LNLL 9','ca1 LNLL 12','ca1 LNLL 15','ca1 LNLL 18','ca1 LNLL 21'...
 %   'CA2 LNLL -12', 'CA2 LNLL -9','CA2 LNLL -6','CA2 LNLL -3', 'CA2 LNLL 0', 'CA2 LNLL 3', 'CA2 LNLL 6', 'CA2 LNLL 9','CA2 LNLL 12','CA2 LNLL 15','CA2 LNLL 18','CA2 LNLL 21'...
 %   'F1 LNLL -21','F1 LNLL -18','F1 LNLL -15','F1 LNLL -12', 'F1 LNLL -9','F1 LNLL -6','F1 LNLL -3', 'F1 LNLL 0', 'F1 LNLL 3', 'F1 LNLL 6', 'F1 LNLL 9','F1 LNLL 12','F1 LNLL 15','F1 LNLL 18','F1 LNLL 21'...
    ...
    });
writetable(T,'..\summary_total\summary_0810_JYY_LNLL_-18to21_JY5B_LAImodi.xlsx','Sheet',1,'WriteRowNames',true);




