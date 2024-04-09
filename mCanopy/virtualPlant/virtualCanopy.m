
%% the function for generating a virtual canopy with input of background model and trait donor model

function virtualCanopy(canopyModel_acceptor_file, canopyModel_donor_file, traitID, outputfilename)

% traitID is one of these IDs: 'TLN','TN', 'LN', 'SH'，'LL', 'LW', 'LC',
% 'LA', 'LS'. % the TLN is total leaf number

modelA = readmatrix(strcat('..\M\',canopyModel_acceptor_file));
modelB = readmatrix(strcat('..\M\',canopyModel_donor_file));
col = 8;
modelA_with_B_trait = zeros(0,col);

%% IDs column number
PlantID_ind = 1;
TillerID_ind = 2;
OrganID_ind = 3;
leafBaseHeight_ind = 4;
leafLength_ind = 5;
leafWidth_ind = 6;
leafCurvatureAngle_ind = 7;
leafAngle_ind = 8;

for plantId = 1:9 % for every plant
    % tiller number of the two models
    TN_A = max(modelA(modelA(:,PlantID_ind)==plantId,TillerID_ind));
    TN_B = max(modelB(modelB(:,PlantID_ind)==plantId,TillerID_ind));

    % first, the traits for organ (tiller or leaf) numbers.
    if traitID == "TN" % change tiller number of A to the same as B.
        % tiller number
        % A map to B

        indexVector = heteroMapping(TN_B, TN_A);
        for i = 1:length(indexVector)
            temp = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==indexVector(i),:);
            temp(:,TillerID_ind) = i;
            modelA_with_B_trait = [modelA_with_B_trait; temp];
        end

    elseif traitID == "LS"
        % leaf area
        LeafAreaModelA = sum (modelA(modelA(:,PlantID_ind)==plantId,leafLength_ind) .* modelA(modelA(:,PlantID_ind)==plantId,leafWidth_ind) * 0.7);
        LeafAreaModelB = sum (modelB(modelB(:,PlantID_ind)==plantId,leafLength_ind) .* modelB(modelB(:,PlantID_ind)==plantId,leafWidth_ind) * 0.7);
        BAratio = LeafAreaModelB / LeafAreaModelA; 

        modelA(modelA(:,PlantID_ind)==plantId,leafLength_ind) = modelA(modelA(:,PlantID_ind)==plantId,leafLength_ind).* sqrt(BAratio);
        modelA(modelA(:,PlantID_ind)==plantId,leafWidth_ind) = modelA(modelA(:,PlantID_ind)==plantId,leafWidth_ind).* sqrt(BAratio);

    elseif traitID == "LN" % change leaf number of A to be the same as B
        % leaf number
        % search A from B, then A map to B.
        indexVector = heteroMapping(TN_A, TN_B);
        for i = 1:length(indexVector)
            LN_A = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i,OrganID_ind));
            LN_B = max(modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==indexVector(i),OrganID_ind));
            indexVector2 = heteroMapping(LN_B, LN_A);

            % calcualte stem length and adjust leaf base height
            stemL = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind))-...
                min(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind));
            adjustLeafBaseHeight = stemL/length(indexVector2)/2;

            % calcualte the adjust values for every leaf from bottom to top
            adjustLeafBaseHeightVector = zeros(length(indexVector2),1); % initial an zeros vector
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

            %
            for j = 1:length(indexVector2)
                temp = modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==indexVector2(j),:);
                temp(:,OrganID_ind) = j;
                temp(:,leafBaseHeight_ind) = temp(:,leafBaseHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
            %    temp(:,leafTipHeight_ind) = temp(:,leafTipHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height
                modelA_with_B_trait = [modelA_with_B_trait; temp];
            end
        end

    else % for those traits related to organ size, not organ numbers.
        targetTrait_ind = 0; % initial value 0
        if traitID == "SH"  % stem height, or leaf base height
            targetTrait_ind = leafBaseHeight_ind;
        elseif traitID == "LL"  % leaf length
            targetTrait_ind = leafLength_ind;
        elseif traitID == "LW"  % leaf width
            targetTrait_ind = leafWidth_ind;
        elseif traitID == "LC"  % leaf curvature angle
            targetTrait_ind = leafCurvatureAngle_ind;
        elseif traitID == "LA"  % leaf angle
            targetTrait_ind = leafAngle_ind;
        else
            % Add other traits from here
        end

        % search A from B, then change A's SH equals to B's
        indexVector = heteroMapping(TN_A, TN_B);

        for i = 1:length(indexVector)
            LN_A = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i,OrganID_ind));
            LN_B = max(modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==indexVector(i),OrganID_ind));
            indexVector2 = heteroMapping(LN_A, LN_B);
            for j = 1:length(indexVector2)

                %以下叶尖调节不需要，因为叶尖不作为参数使用了
% %                 对于stem height调节，将A的叶尖调整
% %                if traitID == "SH" % only when 'SH', need to adjust leaf tip height
% %                    计算对应叶片的SH的差异
% %                    diff_betweenBandA = modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==indexVector(i) & modelB(:,OrganID_ind)==indexVector2(j), targetTrait_ind) - ...
% %                        modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, targetTrait_ind); % will be used when 'SH' for adjusting leaf tip height
% %                    调节A的叶尖高度
% %                    modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafTipHeight_ind) = ...
% %                        modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafTipHeight_ind) + diff_betweenBandA; % adjust leaf tip height
% %                end

               % 将B的trait赋值给A的trait

                modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, targetTrait_ind) = ...
                    modelB(modelB(:,PlantID_ind)==plantId & modelB(:,TillerID_ind)==indexVector(i) & modelB(:,OrganID_ind)==indexVector2(j), targetTrait_ind);

                
            end

            % when it is 'SH', adjust leaf base height for modelA
            if traitID == "SH"
                % calcualte stem length and adjust leaf base height
                stemL = max(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind))-...
                    min(modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i, leafBaseHeight_ind));
                adjustLeafBaseHeight = stemL/length(indexVector2)/2;

                % calcualte the adjust values for every leaf from bottom to top
                adjustLeafBaseHeightVector = zeros(length(indexVector2),1); % initial an zeros vector
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

                %
                for j = 1:length(indexVector2)
                    modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafBaseHeight_ind) = ...
                        modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafBaseHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf base height

             %       modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafTipHeight_ind) = ...
             %           modelA(modelA(:,PlantID_ind)==plantId & modelA(:,TillerID_ind)==i & modelA(:,OrganID_ind)==j, leafTipHeight_ind) + adjustLeafBaseHeightVector(j); % adjust leaf tip height

                end
            end


        end

    end

end % plants
% write to file
if traitID == "TN"
    % modelA_with_B_trait is added one tiller by one tiller
elseif traitID == "LN"
    % modelA_with_B_trait is added one leaf by one leaf
else
    modelA_with_B_trait = modelA;
end

writematrix(modelA_with_B_trait,strcat('..\M\',outputfilename));

end


