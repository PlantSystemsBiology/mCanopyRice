


%% script to run fittingAQs

% checked, 2024-4-3
addpath('fittingAQ');
for ID = 1:3 % 1, 2, 3
    AQfittingOutput_all = fittingAQs(ID); 
end
