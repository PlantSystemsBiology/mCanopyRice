
%% the function for adjusting leaf length (LL)

% function for single trait optimization analysis. eg. 
% change LL by a multiply factor x ranging from 0.6 to 1.4 with interval of
% 0.1. that is 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4, totally 9 virtual
% canopies. 

function virtualCanopySingleTraitAdjust(canopyModelParameter_file, traitID, adjustMode, adjustValue, outputCanopyModelParameter_file)

% canopyModelParameter_file, The input M file
% traitID, The trait name
% adjustMode, Adjust by "ADD" or "MULTIPLY" model
% adjustValue, Adjust value, ADD x or MULTIPLY by x
% outputCanopyModelParameter_file, 
% generate virtual canopy parameters and save to M file

% traitID is one of these IDs: 'TLN','TN', 'LN', 'SH'，'LL', 'LW', 'LC',
% 'LA', 'LS'. % the TLN is total leaf number

modelA = readmatrix(strcat('..\M\',canopyModelParameter_file));

% col = 8;
modelA_with_traitAdjusted = modelA;

%% IDs column number
PlantID_ind = 1;
TillerID_ind = 2;
OrganID_ind = 3;
leafBaseHeight_ind = 4;
leafLength_ind = 5;
leafWidth_ind = 6;
leafCurvatureAngle_ind = 7;
leafAngle_ind = 8;

if adjustMode == "MULTIPLY"
    if traitID == "LL"
        modelA_with_traitAdjusted(:,leafLength_ind) = modelA(:,leafLength_ind).* adjustValue;
    end

elseif adjustMode == "ADD"
    if traitID == "LL"
        modelA_with_traitAdjusted(:,leafLength_ind) = modelA(:,leafLength_ind) + adjustValue;
    end

end

writematrix(modelA_with_traitAdjusted, strcat('..\M\',outputCanopyModelParameter_file));

end
