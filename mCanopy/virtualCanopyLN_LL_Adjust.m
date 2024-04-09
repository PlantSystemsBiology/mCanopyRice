


%% 同时改变LN和LL，保持Leaf Area不变
function virtualCanopyLN_LL_Adjust(canopyModelParameter_file, LN_adjustValue,outputCanopyModelParameter_file)

modelA = readmatrix(strcat('..\M\',canopyModelParameter_file));

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
for plantId = 1:PN

    TN_A = max( modelA(modelA(:,PlantID_ind)==plantId, TillerID_ind) );

    LN_adj_for_allTiller = floor(LN_adjustValue/TN_A); % for every tiller, add LN_adj_for_allTiller leaves. LN_adj_for_allTiller can be positive or negative. 
    Tillers_addOneMore = mod(LN_adjustValue,TN_A); % for the first Tillers_addOneMore tillers, add one Leaf more. Tillers_addOneMore is positive. 

    TN_B = TN_A; % keep tiller number constant
    indexVector = heteroMapping(TN_A, TN_B);
    for i = 1:length(indexVector)
        LN_A = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i,OrganID_ind));
        LN_B = LN_A + LN_adj_for_allTiller + (i<=Tillers_addOneMore)*1; % checked. QF
        indexVector2 = heteroMapping(LN_B, LN_A); % change LN_A to the same as LN_B.

        % calcualte stem length and adjust leaf base height
        stemL = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind))-...
            min(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind));
        adjustLeafBaseHeight = stemL/length(indexVector2)/2;

        % calcualte the adjust values for every leaf from bottom to top
        adjustLeafBaseHeightVector = zeros(length(indexVector2),1); % initial an zeros vector
        length(indexVector2)
        if length(indexVector2)>=2
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
            temp = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==indexVector2(j),:);
            temp(:,OrganID_ind) = j;
            temp(:,leafBaseHeight_ind) = temp(:,leafBaseHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
            %    temp(:,leafTipHeight_ind) = temp(:,leafTipHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
            modelA_with_traitAdjusted = [modelA_with_traitAdjusted; temp];
        end

        % change leaf length to keep the total leaf area of the tiller constant.
        % first, calculate the original canopy leaf area
        leafLengthV = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i ,leafLength_ind);
        leafWidthV = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i ,leafWidth_ind);
        leafAreaOrigin = sum(leafLengthV.*leafWidthV*0.7);

        % second, calculate the adjusted canopy leaf area
        modelB = modelA_with_traitAdjusted;
        leafLengthV = modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafLength_ind);
        leafWidthV = modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafWidth_ind);
        leafAreaNew = sum(leafLengthV .* leafWidthV * 0.7);

        % third, calcualte the leaf area ratio and adjust leaf length of
        % the adjusted canopy. 
        while abs(leafAreaNew - leafAreaOrigin)>1
            ratio = leafAreaNew/leafAreaOrigin;
            leafLengthV = leafLengthV/ratio; 
            leafLengthV(leafLengthV>62) = 60; % set those leaves longer than 62 to be 60.
            leafAreaNew = sum(leafLengthV .* leafWidthV * 0.7);
        end
      %  ratio
        modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==i ,leafLength_ind) = leafLengthV;
        modelA_with_traitAdjusted = modelB;

    end
end

writematrix(modelA_with_traitAdjusted, strcat('..\M\',outputCanopyModelParameter_file));

end


