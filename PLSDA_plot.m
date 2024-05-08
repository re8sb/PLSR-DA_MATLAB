function [vipScores,vipNames,pAdj,indAccepted]=PLSDA_plot(model,categories)
%% PLSDA plotting, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%INPUT:
%model: data structure containing model statistics, as output by PLSDA_main.
%categories: a cell array defining the names of the groups separated using
%discriminate analysis.
%
%OUTPUT:
%The following plots are generated:
%Scores plot: Scatter plot of X scores.
%Loadings plot: Two bar graphs of variable loadings on LV1 and LV2.
%VIP scores plot: A bar graph of VIP scores, colored by group.
%red/blue palette:
% palette = [68 210 242; 81 127 245]/255;
palette = [1 0 0;0 1 1];

%determine which group has the lowest mean Xscores value to assign colors.



%% loadings bar graph 
loadings_plot(model.XLoading,model.varNames,1,palette,'PLSDA');
%% VIP score calculation and plot
[vipScores,vipNames]=VIP(model.stats,model.XLoading,model.YLoading,model.XScore,model.varNames,palette,'all',[],model.Ydata);
%% scores plot (check name of model.CV_acc)
PLSR_or_PLSDA = 'PLSDA';
scores_plot(PLSR_or_PLSDA,model.XScore,model.PCTVAR,model.Ydata,model.CV_accuracy,model.CV_accuracy,model.p_perm,categories,palette);
%% univariate plots
[pAdj, indAccepted] = univar_plot(model.XpreZ,model.Ydata,categories,vipNames,vipScores,model.varNames,palette);
end
