function loadings_plot(XLoading,varNames,nLVs,palette,PLSR_or_PLSDA)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This function plots the X loadings of each variable on LV1 and LV2 as a pair
%of bar graphs.
%Loadings are linear combinations of variables that define each LV.
%Therefore, a loadings plot is useful to interpret how each variable contributes
%to the covariance in X and Y in the direction of that LV.
%
%INPUT:
%XLoading: The loadings of each variable in X along LV1 and LV2. This is
%output from PLSR_main.m as model.XLoading.
%varNames: The variable names, used to label the bars of the bar graph.
%nLVs: The number of LV-bar graphs to plot. Usually will be 2, if a
%2-componeny model is used.
%palette: The colors used to plot bars. Defined within PLSR_plot.m.

%Subplot bar graph for LV1 and LV2 together if the user specifies nLV >=2.
if nLVs >= 2
XL_LV1 = sortrows(table(varNames',XLoading(:,1)),'Var2','ascend');
XL_LV2 = sortrows(table(varNames',XLoading(:,2)),'Var2','ascend');

figure; subplot(2,1,1); b = barh(table2array(XL_LV1(:,2)),'facecolor',palette(1,:)); title('Loadings on LV1','fontsize',14)

yticks([1:length(XL_LV1.Var1)]); 
yticklabels(XL_LV1.Var1); set(gca,'fontsize',12); %xlim([-5 5])
ytickangle(45)
% ax.FontSize = 10

subplot(2,1,2); b = barh(table2array(XL_LV2(:,2)),'facecolor',palette(1,:)); title('Loadings on LV2','fontsize',14)
yticks([1:length(varNames)])
yticklabels(XL_LV2.Var1); set(gca,'fontsize',12); %xlim([-5 5])
ytickangle(45)
% ax.FontSize = 10

%If the user specifies nLVs = 1, then don't subplot, and just plot the LV1
%loadings.
elseif nLVs == 1
    if strcmp(PLSR_or_PLSDA,'PLSR')
        XL_LV1 = sortrows(table(varNames,XLoading(:,1)'),'Var2','ascend');
    elseif strcmp(PLSR_or_PLSDA,'PLSDA')
        XL_LV1 = sortrows(table(varNames,XLoading(:,1)),'Var2','ascend');
    end
    XL_LV1.Properties.VariableNames = {'Variable','Loading'};
    figure; b = barh(table2array(XL_LV1(:,2)),'facecolor',palette(1,:)); title('Loadings on LV1','fontsize',14)
yticks([1:length(XL_LV1.Variable)]); 
yticklabels(string(XL_LV1.Variable)); set(gca,'fontsize',16); %xlim([-5 5])
% ytickangle(45)
% ax.FontSize = 10
end

end

