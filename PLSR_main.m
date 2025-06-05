function model = PLSR_main(X,Y,ncomp,varNames,LASSO,ortho,cv_style,nperm,yDataLabel)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This script performs PLS-R using the MATLAB built-in function,
%'plsregress'. Prior to calling 'plsregress', the data can be optionally
%orthogonalized.
%Model cross-validation (CV) is performed using built-in CV option
%of 'plsregress', and the mean squared error (MSE) is reported after
%CV. The user can choose from the following CV options using the 'cv_style' input:
        %K-fold CV with 'k' folds: {'kfold',k}; 
        %Leave-one-out CV: {'loo'};
%The function then runs a permutation test with 'nperm' permutations to
%test if the model accuracy score is a real effect or due to random chance.
%
%Model inputs and outputs are summarized in more detail below:
%
%INPUTS:
% X = X data, an [nxm] array of m variables/predictors and n observations 
% Y = Y data, an [nx1] table or array of n observations and a univariate outcome
% varNames = names of the variables in X, specified as an {1xm} cell array.
% cv_style = specify the style of cross validation (kfold, loo)
% ortho = 'yes' or 'no': do you want your data to be orthogonalized before
% fitting a model? If 'yes', OPLS.m will be called and filtered X data will
% be used as input to plsregress.
% nperm = number of null models (permutations) to run.
% yDataLabel = A name for the Y variable, specified as a 'string'.

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
%% Import data and optional LASSO-feature selection
X_pre_z_total = X; %X_pre_z is pre z-scored X data
X = zscore(X); %Y = zscore(Y);

varNames_old = varNames;
clear lasso_feat b fitInfo minMSE minMSE_Lambda
if strcmp(LASSO,'yes')

[varNames,ia] = run_elastic_net(X, Y, varNames_old, 'minMSE', 0.1, 200, 0.7, cv_style{2});
   % 
   % lasso_feat = [];
   %  for n = 1:100
   %      [b,fitInfo] = lasso(X,Y,'CV',5);%10
   %      [minMSE(n),idx] = min(fitInfo.MSE);
   %      lasso_feat(:,n) = b(:,idx);
   %  end
   %  [~,idx]=min(minMSE);
   %  varNames = varNames_old(any(lasso_feat(:,idx),2));
   %  [~,ia,~] = intersect(varNames_old,varNames);
    X = X(:,ia); %subset X to only contain LASSO-selected features
    X_pre_z = X_pre_z_total(:,ia); %subset X_pre_z to only LASSO-selected features
    % X = X(:,elastic_idx); 
    % X_pre_z = X_pre_z_total(:,elastic_idx); %subset X_pre_z to only LASSO-selected features
    model.X_pre_z_total = X_pre_z_total;
    model.varNames_old = varNames_old;
    model.lasso_idx = ia;
    model.X_pre_z = X_pre_z;

end
%% Orthogonal Projection to Latent Structures (OPLS)
if strcmp(ortho,'yes')
    tol = 0.1;
    [X_filt] = OPLS(X,Y,tol);
    X = X_filt; %set X as the orthogonalized/filtered data
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
if strcmp(LASSO,'yes')
[model.vipScores,model.vipNames,model.rho,model.pval]=PLSR_plot(model,yDataLabel,LASSO)
else
[model.vipScores,model.vipNames,model.rho,model.pval]=PLSR_plot(model,yDataLabel,LASSO)
end 
end

