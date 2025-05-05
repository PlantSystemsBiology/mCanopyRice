
%% the function for calculating canopy photosynthesis rate (Ac), canopy absorbance (abs) and leaf area index (LAI).

%% input and output summary
% Input:
% PPFD 3D model,
% AQ para file (and stageID, genotypeID).

% Output:
% canopy.LAI, canopy.plantHeight, canopy.groundArea,
% canopy.incidentPAR, canopy.absorbedPPFD, canopy.canopyAbs,
% canopy.diurnalAc, canopy.dailyTotalAc,
% others will be added...

% PPFD_File_Name_base: "PPFD_0711-JP69-CA2-rep" is the Name base of
% "PPFD_0711-JP69-CA2-rep1.txt".
% replicateNum is 5.

% AQ_fit_param_file, it can be:
% "AQ_fit_param_JYY.txt", "AQ_fit_param_WYJ.txt", "AQ_fit_param_313.txt"

% stageID and genotypeID is used for indexing the AQ curves parameters for calculating leaf photosynthesis.
% stageID; % 1 for 0724 (0711 also use it), 2 for 0807, 3 for HS.
% genotypeID; % 1 for ca1, 2 for CA2, 3 for F1.



%%
function canopy = calculateAc(PPFD_File_Name_base,replicateNum, AQ_fit_param_file, stageID, genotypeID, AQflag)


%% this block is PROJECT SPECIFIC hard code constant
canopy.groundArea = 3600/10000; % unit: m2, its 60cm * 60cm, it is 3*3 plants. Constant

% ambient total PAR, stage1
PAR0711 = [233.7 	632.5 	1040.4 	1389.7 	1642.0 	1773.8 	1773.8 	1642.0 	1389.7 	1040.4 	632.5 	233.7; % direct PPFD
    270.2 	331.1 	360.5 	376.4 	384.9 	388.8 	388.8 	384.9 	376.4 	360.5 	331.1 	270.2]; % diffuse PPFD
PAR0711 = sum(PAR0711); % total PPFD
% .................., stage2
PAR0724 = [204.2 	601.3 	1013.2 	1367.0 	1622.9 	1756.7 	1756.7 	1622.9 	1367.0 	1013.2 	601.3 	204.2; % direct PPFD
    262.3 	328.0 	359.0 	375.5 	384.4 	388.3 	388.3 	384.4 	375.5 	359.0 	328.0 	262.3]; % diffuse PPFD
PAR0724 = sum(PAR0724); % total PPFD
% .................., stage3
PAR0828 = [80.0326 440.776 857.128 1222.69 1488.79 1628.26 1628.26 1488.79 1222.69 857.128 440.776 80.0326 % direct PPFD
211.97 308.871 349.29 369.486 379.961 384.522 384.522 379.961 369.486 349.29 308.871 211.97]; % diffuse PPFD
PAR0828 = sum(PAR0828); % total PPFD

PAR_all = [PAR0711;
    PAR0724;
    PAR0828]'; % merge together
%%

%% PPFD file format, CONSTANT
plantID_ind = 1;
tillerID_ind = 2;
leafID_ind = 3; % the third column is organ ID，1.2.3 etc are leaves, from bottom to top, 0 is stem.
position_ind = 4;
extraID_ind = 5;
XYZ_ind = 6:14;
NpArea_ind = 15;
Kt_ind = 16;
Kr_ind = 17;
facetS_ind = 18;
WholeDayTimePoints = 12;
TotalPAR_ind = (18+7):7:(18+7*WholeDayTimePoints);

%%
LAI = zeros(1,replicateNum);
absorbedPPFD = zeros(WholeDayTimePoints, replicateNum);
canopyAbs = zeros(WholeDayTimePoints, replicateNum);
diurnalAc = zeros(WholeDayTimePoints, replicateNum);
dailyTotalAc = zeros(1, replicateNum);

