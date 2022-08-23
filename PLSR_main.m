function model = PLSR_main(X,Y,ncomp,varNames,preprocessed,ortho,cv_style,nperm,yDataLabel)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This script performs PLS-R using the MATLAB built-in function,
%'plsregress'. Prior to calling 'plsregress', the data can be optionally
%orthogonalized.
%Model cross-validation (CV) is performed using built-in CV option
%of 'plsregress', and the mean squared error (MSE) is reported after
%CV. The user can choose from the following CV options using the 'cv_style' input:
        %K-fold CV with 'k' folds: {'k-fold',k}; 
        %Leave-one-out CV: {'loo'};
        %Venetian blinds CV: {[],[]}; (Work in progress)
%The function then runs a permutation test with 'nperm' permutations to
%test if the model accuracy score is a real effect or due to random chance.
%
%Model inputs and outputs are summarized in more detail below:
%
%INPUTS:
% X = X data, an nxm table or array of m variables/predictors and n observations 
% Y = Y data, an nx1 table or array of n observations and a univariate outcome
% varNames = names of the variables in X. If X is a table, varNames can
% be extracted from the column names of X if the input "preprocessed" is
% set to 'no'.
% cv_style = specify the style of cross validation (k_fold, loo)
% ortho = 'yes' or 'no': do you want your data to be orthogonalized before
% fitting a model? If 'yes', OPLS.m will be called and filtered X data will
% be used as input to plsregress.
% preprocessed = 'yes' or 'no': is your data already preprocessed (centered
% and scaled)? If 'no', preprocessing will be run, including centering and
% scaling and converting from a table to array, if need be.
%
%OUTPUTS:
% model = a structure with the following fields:
    %XLoadings,YLoadings = predictor and response loadings
    %XScores,YScores = predictor and response scores
    %BETA = matrix of coefficient estimates for PLSR
    %PCTVAR = percentage of variance explained by the regression model (first
    %row is variance in X, 2nd row is variance in Y)
    %MSE = estimated mean squared error after performing cross-validation
    %stats = contains PLS weights, T^2 statistic, and residuals
    %ncomp = number of components used to build the model.
    %Q2 = model prediction accuracy
    %R2 = model goodness-of-fit criteria
    %p_perm = the p-value output by the permutation test; see 'permtest.m'
    %for more details on how this is calculated and interpretation
    %varNames = names of the variables in X

close all;
%% Import data and optional pre-processing
%     X_pre_z = X; %X_pre_z is pre z-scored X data
%     X = zscore(X); Y = zscore(Y);
if strcmp(preprocessed,'no')

    %if X and Y are tables, extract variable names and convert them to
    %arrays
%     if class(X)=='table'
%         varNames = X.Properties.VariableNames;
%         X = table2array(X);
%     end
%     if class(Y)=='table'
%         Y = table2array(Y);
%     end

    %center and scale data
    X = zscore(X); Y = zscore(Y);

% tuning parameter selected using 5 fold cross validation
% repeat feature selection 100 times, only use features selected more than
% 80% of the time
lasso_feat = [];
for n = 1:100
    [b,fitInfo] = lasso(X,Y(:,1),'CV',5);
    [minMSE,idx] = min(fitInfo.MSE);
    lasso_feat = [lasso_feat; varNames(any(b(:,idx),2))];
end
%identify which LASSO features are selected, and how many times each was
%selected. Select the features that show up more than 80% of the time for
%downstream PLSDA model construction.
[unique_lasso_feat, ~, J]=unique(lasso_feat);
% varNames = unique_lasso_feat;
occ = histc(J, 1:numel(unique_lasso_feat));
[~,ia,~] = intersect(varNames,unique_lasso_feat(occ>50));
% [~,ia,~] = intersect(varNames,unique_lasso_feat);
X = X(:,ia); %subset X to only contain LASSO-selected features
varNames = varNames(ia)';
% varNames = unique_lasso_feat;
end
%% Orthogonal Projection to Latent Structures (OPLS)
if strcmp(ortho,'yes')
    tol = 0.00001;
    [X_filt] = OPLS(X,Y,tol);
    X = X_filt; %set X as the orthogonalized/filtered data

    % given a new data matrix to predict, apply the weights and loadings
    % corrected with the OSC filter
%         [nx,nw,np,nt] = osccalc(X,Y,10,[],[]);
%         X = nx;
    %     newx = nx - nx*nw*inv(np'*nw)*np';
end
%% Perform PLSR and cross-validation
clear TSS;
clear PLSR_XLoading PLSR_YLoading PLSR_XScore PLSR_YScore PLSR_yfit;
clear R2 Q2;

%select cross-validation style
if strcmp(cv_style{1},'kfold')
    k_fold = cv_style{2};
    cvp = cvpartition(height(X),'KFold',k_fold);

elseif strcmp(cv_style{1},'loo')
    cvp = cvpartition(height(X),'Leaveout');  
    
elseif strcmp(cv_style{1},'venetian')
end   

%calculate total sum of squares (TSS)
TSS = sum((Y-mean(Y)).^2);
%Call plsregress and perform cross validation
[XLoading,YLoading,XScore,YScore,BETA,PCTVAR,MSE,stats] = plsregress(X,Y,ncomp,'cv',cvp);
% Prediction accuracy based on cross validation
Q2 = [0 1-length(Y)*MSE(2,2:end)/TSS]; [Q2max,Q2idx] = max(Q2);
% Model performance
R2 = [0 cumsum(PCTVAR(2,:))];

%% Perform a permutation test and report the p-value
k_fold = 5;
p_perm = permtest(X,Y,ncomp,nperm,cvp,'empirical','PLSR');

%% Write output data structure
model.Xdata = X;
model.Ydata = Y;
model.XLoading = XLoading;
model.YLoading = YLoading;
model.XScore = XScore;
model.YScore = YScore;
model.beta = BETA;
model.PCTVAR = PCTVAR;
model.ncomp = ncomp;
model.Q2 = Q2max;
model.R2 = R2;
model.p_perm = p_perm;
model.varNames = varNames;
model.stats = stats;

%% Plot results
PLSR_plot(model,yDataLabel)
end

