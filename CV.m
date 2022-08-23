function CV_accuracy = CV(type,X,Y,optimized_ncomp,k_fold,plottitle)
%% Perform 5-fold cross validation of the model
%Take 20% of the observations out, solve the model with the remaining 80%
%Calculate Q2 for each of the CV folds, take the average 
%A high mean Q2 indicates the model a robust model
%RE 6/15/2021
if type == 'kfold'
c = cvpartition(height(X),'Kfold',k_fold);
[new_XLoading,new_YLoading,new_XScore,new_YScore,new_BETA,new_PCTVAR,new_MSE,new_stats] = plsregress(X,Y,ncomp,'cv',c);
    TSS = sum((Y-mean(Y)).^2);
    Q2_new = [0 1-length(Y)*new_MSE(2,2:end)/TSS];
    Q2_new_max = max(Q2_new);
CV_accuracy = Q2_new_max;
elseif type ==
return

clear new_yfit
figure;
ncomp = optimized_ncomp;
for i = 1:k_fold
    clear cv_rows X_cv Y_cv %TSS new_XLoading new_YLoading new_XScore new_YScore new_BETA new_PCTVAR new_MSE new_stats
    
    cv_rows = randsample(1:height(X),c.TrainSize(i));
    
    if i == 1
    %use these 80% of the data to build a new model
    X_cv(1:length(cv_rows),:) = X(cv_rows,:);
    Y_cv(1:length(cv_rows)) = Y(cv_rows); 
    %these 20% of the data will be predicted using the CV model
    X_predicted(1:length(setdiff(1:height(X),cv_rows)),:) = X(setdiff(1:height(X),cv_rows),:);
    Y_predicted(1:length(setdiff(1:height(Y),cv_rows))) = Y(setdiff(1:height(Y),cv_rows));
    else
    X_cv(height(X_cv)+1:length(cv_rows),:) = X(cv_rows,:);
    Y_cv(height(Y_cv)+1:length(cv_rows)) = Y(cv_rows)';
    %these 20% of the data will be predicted using the CV model
    X_predicted(height(X_cv)+1:length(cv_rows),:) = X(setdiff(1:height(X),cv_rows),:);
    Y_predicted(height(Y_cv)+1:length(cv_rows)) = Y(setdiff(1:height(Y),cv_rows));
    end
    
    [new_XLoading,new_YLoading,new_XScore,new_YScore,new_BETA,new_PCTVAR,new_MSE,new_stats] = plsregress(X_cv,Y_cv,ncomp);
        %determine cross validation accuracy 
    TSS = sum((Y_predicted-mean(Y_predicted)).^2);
    Q2_new = [0 1-length(Y_predicted)*new_MSE(2,2:end)/TSS];
    Q2_new_max(i) = max(Q2_new);
    
    for j = 1:height(X_predicted)
    new_yfit(j,i) = [ones(size(X_predicted(j,:),1),1) X_predicted(j,:)]*new_BETA;
    end

end

    
    %figure; % Visualize correlation between measured and predicted responses (through leave-one-out cross-validation)
hold on;
row = 0;
for subject_id = 1:length(Y_predicted)
        row = row + 1;
        plot(Y_predicted(row),new_yfit(row,i),'linestyle','none','marker','o','markerfacecolor','#77F8FF','markeredgecolor','k');
end
 plot([-10 10],[-10 10],'linestyle','-','linewidth',1,'color','k');
set(gca,'fontsize',20);


%report 5-fold CV accuracy
CV_accuracy = mean(Q2_new_max)*100;
title(append(plottitle,' (CV acc = ',num2str(CV_accuracy,'%.0f'),'%)'));
xlabel('Measured'); ylabel('Predicted');
% dim = 10;
% xlim([-dim dim]); ylim([-dim dim])
end

