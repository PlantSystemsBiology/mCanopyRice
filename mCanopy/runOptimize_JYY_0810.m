

%% 脚本，为了对单一表型进行调节，生成对应的M文件和CM文件，并且ray tracing之后，计算Ac，LAI，Abs及summary
% 2024-4-4
% Qingfeng

%% Step 6: adjust LL 
addpath('virtualPlant');
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
adjValues = [0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4];
adjustValues = ["0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4"];

adjustTrait = "LL"; % adjust LL
adjustMode = "MULTIPLY";

for i=1:length(adjustValues)
    adjValue = adjValues(i);

    virtualCanopySingleTraitAdjust('M_0810-JYY69-F1.xlsx', adjustTrait, adjustMode, adjValue, strcat('M_0810-JYY69_F1-',adjustTrait,'_',adjustMode, '_',adjustValues(i),'.xlsx'))
    virtualCanopySingleTraitAdjust('M_0810-JY5B-ca1.xlsx', adjustTrait, adjustMode, adjValue, strcat('M_0810-JY5B_ca1-',adjustTrait,'_',adjustMode, '_',adjustValues(i),'.xlsx'))
    virtualCanopySingleTraitAdjust('M_0810-JP69-CA2.xlsx', adjustTrait, adjustMode, adjValue, strcat('M_0810-JP69_CA2-',adjustTrait,'_',adjustMode, '_',adjustValues(i),'.xlsx'))
    
end

%% Step 7: build virtual canopies
% build 3D model for virtual canopies
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"];
adjustValues = ["1.0"];

adjustTrait = "LL"; % adjust LL
adjustMode = "MULTIPLY";

for i=1:length(adjustValues)
    % adjustValue = adjustValues(i);
    
    % virtualCanopySingleTraitAdjust(canopyModelParameter_file, traitID, adjustMode, adjustValue, outputCanopyModelParameter_file)
    
    for r = 1:5  % set replicate number
        Os_main(strcat('..\M\M_0810-JYY69_F1-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'.xlsx'), strcat('..\CM\CM_0810-JYY69_F1-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'-rep',num2str(r),'.txt'), stage);
        Os_main(strcat('..\M\M_0810-JY5B_ca1-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'.xlsx'), strcat('..\CM\CM_0810-JY5B-ca1-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'-rep',num2str(r),'.txt'), stage);
        Os_main(strcat('..\M\M_0810-JP69_CA2-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'.xlsx'), strcat('..\CM\CM_0810-JP69-CA2-',adjustTrait,'_',adjustMode, '_', adjustValues(i),'-rep',num2str(r),'.txt'), stage);

    end
end

%% step 8,  ray tracing run with python script

%% step 9, calcualte LAI, PPFD abs and Ac.  

addpath("calculation");

replicateNum = 5;
stageID = 2; % stageID; % 1 for 07-24 (07-11 also use it), 2 for 08-07 (08-10), 3 for HS.
AQflag = '';
AQ_fit_param_file = 'AQ_fit_param_JYY.xlsx';

% for virtural canopies with above structrue traits
traits = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA", "TNLN"];
adjustValues = ["0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4"];

adjustTrait = "LL"; % adjust LL
adjustMode = "MULTIPLY";

for i=1:length(adjustValues)
    adjustValue = adjustValues(i);

    genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    canopy = calculateAc (strcat('PPFD_0810-JY5B-ca1-',adjustTrait,'_',adjustMode, '_',num2str(adjustValues(i))),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    canopy = calculateAc (strcat('PPFD_0810-JP69-CA2-',adjustTrait,'_',adjustMode, '_',num2str(adjustValues(i))),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
    canopy = calculateAc (strcat('PPFD_0810-JYY69_F1-',adjustTrait,'_',adjustMode, '_',adjustValue), replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
end


%% Step 5: summary all results into one file

trait = ["LL", "LW",  "TNLN", "LS", "SH", "LA", "LC"]; 

LAI = zeros(0,2);
Ac = zeros(0,2);


for i=1:length(adjustValues)
    adjustValue = adjustValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JY5B-ca1-',adjustTrait,'_',adjustMode, '_',num2str(adjustValues(i)),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


for i=1:length(adjustValues)
    adjustValue = adjustValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JP69-CA2-',adjustTrait,'_',adjustMode, '_',num2str(adjustValues(i)),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


for i=1:length(adjustValues)
    adjustValue = adjustValues(i);
    res = readtable(strcat('..\summary\PPFD_0810-JYY69_F1-',adjustTrait,'_',adjustMode, '_',num2str(adjustValues(i)),'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end


% output to file
T = table(LAI(:,1), LAI(:,2), Ac(:,1), Ac(:,2), 'VariableNames',{'LAI','LAI SD','Ac','Ac SD'},'RowNames',{...
    'ca1 LL MULTIPLY 0.6', 'ca1 LL MULTIPLY 0.7', 'ca1 LL MULTIPLY 0.8', 'ca1 LL MULTIPLY 0.9', 'ca1 LL MULTIPLY 1.0', 'ca1 LL MULTIPLY 1.1', 'ca1 LL MULTIPLY 1.2', 'ca1 LL MULTIPLY 1.3','ca1 LL MULTIPLY 1.4'...
    'CA2 LL MULTIPLY 0.6', 'CA2 LL MULTIPLY 0.7', 'CA2 LL MULTIPLY 0.8', 'CA2 LL MULTIPLY 0.9', 'CA2 LL MULTIPLY 1.0', 'CA2 LL MULTIPLY 1.1', 'CA2 LL MULTIPLY 1.2', 'CA2 LL MULTIPLY 1.3','CA2 LL MULTIPLY 1.4'...
    'F1 LL MULTIPLY 0.6', 'F1 LL MULTIPLY 0.7', 'F1 LL MULTIPLY 0.8', 'F1 LL MULTIPLY 0.9', 'F1 LL MULTIPLY 1.0', 'F1 LL MULTIPLY 1.1', 'F1 LL MULTIPLY 1.2', 'F1 LL MULTIPLY 1.3','F1 LL MULTIPLY 1.4'...
    ...
    });
writetable(T,'..\summary_total\summary_0810_JYY_LL_MULTIPLY.xlsx','Sheet',1,'WriteRowNames',true);


