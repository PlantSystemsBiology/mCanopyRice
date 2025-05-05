
%% this is a demo script for using the calculateAc function, this function is used after ray tracing simulation.


%% Step 3: Ray Tracing

% go to powershell to run the ray tracing

%% Step 4: calcualte LAI, PPFD abs and Ac.  

trait = ["TN", "LN", "SH", "LL", "LW", "LS", "LC", "LA"];

replicateNum = 5;
stageID = 1; % stageID; % 1 for 07-24 (07-11 also use it), 2 for 0807, 3 for HS.
AQflag = '';
AQ_fit_param_file = 'AQ_fit_param_WYJ.xlsx';

% for vitural canopies with above structrue traits
for i=1:length(trait)
    genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
        canopy = calculateAc (strcat('PPFD_0711-WYJ-ca1_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
        canopy = calculateAc (strcat('PPFD_0711-WYJ-ca1_CA2-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
    genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
        canopy = calculateAc (strcat('PPFD_0711-WYJ-CA2_F1-',trait{i}),replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
end
% for virtual canopies with AQ trait
AQflag = 'F1-AQ'; % ca1 with F1 AQ
genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = 'CA2-AQ'; % ca1 with CA2 AQ
genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = 'F1-AQ'; % CA2 with F1 AQ
genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

% for the ca1, CA2 and F1. WTs
AQflag = ''; % ca1 with ca1 AQ
genotypeID = 1;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-ca1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = ''; % CA2 with CA2 AQ
genotypeID = 2;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-CA2',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);
AQflag = ''; % F1 with F1 AQ
genotypeID = 3;  % genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.
canopy = calculateAc ('PPFD_0711-WYJ-F1',replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag);

%% Step 5: summary all results into one file

trait = ["TN", "LN", "LL", "LW", "LS", "SH", "LA", "LC"];

LAI = zeros(0,2);
Ac = zeros(0,2);

% WTs
res = readtable('PPFD_0711-WYJ-ca1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('PPFD_0711-WYJ-CA2_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

res = readtable('PPFD_0711-WYJ-F1_.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% ca1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0711-WYJ-ca1_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0711-WYJ-ca1_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% CA2 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0711-WYJ-CA2_F1-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0711-WYJ-CA2_F1-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% F1 virtual canopies
for i=1:length(trait)
    res = readtable(strcat('PPFD_0711-WYJ-ca1_CA2-',trait{i},'_.xlsx'));
    LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];
end
res = readtable('PPFD_0711-WYJ-ca1_CA2-AQ.xlsx');
LAI = [LAI; res{1,2:3}]; Ac  = [Ac; res{38,2:3}];

% output to file
T = table(LAI(:,1), LAI(:,2), Ac(:,1), Ac(:,2), 'VariableNames',{'LAI','LAI SD','Ac','Ac SD'},'RowNames',{'ca1','CA1','F1',...
    'ca1 with F1 TN', 'ca1 with F1 LN', 'ca1 with F1 LL', 'ca1 with F1 LW', 'ca1 with F1 LS', 'ca1 with F1 SH', 'ca1 with F1 LA', 'ca1 with F1 LC', 'ca1 with F1 AQ'...
    'CA1 with F1 TN', 'CA1 with F1 LN', 'CA1 with F1 LL', 'CA1 with F1 LW', 'CA1 with F1 LS', 'CA1 with F1 SH', 'CA1 with F1 LA', 'CA1 with F1 LC', 'CA1 with F1 AQ'...
    'ca1 with CA1 TN', 'ca1 with CA1 LN', 'ca1 with CA1 LL', 'ca1 with CA1 LW', 'ca1 with CA1 LS', 'ca1 with CA1 SH', 'ca1 with CA1 LA', 'ca1 with CA1 LC', 'ca1 with CA1 AQ'...
    });
writetable(T,'PPFD_0711_WYJ.xlsx','Sheet',1,'WriteRowNames',true);




