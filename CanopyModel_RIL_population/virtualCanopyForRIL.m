
function virtualCanopyForRIL(canopyModelParameter_file, PH_adjValue, TN_adjustValue, LN_TargetValue, LL_adjValue, LW_adjValue, outputCanopyModelParameter_file)

modelA = readmatrix(strcat('.\M\',canopyModelParameter_file));

col = 8;
modelA_with_traitAdjusted = zeros(0,col);

%% IDs column number
PlantID_ind = 1;
TillerID_ind = 2;
OrganID_ind = 3;
leafBaseHeight_ind = 4;
leafLength_ind = 5;
leafWidth_ind = 6;
leafCurvatureAngle_ind = 7;
leafAngle_ind = 8;

% leaf number
% search A from B, then A map to B.

PN = max( modelA(:, PlantID_ind) );

modelA_LBH_mean = mean(modelA(:,leafBaseHeight_ind));

for plantId = 1:PN

    plantA_with_targetTN = zeros(0,col);

    TN_A = max( modelA(modelA(:,PlantID_ind)==plantId, TillerID_ind) );
    TN_B = round(TN_A + TN_adjustValue); % change tiller number
    indexVector = heteroMapping(TN_B, TN_A);

    for i = 1:length(indexVector)
        temp = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==indexVector(i),:);
        temp(:,TillerID_ind) = i;
        
        plantA_with_targetTN = [plantA_with_targetTN; temp];
       % size(temp)
    end

    [r,c] = size(plantA_with_targetTN);

    LN_adjustValue = LN_TargetValue - r; % re-calculate the leaf number adjust value

    LN_adj_for_allTiller = floor(LN_adjustValue/TN_B); % for every tiller, add LN_adj_for_allTiller leaves. LN_adj_for_allTiller can be positive or negative. 
    Tillers_addOneMore = mod(LN_adjustValue,TN_B); % for the first Tillers_addOneMore tillers, add one Leaf more. Tillers_addOneMore is positive. 

    for i = 1:length(indexVector)
        LN_A = max(plantA_with_targetTN(plantA_with_targetTN(:,PlantID_ind)==plantId & plantA_with_targetTN(:,TillerID_ind)==i,OrganID_ind));
        LN_B = LN_A + LN_adj_for_allTiller + (i<=Tillers_addOneMore)*1; % checked. QF
        indexVector2 = heteroMapping(LN_B, LN_A); % change LN_A to the same as LN_B.

        % calcualte stem length and adjust leaf base height
        stemL = max(plantA_with_targetTN(plantA_with_targetTN(:,PlantID_ind)==plantId & plantA_with_targetTN(:,TillerID_ind)==i, leafBaseHeight_ind))-...
            min(plantA_with_targetTN(plantA_with_targetTN(:,PlantID_ind)==plantId & plantA_with_targetTN(:,TillerID_ind)==i, leafBaseHeight_ind));
        adjustLeafBaseHeight = stemL/length(indexVector2)/2;

        % calcualte the adjust values for every leaf from bottom to top
        adjustLeafBaseHeightVector = zeros(length(indexVector2),1); % initial an zeros vector
        length(indexVector2)
        if length(indexVector2)>=3
        for j = 1: length(indexVector2)
            if j==1
                if indexVector2(j)==indexVector2(j+1)
                    adjustLeafBaseHeightVector(j)= -adjustLeafBaseHeight; % the bottom one leaf, leaves from bottom to up
                end

            elseif j==length(indexVector2)
                if indexVector2(j)==indexVector2(j-1)
                    adjustLeafBaseHeightVector(j)= +adjustLeafBaseHeight; % the top one leaf
                end
            else
                if indexVector2(j)==indexVector2(j+1)
                    adjustLeafBaseHeightVector(j)= -adjustLeafBaseHeight; % it is the same as the upper one
                end
                if indexVector2(j)==indexVector2(j-1)
                    adjustLeafBaseHeightVector(j)= +adjustLeafBaseHeight; % it is the same as the lower one
                end
            end
        end % calcualte the adjust values for every leaf from bottom to top
        end
        %
        for j = 1:length(indexVector2)
            temp = plantA_with_targetTN(plantA_with_targetTN(:,PlantID_ind)==plantId & plantA_with_targetTN(:,TillerID_ind)==i & plantA_with_targetTN(:,OrganID_ind)==indexVector2(j),:);
            temp(:,OrganID_ind) = j;
            temp(:,leafBaseHeight_ind) = temp(:,leafBaseHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
            
            temp(:,leafBaseHeight_ind) = temp(:,leafBaseHeight_ind).* PH_adjValue; % QF 2024-10-3
            %    temp(:,leafTipHeight_ind) = temp(:,leafTipHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
            modelA_with_traitAdjusted = [modelA_with_traitAdjusted; temp];
        end

        modelB = modelA_with_traitAdjusted;

        % change leaf length and leaf width, QF 2024-10-2
        leafLengthV = modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafLength_ind);
        modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafLength_ind) = leafLengthV * LL_adjValue;

        leafWidthV = modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafWidth_ind);
        modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafWidth_ind) = leafWidthV * LW_adjValue;

        modelA_with_traitAdjusted = modelB;

    end
end

currentLBH = mean(modelA_with_traitAdjusted(:,leafBaseHeight_ind));
currentAdj = (modelA_LBH_mean * PH_adjValue)/currentLBH;
modelA_with_traitAdjusted(:,leafBaseHeight_ind) = modelA_with_traitAdjusted(:,leafBaseHeight_ind).* currentAdj; % QF 2024-10-3

writematrix(modelA_with_traitAdjusted, strcat('.\M\',outputCanopyModelParameter_file));

end


