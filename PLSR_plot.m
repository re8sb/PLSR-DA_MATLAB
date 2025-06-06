
function [vipScores,vipNames,rho,pval]=PLSR_plot(model,YDataLabel,LASSO)

%% PLSR plotting, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%INPUT:
%model: data structure containing model statistics, as output by PLSR_main.
%scores_colorbar_label: a descriptive title of Y, which will be used to label the
%colorbar on the scores plot (scores plot is colored according to values in
%Y).
%
%OUTPUT:
%The following plots are generated:
%Scores plot: Scatter plot of X scores.
%Loadings plot: Two bar graphs of variable loadings on LV1 and LV2.
%VIP scores plot: A bar graph of VIP scores, colored and arranged in the
%direction of loadings on LV1 or LV2.

% palette = {'#4D3C29';'#705D49';'#C2905F';'#DBA46E';'#EBC9A7'};

%palette for MATLAB SPRING colormap
% palette =[32, 133, 51; 98 242 58; 167 219 64; 250 244 73; 232 203 56]/255;
% palette for MATLAB COPPER colormap
% palette =[90 66 56;255 190 143]/255;

% pretty orange
% mincolor = [249 119 72]/255; maxcolor = [249 240 172]/255;
% maxcolor = [252 252 245]/255; mincolor = [124 80 80]/255;
% maxcolor = [249 119 72]/255; mincolor = [249 240 172]/255;

% maxcolor = [119 104 250]/255; mincolor = [224 222 255]/255;
% maxcolor = [204 102 255]/255; mincolor = [224 222 255]/255;
% maxcolor = [119 104 250]/255; mincolor = [224 222 255]/255;
%white and yellow
% maxcolor = [255 255 0]/255; mincolor = [255 255 255]/255;
% blue to yellow
% maxcolor =  [255 255 0]/255; mincolor = [135 205 233]/255;
%white and orange
% mincolor = [255 255 255]/255; maxcolor = [249 119 72]/255;
% blue to orange
maxcolor =  [249 119 72]/255; mincolor = [135 205 233]/255;

palette = [mincolor;maxcolor];
%% scores plot 
PLSR_or_PLSDA = 'PLSR';
scores_plot(PLSR_or_PLSDA,model.XScore,model.PCTVAR,model.Ydata,YDataLabel,model.Q2,model.p_perm,[],palette);

%% VIP score bar graph
[vipScores,vipNames]=VIP(model.stats,model.XLoading,model.YLoading,model.XScore,model.varNames,palette,'all',[],[],'PLSR');

%% loadings bar graph 
% loadings_plot(model.XLoading,model.varNames,1,palette,'PLSR');

%% Correlates heatmap
if strcmp(LASSO,'yes')
    [rho,pval]=correlatesHeatmap(model.X_pre_z_total,model.X_pre_z,model.varNames_old,model.varNames)
else
    rho=nan; pval=nan;
end

end

