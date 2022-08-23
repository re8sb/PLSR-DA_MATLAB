function p = permtest(X,Y,ncomp,nperm,cvp,significance,PLSR_or_PLSDA)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This function runs a permutation test of the cross-validated model
%resulting from 'plsregress' in PLSR_main.m or PLSDA_main.m.
%A CV partition (defined prior to calling 'plsregress' is used to
%cross-validate the model and determine the mean squared error (MSE) which
%will be used to compare randomly permutated models to the actual model.
%
%The permutation test runs like this over nperm iterations:
%1) Y is randomly suffled
%2) A new PLSR/DA model is evaluated, and MSE is saved
%3) 1) and 2) are repeated for nperm iterations
%4) A Wilcoxon signrank test or an empirically calculated p-value are
%computed
%
%INPUT:
%X: X data, needed to re-run model with random permutations. Should be
%pre-processed since this function is called within PLSR_main.m.
%Y: Y data, ".
%ncomp: number of components in the model.
%cvp: a cross-validation partition, defined in PLSR_main.m. Needed to
%cross-validate and determine mean squared error (MSE).
%significance: the method of determining model significance. This can take
%the value 'wilcoxon' or 'empirical'.
%
%'wilcoxon': For the Wilcoxon signrank test, a p-value < 0.05 indicates that the test failed 
%to reject the null hypothesis that the distribution of permutated MSE
%values comes from a distribution with median = MSE0. This means that the
%actual model'l precition power is most likely due to random chance.
%
%'empirical': To calculate an empirical p-value, MSE0 is compared to MSE_rand, and the
%percentage of times that MSE_rand is less than MSE0 is divided by the
%total number of permutations to get a significance level. An
%empirically-calculated p-value < 0.05 indicates that the actual model's
%prediction power is not due to random chance.
%
%OUTPUT: The resulting p-value and a histogram showing the distribution of MSE values 
%calculated by the permutation test compared to the actual MSE value
%(MSE0), which is indicated by a red '*'.

% c = cvpartition(height(X),'Kfold',cvp);

%compute the actual MSE
[XLoading,YLoading,XScore,YScore,BETA,PCTVAR,MSE,stats] = plsregress(X,Y,ncomp,'cv',cvp);
MSE0 = MSE(2,ncomp+1);
TSS = sum((Y-mean(Y)).^2);
Q20 = 1-length(Y)*MSE0/TSS(1); 

if strcmp(PLSR_or_PLSDA,'PLSDA')
Y_predicted = [ones(size(X,1),1) X]*BETA;
Y_predicted(Y_predicted<0.5) = 0; Y_predicted(Y_predicted>=0.5) = 1;
correct = 0;
for i = 1:length(Y)
    if Y(i) == Y_predicted(i)
        correct = correct + 1;
    end
end
CV_accuracy = correct/length(Y)*100; %correct classification rate
end

%run nperm permutations and save the MSE values to 'MSE_rand'
for n = 1:nperm
    if strcmp(PLSR_or_PLSDA,'PLSR')
        Y_rand = Y(randperm(length(Y)));
        CV_accuracy = [];
    elseif strcmp(PLSR_or_PLSDA,'PLSDA')
        Y_rand = Y(randperm(height(Y)))';
    end
clear XLoading YLoading XScore YScore BETA PCTVAR MSE stats Q2;
[XLoading,YLoading,XScore,YScore,BETA,PCTVAR,MSE,stats] = plsregress(X,Y_rand,ncomp,'cv',cvp);
% Q2 = [0 1-length(Y_rand)*MSE(2,2:end)/TSS];
% Q2_rand(n) = Q2(optimized_ncomp+1);
MSE_rand(n) = MSE(2,ncomp+1);
Q2_rand(n) = 1-length(Y)*MSE_rand(n)/TSS(1);

if strcmp(PLSR_or_PLSDA,'PLSDA')
%determine CV-accuracy by checking how often the model can properly
%discriminate into different groups
Y_predicted = [ones(size(X,1),1) X]*BETA;
Y_predicted(Y_predicted<0.5) = 0; Y_predicted(Y_predicted>=0.5) = 1;
correct = 0;
for i = 1:length(Y)
    if Y_rand(i) == Y_predicted(i)
        correct = correct + 1;
    end
end
CV_accuracy_rand(n) = correct/length(Y_rand)*100; %correct classification rate
end
end

% metric = 100*Q20; metric_rand = 100*Q2_rand;
metric = MSE0; metric_rand = MSE_rand;
% metric = CV_accuracy; metric_rand = CV_accuracy_rand;

%determine the type of p-value to calculate
if strcmp(significance,'wilcoxon')
    p = signrank(metric_rand,metric);
elseif strcmp(significance,'empirical')
    if metric == Q20*100 | metric == CV_accuracy
    p = (length(find(metric_rand > metric))+1) / (nperm+1);
    elseif metric == MSE0
    p = (length(find(abs(metric_rand) > abs(metric)))+1) / (nperm+1);
    if p >= 0.9
            p = (length(find(abs(metric_rand) < abs(metric)))+1) / (nperm+1);
    end
    end
end

%plot the histogram of MSEs, and report p-value in the title
figure; 
histogram([metric_rand,metric],100)
hold on; plot(metric,0,'r*','markersize',10)
title(append('Permutation Test (p = ',num2str(p,'%.3f'),')'))
ax = gca; ax.FontSize = 20;

end

