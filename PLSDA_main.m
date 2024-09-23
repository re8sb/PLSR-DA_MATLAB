function model = PLSDA_main(X,Y,ncomp,varNames,LASSO,ortho,cv_style,nperm,categories,palette)
%% PLSDA framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/15/2021
%This script performs PLS-DA using the MATLAB built-in function,
%'plsregress'. Prior to calling 'plsregress', the data can be optionally
%orthogonalized.
%Model cross-validation (CV) is performed using built-in CV option
%of 'plsregress', and the mean squared error (MSE) is reported after
%CV. The user can choose from the following CV options using the 'cv_style' input:
        %K-fold CV with 'k' folds: {'kfold',k}; 
        %Leave-one-out CV: {'loo'};
%The function then calls 'permtest' to run a permutation test to
%test if the model accuracy score is a real effect or due to random chance.
%
%Model inputs and outputs are summarized in more detail below:
%
%INPUTS:
% X = X data, an nxm array of m variables/predictors and n
% observations (raw data acceptable).
% Y = Y data, an nxp table or array of n observations and p discriminate
% groups, defined as logical columns with value '1' if that observation is
% a member of the group and '0' if the observation is not a member.
% varNames = names of the variables in X. If X is a table, varNames can
% be extracted from the column names of X if the input "preprocessed" is
% set to 'no'.
% cv_style = specify the style of cross validation (kfold, loo)
% LASSO = would you like to perform LASSO feature selection?
% ortho = 'yes' or 'no': do you want your data to be orthogonalized before
% fitting a model? If 'yes', OPLS.m will be called and filtered X data will
% be used as input to plsregress.
% palette = an array of RGB color triplets to use for plotting (nx3)
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
    %CV_accuracy = model prediction accuracy (it's success rate at
    %predicting the group membership of each observation after CV)
    %R2 = model goodness-of-fit criteria
    %p_perm = the p-value output by the permutation test; see 'permtest.m'
    %for more details on how this is calculated and interpretation
    %varNames = names of the variables in X

close all;
%% Import data and optional LASSO feature selection
    X_pre_z = X; %X_pre_z is pre z-scored X data
    X = zscore(X);

if strcmp(LASSO,'yes')
% Perform LASSO feature selection.
% Run a 10-fold cross validated LASSO regression and save the feature set
% with the lowest mean squared error.

varNames_old = varNames;
clear lasso_feat b fitInfo minMSE minMSE_Lambda
for n = 1:100
    n
    [b,fitInfo] = lasso(X,Y(:,1),'CV',10);
    [minMSE(n),idx] = min(fitInfo.MSE);
    lasso_feat(:,n) = b(:,idx);
%     lasso_feat = [lasso_feat; varNames(any(b(:,idx),2))];
end
% [~,idx]=min(minMSE);
% varNames = varNames_old(any(lasso_feat(:,idx),2));
varNames = varNames_old(sum(logical(lasso_feat),2)>=0.9*width(lasso_feat));
[~,ia,~] = intersect(varNames_old,varNames);
varNames = varNames_old(ia); %reorders varNames to match order in X
X = X(:,ia); %subset X to only contain LASSO-selected features
X_pre_z = X_pre_z(:,ia); %subset X_pre_z to only LASSO-selected features
end
%% Orthogonal Projection to Latent Structures (OPLS)
if strcmp(ortho,'yes')
    tol = 0.01;
    [X_filt] = OPLS(X,Y,tol); %optionally output X_ortho as well
    X = X_filt;
end
%% Perform PLSDA and calculate CV accuracy.
clear TSS PLSR_XLoading PLSR_YLoading PLSR_XScore PLSR_YScore PLSR_yfit;
clear R2 Q2;

%select cross-validation style
if strcmp(cv_style{1},'kfold')
    k_fold = cv_style{2};
    cvp = cvpartition(height(X),'KFold',k_fold);
elseif strcmp(cv_style{1},'loo')
    cvp = cvpartition(height(X),'Leaveout');  
end   

%Calculate total sum of squares (TSS)
TSS = sum((Y-mean(Y)).^2);

%Call plsregess using the CV method defined above
[XLoading,YLoading,XScore,YScore,BETA,PCTVAR,MSE,stats] = plsregress(X,Y,ncomp,'cv',cvp);
% Prediction accuracy based on cross validation
Q2 = [0 1-length(Y)*MSE(2,2:end)/TSS]; [Q2max,Q2idx] = max(Q2);

% Performance
R2 = [0 cumsum(PCTVAR(2,:))];

%determine CV-accuracy (how well can my model classify into groups?)
%predicted Y categories based on the cross-validated model
Y_predicted = [ones(size(X,1),1) X]*BETA;
%if prediction < 0.5, make it a logical 0; if > 0.5, make it a logical 1
Y_predicted(Y_predicted<0.5) = 0; Y_predicted(Y_predicted>=0.5) = 1;

correct = 0;
for i = 1:length(Y)
    if Y(i) == Y_predicted(i)
        correct = correct + 1; %If prediction and actual label match, increase count of "correct" assignments.
    end
end
CV_accuracy = correct/length(Y)*100; %correct classification rate
%% permutation testing 
p_perm = permtest(X,Y,ncomp,nperm,cvp,'empirical','PLSDA',CV_accuracy);

%% write output structure
model.Xdata = X;
model.Ydata = Y;
model.XLoading = XLoading;
model.YLoading = YLoading;
model.XScore = XScore;
model.YScore = YScore;
model.beta = BETA;
model.PCTVAR = PCTVAR;
model.ncomp = ncomp;
model.CV_accuracy = CV_accuracy;
model.R2 = R2;
model.p_perm = p_perm;
model.varNames = varNames;
model.stats = stats;
model.MSE = MSE(2,ncomp+1);
model.XpreZ = X_pre_z;

model.palette = palette;
%% plot results (scores plot, loadings plot, VIP scores)
[model.vipScores,model.vipNames,model.pAdjBH, model.indAccBH, model.univar_pvals] = PLSDA_plot(model,categories)
