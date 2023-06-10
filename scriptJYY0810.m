
%% for 0810, JYY

%% Step 0: build 3D model, the ca1, CA1 and F1. 
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
for r = 1:5  % set replicate number
    Os_main('M\M_0810-JP69-CA2.xlsx', strcat('CM\CM_0810-JP69-CA2-rep',num2str(r),'.txt'), stage);
    Os_main('M\M_0810-JY5B-ca1.xlsx', strcat('CM\CM_0810-JY5B-ca1-rep',num2str(r),'.txt'), stage);
    Os_main('M\M_0810-JYY69-F1.xlsx', strcat('CM\CM_0810-JYY69-F1-rep',num2str(r),'.txt'), stage);
end


%% Step 1: generate M file for virtual canopies. 
%trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
trait = "TNLN";
for i=1:length(trait)

    %  ca1 - F1 -
%    virtualCanopy('M_0810-JY5B-ca1.xlsx', 'M_0810-JYY69-F1.xlsx', trait{i}, strcat('M_0810-JY5B-ca1_F1-',trait{i},'.xlsx') );
    % CA2 -F1 - 
%    virtualCanopy('M_0810-JP69-CA2.xlsx', 'M_0810-JYY69-F1.xlsx', trait{i}, strcat('M_0810-JP69-CA2_F1-',trait{i},'.xlsx') );
    % ca1 - CA2 - 
%    virtualCanopy('M_0810-JY5B-ca1.xlsx', 'M_0810-JP69-CA2.xlsx', trait{i}, strcat('M_0810-JY5B-ca1_CA2-',trait{i},'.xlsx') );

    %  ca1 - F1 -
    virtualCanopy('M_0810-JY5B-ca1_F1-TN.xlsx', 'M_0810-JYY69-F1.xlsx', 'LN', strcat('M_0810-JY5B-ca1_F1-','TNLN','.xlsx') );
    % CA2 -F1 - 
    virtualCanopy('M_0810-JP69-CA2_F1-TN.xlsx', 'M_0810-JYY69-F1.xlsx', 'LN', strcat('M_0810-JP69-CA2_F1-','TNLN','.xlsx') );
    % ca1 - CA2 - 
    virtualCanopy('M_0810-JY5B-ca1_CA2-TN.xlsx', 'M_0810-JP69-CA2.xlsx', 'LN', strcat('M_0810-JY5B-ca1_CA2-','TNLN','.xlsx') );


    % F1 - ca1
    virtualCanopy('M_0810-JYY69-F1_ca1-TN.xlsx', 'M_0810-JY5B-ca1.xlsx', 'LN', strcat('M_0810-JYY69-F1_ca1-','TNLN','.xlsx') );
    % F1 - CA2
    virtualCanopy('M_0810-JYY69-F1_CA2-TN.xlsx', 'M_0810-JP69-CA2.xlsx', 'LN', strcat('M_0810-JYY69-F1_CA2-','TNLN','.xlsx') );
    % CA2 - ca1
    virtualCanopy('M_0810-JP69-CA2_ca1-TN.xlsx', 'M_0810-JY5B-ca1.xlsx', 'LN', strcat('M_0810-JP69-CA2_ca1-','TNLN','.xlsx') );

end


%% Step 2: build virtual canopies

% build 3D model for JP virtual canopies
% trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];
trait = "TNLN";
stage = 3; % 07-11 is stage 1. 07-24 is stage 2. 08-10 is stage3
for i=1:length(trait)
    for r = 1:5  % set replicate number
        
        Os_main(strcat('M\M_0810-JY5B-ca1_F1-',trait{i},'.xlsx'), strcat('CM\CM_0810-JY5B-ca1_F1-',trait{i},'-rep',num2str(r),'.txt'), stage);
        
        Os_main(strcat('M\M_0810-JP69-CA2_F1-',trait{i},'.xlsx'), strcat('CM\CM_0810-JP69-CA2_F1-',trait{i},'-rep',num2str(r),'.txt'), stage);
        
        Os_main(strcat('M\M_0810-JY5B-ca1_CA2-',trait{i},'.xlsx'), strcat('CM\CM_0810-JY5B-ca1_CA2-',trait{i},'-rep',num2str(r),'.txt'), stage);

        Os_main(strcat('M\M_0810-JYY69-F1_ca1-',trait{i},'.xlsx'), strcat('CM\CM_0810-JYY69-F1_ca1-',trait{i},'-rep',num2str(r),'.txt'), stage);
        
        Os_main(strcat('M\M_0810-JYY69-F1_CA2-',trait{i},'.xlsx'), strcat('CM\CM_0810-JYY69-F1_CA2-',trait{i},'-rep',num2str(r),'.txt'), stage);
        
        Os_main(strcat('M\M_0810-JP69-CA2_ca1-',trait{i},'.xlsx'), strcat('CM\CM_0810-JP69-CA2_ca1-',trait{i},'-rep',num2str(r),'.txt'), stage);

    end
