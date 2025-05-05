

%% the function for fitting AQ curves

function AQfittingOutput_all = fittingAQs(ID)

stage = ["0724","0807","HS"]; % MMDD
genotype = ["ca1","CA2","F1"]; %

NameJYY = ["JY5B","JP69","JYY69"]; % two cultivars
NameWYJ = ["WYJ","WYJ","WYJ"]; % two cultivars
%Name313 = ["313","314","313314"]; % two cultivars
Name9311 = ["9311", "9311","9311"]; 

NameOutputfile = ["..\AQcurves\AQ_fit_param_JYY.xlsx", "..\AQcurves\AQ_fit_param_WYJ.xlsx", "..\AQcurves\AQ_fit_param_9311.xlsx"];

% use ID to switch three set of cultivars. 
if ID == 1
nameCultivar = NameJYY; % 

elseif ID == 2
    nameCultivar = NameWYJ;
elseif ID == 3
    nameCultivar = Name9311;
end
outputFile = NameOutputfile(ID); 

% ouput matrix and rownames. 
AQfittingOutput_all = zeros(0,10);
% stageID, genotypeID, Pmax, phi, theta, Rd,  sse, rsquare, adjrsquare, rmse
RowNames_stage_cultivar_genotype = ["ENPTY"];

k = 1;
for i = 1:3 % stage, 1, 2, 3

    for j = 1:3 % genotype, 1, 2, 3

        AQfile = strcat('..\AQcurves\AQ-',nameCultivar{j},'-',stage{i},'-',genotype{j},'.txt'); % read from the AQ file.
        d = importdata(AQfile);
        d = d.data;
        PPFD = d(:,1);
        [row,col]=size(d);

        AQfittingOutput = zeros(col-1, 10);
        AQfittingOutput(:,1) = i; % stage, 1, 2, 3
        AQfittingOutput(:,2) = j; % genotype, 1, 2, 3

        for n=2:col  % for every single AQ curve
            A = d(:,n);
            Rd_input = A(end,1);
            Rd = -Rd_input;
            [fitresult, gof] = createFit(PPFD, A, Rd);
            AQfittingOutput(n-1,3:end) = [fitresult.Pmax, fitresult.phi, fitresult.theta, Rd,  gof.sse, gof.rsquare, gof.adjrsquare, gof.rmse];
        RowNames_stage_cultivar_genotype(k) = strcat(num2str(k),'_',stage{i},'_',nameCultivar{j},'_',genotype{j});
        k=k+1;
        end
        AQfittingOutput_all = [AQfittingOutput_all;AQfittingOutput];
    end

    
    T = table(AQfittingOutput_all(:,1),AQfittingOutput_all(:,2),AQfittingOutput_all(:,3),AQfittingOutput_all(:,4),AQfittingOutput_all(:,5),...
        AQfittingOutput_all(:,6),AQfittingOutput_all(:,7),AQfittingOutput_all(:,8),AQfittingOutput_all(:,9),AQfittingOutput_all(:,10),...
        'VariableNames',{'stageID','genotypeID','Pmax', 'phi', 'theta', 'Rd',  'sse', 'rsquare', 'adjrsquare', 'rmse'},...
        'RowNames',RowNames_stage_cultivar_genotype);

    writetable(T,outputFile,'Sheet',1,'WriteRowNames',true);


end

end

%%

function [fitresult, gof] = createFit(PPFD, A, Rd)
%CREATEFIT(PPFD,A)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : PPFD
%      Y Output: Ac1
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 03-May-2019 21:44:54 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData(PPFD, A);

% Set up fittype and options.
eqn = strcat('(phi*x+Pmax-sqrt((phi*x+Pmax)^2-4*theta*phi*x*Pmax))/(2*theta)-',num2str(Rd));
ft = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0 0.001];
opts.StartPoint = [10 0.5 0.1];
opts.Upper = [80 0.1 1];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

%% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'A vs. PPFD', 'untitled fit 1', 'Location', 'NorthEast' );
%% Label axes
xlabel PPFD
ylabel A


grid on
end


