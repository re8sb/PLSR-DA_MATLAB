function [rho,rho_pval] = correlatesHeatmap(full_X_data,sub_X_data,varNames_old,varNames)
%This function plots co-correlates heatmap when LASSO is used for feature
%selection.

[rho,pval]=corr([full_X_data, sub_X_data],'type','Pearson');

rho = rho((length(full_X_data)+1):end,1:length(full_X_data)); rho(isnan(rho))=0;
rho_pval = pval((length(full_X_data)+1):end,1:length(full_X_data));
rho(rho_pval>0.05)=0;

%subset to just significant correlations
collabels= varNames_old; collabels = collabels(any(rho));
rowlabels = varNames; rowlabels = rowlabels(any(rho,2));
rho = rho(any(rho,2),any(rho));

maxcolor2 = [0.75 0.1 0];  maxcolor1 = [0 0.5 0.75]; 
maxcolor1_range = [linspace(maxcolor1(1),1, 128)', linspace(maxcolor1(2),1, 128)', linspace(maxcolor1(3),1, 128)'];
maxcolor2_range = [linspace(1, maxcolor2(1), 128)', linspace(1, maxcolor2(2), 128)', linspace(1, maxcolor2(3), 128)'];
cmap = [maxcolor1_range;maxcolor2_range]; 
clust = clustergram(rho,'imputefun',@knnimpute,'Colormap',cmap,'columnlabels',collabels,'rowlabels',rowlabels,'cluster','all');
% figure
% clust = heatmap(collabels,rowlabels,rho,'Colormap',cmap);
% caxis([-1 1]); 
% clust = heatmap(collabels,rowlabels,rho,'Colormap',cmap);
% caxis([-1 1]); title('T1')
% 

end