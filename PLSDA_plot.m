<<<<<<< Updated upstream
function [vipScores,vipNames,pAdj,indAccepted,pvals]=PLSDA_plot(model,categories)
=======
function [vipScores,vipNames,pAdj,indAccepted,pVal]=PLSDA_plot(model,categories)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
%red/blue palette:
palette = [68 210 242; 81 127 245]/255;
=======
% if no palette is given, assign a color scheme.
% if model.palette == []
%     palette = [1 0 1; 0 1 0];
%     palette = [0 0 1 ;0 1 0];
%     palette = [0 0 1;1 0 1];
% else
    palette = model.palette;
% end
>>>>>>> Stashed changes
%determine which group has the lowest mean Xscores value to assign colors.

PLSR_or_PLSDA = 'PLSDA';

%% VIP score calculation and plot
[vipScores,vipNames]=VIP(model.stats,model.XLoading,model.YLoading,model.XScore,model.varNames,palette,'all',[],model.Ydata,'PLSDA');
% VIP(stats,XLoading,YLoading,XScore,varNames,palette,whichScores,plotThresh,Y,PLSR_or_PLSDA)
%% univariate plots
[pAdj, indAccepted,pVal] = univar_plot(model.XpreZ,model.Ydata,categories,vipNames,vipScores,model.varNames,palette);

if model.ncomp == 2

%% loadings bar graph 
loadings_plot(model.XLoading,model.varNames,1,palette,'PLSDA');

%% scores plot (check name of model.CV_acc)
<<<<<<< Updated upstream
PLSR_or_PLSDA = 'PLSDA';
scores_plot(PLSR_or_PLSDA,model.XScore,model.PCTVAR,model.Ydata,model.CV_accuracy,model.CV_accuracy,model.p_perm,categories,palette);
%% univariate plots
[pAdj, indAccepted, pvals] = univar_plot(model.XpreZ,model.Ydata,categories,vipNames,vipScores,model.varNames);
=======
scores_plot(PLSR_or_PLSDA,model.XScore,model.PCTVAR,model.Ydata,model.CV_accuracy,model.p_perm,categories,palette);

else

plsda_biplot(model.XScore,model.PCTVAR,model.Ydata,categories,model.CV_accuracy,model.p_perm,palette,model.XLoading,model.varNames)

end


>>>>>>> Stashed changes
end
