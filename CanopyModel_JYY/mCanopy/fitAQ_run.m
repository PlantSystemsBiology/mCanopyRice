


%% script to run fittingAQs

% checked, 2024-4-3
addpath('fittingAQ');
for ID = 1:1 % 1, 2, 3
    AQfittingOutput_all = fittingAQs2(ID); % 更新后的拟合方法，使用4次测量的平均曲线进行一次拟合。
end