end

% build virtual canopies

%% Step 3: Ray Tracing

% go to powershell to run the ray tracing

%% Step 4: calcualte LAI, PPFD abs and Ac.  

 trait = ["TN", "LN", "TNLN", "SH", "LL", "LW", "LS", "LC", "LA"];

replicateNum = 5;
stageID = 2; % stageID; % 1 for 07-24 (07-11 also use it), 2 for 08-07 (08-10), 3 for HS.
AQflag = '';
AQ_fit_param_file = 'AQ_fit_param_JYY.xlsx';

% for virtural canopies with above structrue traits
for i=1:length(trait)
    genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
        canopy = calculateAc (strcat('PPFD_0810-JY5B-ca1_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
        canopy = calculateAc (strcat('PPFD_0810-JY5B-ca1_CA2-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
        canopy = calculateAc (strcat('PPFD_0810-JP69-CA2_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
        canopy = calculateAc (strcat('PPFD_0810-JP69-CA2_ca1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 3;  
        canopy = calculateAc (strcat('PPFD_0810-JYY69-F1_ca1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
        canopy = calculateAc (strcat('PPFD_0810-JYY69-F1_CA2-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

end
% for virtual canopies with AQ trait
AQflag = 'ca1-AQ'; % ca1 with F1 AQ
genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JYY69-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
canopy = calculateAc ('PPFD_0810-JP69-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

AQflag = 'CA2-AQ'; % ca1 with CA2 AQ
genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JY5B-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
canopy = calculateAc ('PPFD_0810-JYY69-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

AQflag = 'F1-AQ'; % ca1 with F1 AQ
genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0810-JY5B-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
canopy = calculateAc ('PPFD_0810-JP69-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);


% for WTs
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

trait = ["LL", "LW",  "TNLN", "LS", "SH", "LA", "LC"]; %"TN", "LN", 

LAI = zeros(0,2);
Ac = zeros(0,2);

% WTs
res = readtable('PPFD_0810-JY5B-ca1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('PPFD_0810-JP69-CA2_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('PPFD_0810-JYY69-F1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% ca1_F1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JY5B-ca1_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JY5B-ca1_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% CA2_F1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JP69-CA2_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JP69-CA2_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% ca1_CA2 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JY5B-ca1_CA2-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JY5B-ca1_CA2-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% F1_ca1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JYY69-F1_ca1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JYY69-F1_ca1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% F1_CA2 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JYY69-F1_CA2-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JYY69-F1_CA2-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% CA2_ca1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0810-JP69-CA2_ca1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0810-JP69-CA2_ca1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];


% output to file
T = table(LAI(:,1), LAI(:,2), Ac(:,1), Ac(:,2), 'VariableNames',{'LAI','LAI SD','Ac','Ac SD'},'RowNames',{'ca1','CA1','F1',...
    'ca1 with F1 LL', 'ca1 with F1 LW', 'ca1 with F1 TNLN', 'ca1 with F1 LS', 'ca1 with F1 SH', 'ca1 with F1 LA', 'ca1 with F1 LC', 'ca1 with F1 AQ'...
    'CA1 with F1 LL', 'CA1 with F1 LW', 'CA1 with F1 TNLN', 'CA1 with F1 LS', 'CA1 with F1 SH', 'CA1 with F1 LA', 'CA1 with F1 LC', 'CA1 with F1 AQ'...
    'ca1 with CA1 LL', 'ca1 with CA1 LW', 'ca1 with CA1 TNLN','ca1 with CA1 LS',  'ca1 with CA1 SH', 'ca1 with CA1 LA', 'ca1 with CA1 LC', 'ca1 with CA1 AQ'...
    'F1 with ca1 LL', 'F1 with ca1 LW', 'F1 with ca1 TNLN', 'F1 with ca1 LS', 'F1 with ca1 SH', 'F1 with ca1 LA', 'F1 with ca1 LC', 'F1 with ca1 AQ'...
    'F1 with CA1 LL', 'F1 with CA1 LW', 'F1 with CA1 TNLN', 'F1 with CA1 LS', 'F1 with CA1 SH', 'F1 with CA1 LA', 'F1 with CA1 LC', 'F1 with CA1 AQ'...
    'CA1 with ca1 LL', 'CA1 with ca1 LW', 'CA1 with ca1 TNLN', 'CA1 with ca1 LS', 'CA1 with ca1 SH', 'CA1 with ca1 LA', 'CA1 with ca1 LC', 'CA1 with ca1 AQ'...
    });
writetable(T,'PPFD_0810_JYY-TNLN.xlsx','Sheet',1,'WriteRowNames',true);


