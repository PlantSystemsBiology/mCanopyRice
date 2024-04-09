

%% script to run getLeafCurvature
% checked, 2024-4-3
% Qingfeng
addpath('leafCurvature');
stage = ["0711", "0724","0810","0828"]; % MMDD
genotype = ["ca1","CA2","F1"]; %

NameJYY = ["JY5B","JP69","JYY69"]; % two cultivars
NameWYJ = ["WYJ","WYJ","WYJ"]; % two cultivars
Name9311 = ["9311","9311","9311"];

% JYY
for i = 1:4
    for j = 1:3
        filename = strcat(stage(i),'-',NameJYY(j),'-',genotype(j),'.xlsx'); % "0711-JY5B-ca1.xlsx"
        getLeafCurvature(filename);
    end
end

% WYJ
for i = 1:4
    for j = 1:3
        filename = strcat(stage(i),'-',NameWYJ(j),'-',genotype(j),'.xlsx'); % "0711-WYJ-ca1.xlsx"
        getLeafCurvature(filename);
    end
end

% 9311
for i = 1:4
    if i == 2 || i == 4 % 9311 cultivar at "0724" and "0828" stage not measured
        continue;
    end
    for j = 1:3
        filename = strcat(stage(i),'-',Name9311(j),'-',genotype(j),'.xlsx'); % "0711-9311-ca1.xlsx"
        getLeafCurvature(filename);
    end
end



