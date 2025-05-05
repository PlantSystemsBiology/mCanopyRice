%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Os_leafWidth is used for converting a single value of maximal leaf width
% of rice to a 5 points leaf width vectors for the leaf width along with 
% the leaf, which is used for building a 3D rice leaf model.
% Codeded by Qingfeng 
% 2020-03-03, Shanghai
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% leafID 1 for flag leaf, larger than 1 is for other leaf. 
% maximalLeafWidth is for only one value of the leaf width.
function leafWidth = Os_leafWidth(maximalLeafWidth,leafID)

% default leaf edge curve values
global IDX_LEAF_POSITION;
global IDX_FLAG_LEAF_WIDTH;
global IDX_OTHER_LEAF_WIDTH;
leafWidth.relativePosition = IDX_LEAF_POSITION;
if leafID == 1 % for flag leaf
    leafWidth.width = maximalLeafWidth.*IDX_FLAG_LEAF_WIDTH;
else
    leafWidth.width = maximalLeafWidth.*IDX_OTHER_LEAF_WIDTH;
end

end