for rep = 1:replicateNum

    PPFD_file = strcat('..\PPFD\',PPFD_File_Name_base, '-rep',num2str(rep),'.txt');
    %PPFD_file
    d = importdata(PPFD_file); % with header
    d = d.data;

    d_leaf = d(d(:,3)>=1,:); % the 3rd column is organID
    d_stem = d(d(:,3)==0,:);

    % LAI
    leafArea = d_leaf(:,facetS_ind)./10000; % leaf area, exclude stem, unit: m2
    LA = sum(leafArea); % unit: m2
    LAI(rep) = LA/canopy.groundArea;

    % PPFD and canopy absorbance, include leaf and stem absorbed.
    leafStemAbsPPFD = d(:,TotalPAR_ind); % from 6.5 to 17.5 time points
    absorbedPPFD(:,rep) = (  (d(:,facetS_ind)/10000)' * leafStemAbsPPFD./canopy.groundArea )'; %unit: umol m-2 ground area s-1
    canopy.incidentPAR = PAR_all(:,stageID); %unit: umol m-2 ground area s-1
    canopyAbs(:,rep) = absorbedPPFD(:,rep)./canopy.incidentPAR; % unit: 0-1 , dimentionless

    % AQ curve parameters loading and searching from input
    AQpara= readtable(strcat('..\AQCurves\',AQ_fit_param_file));
    ind = (AQpara.stageID == stageID & AQpara.genotypeID == genotypeID); 
    Pmax = mean(AQpara.Pmax(ind));
    phi = mean(AQpara.phi(ind));
    theta = mean(AQpara.theta(ind));
    Rd = mean(AQpara.Rd(ind));

    % leaf A
    x = d_leaf(:,TotalPAR_ind);
    A = (phi.*x+Pmax-sqrt((phi.*x+Pmax).^2-4*theta.*phi.*x.*Pmax))./(2*theta)-Rd; % unit, umol m-2 leaf s-1

    % Rd during night

    % canopy Ac
    diurnalAc(:,rep) = leafArea' * A ./ canopy.groundArea; % unit: umol m-2 ground s-1
    dailyTotalAc(rep) = sum(diurnalAc(:,rep).*3600)/1e6; % unit: mol m-2 d-1, the 3600 is 3600 seconds per hour as the interval is 1 hour.

end

% calculate Mean and Sd
canopy.LAI.mean = mean(LAI);   canopy.LAI.sd = std(LAI);
canopy.absorbedPPFD.mean = mean(absorbedPPFD,2);  canopy.absorbedPPFD.sd = std(absorbedPPFD,0,2);
canopy.canopyAbs.mean = mean(canopyAbs,2);     canopy.canopyAbs.sd = std(canopyAbs,0,2);
canopy.diurnalAc.mean = mean(diurnalAc,2);     canopy.diurnalAc.sd = std(diurnalAc,0,2);
canopy.dailyTotalAc.mean = mean(dailyTotalAc);  canopy.dailyTotalAc.sd = std(dailyTotalAc);

% output to Excel file
matrix_output = [
    canopy.LAI.mean, canopy.LAI.sd;
    canopy.absorbedPPFD.mean, canopy.absorbedPPFD.sd;
    canopy.canopyAbs.mean, canopy.canopyAbs.sd;
    canopy.diurnalAc.mean, canopy.diurnalAc.sd;
    canopy.dailyTotalAc.mean, canopy.dailyTotalAc.sd];
rowNames = {'LAI',...
    'absorbedPPFD_6.5h','absorbedPPFD_7.5h','absorbedPPFD_8.5h','absorbedPPFD_9.5h','absorbedPPFD_10.5h','absorbedPPFD_11.5h',...
    'absorbedPPFD_12.5h','absorbedPPFD_13.5h','absorbedPPFD_14.5h','absorbedPPFD_15.5h','absorbedPPFD_16.5h','absorbedPPFD_17.5h',...
    'canopyAbs_6.5h','canopyAbs_7.5h','canopyAbs_8.5h','canopyAbs_9.5h','canopyAbs_10.5h','canopyAbs_11.5h',...
    'canopyAbs_12.5h','canopyAbs_13.5h','canopyAbs_14.5h','canopyAbs_15.5h','canopyAbs_16.5h','canopyAbs_17.5h',...
    'diurnalAc_6.5h','diurnalAc_7.5h','diurnalAc_8.5h','diurnalAc_9.5h','diurnalAc_10.5h','diurnalAc_11.5h',...
    'diurnalAc_12.5h','diurnalAc_13.5h','diurnalAc_14.5h','diurnalAc_15.5h','diurnalAc_16.5h','diurnalAc_17.5h',...
    'dailyTotalAc'};

table1 = table(matrix_output(:,1), matrix_output(:,2),'VariableNames',{'Mean','SD'}, 'RowNames', rowNames);
filename  = strcat('..\summary\',PPFD_File_Name_base,'_',AQflag,'.xlsx');
writetable(table1,filename,'Sheet',1,'WriteRowNames',true);



