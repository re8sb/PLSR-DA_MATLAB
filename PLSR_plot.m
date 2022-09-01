function PLSR_plot(model,YDataLabel)
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
palette =[90 66 56;255 190 143]/255;

%% scores plot 
PLSR_or_PLSDA = 'PLSR';
scores_plot(PLSR_or_PLSDA,model.XScore,model.PCTVAR,model.Ydata,YDataLabel,model.Q2,model.p_perm,[]);
%% loadings bar graph 
% loadings_plot(model.XLoading,model.varNames,1,palette,'PLSR');
%% VIP score bar graph
VIP(model.stats,model.XLoading,model.YLoading,model.XScore,model.varNames,palette,'all',[]);
end

