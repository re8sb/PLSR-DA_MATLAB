%% Biplot
%% This function creates a bioplot (combined scores and loadings plot) for a multiclass PLSDA model
figure
clrs = {'y','c','r'};
xline(0,'handlevisibility','off');yline(0,'handlevisibility','off'); hold on
scatter(XScore(Y==1,1),XScore(Y==1,2),50,'o','markerfacecolor',clrs{1}, 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',0.5);    
scatter(XScore(Y==2,1),XScore(Y==2,2),50,'o','markerfacecolor',clrs{2}, 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',0.5);    
scatter(XScore(Y==3,1),XScore(Y==3,2),50,'o','markerfacecolor',clrs{3}, 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',0.5);    


xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,1),'%.0f'),'%)')); 
    ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,2),'%.0f'),'%)')); 
%     xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%)')); 
%     ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%)')); 
% title({append('X scores',' (CV acc. = ',num2str(Q2,'%.0f'),'%)');...
%         append('p = ',num2str(p_perm,'%.3f'))}); set(gca,'fontsize',16); 
title(append('X scores',' (CV acc. = ',num2str(CV_accuracy,'%.0f'),'%, p = ',num2str(p_perm,'%.3f'),')')); set(gca,'fontsize',16); 

    legend(categories,'location','northeast')

%% compute VIP scores (show features with VIP scores > 1 on loadings plot)
W0 = stats.W ./ sqrt(sum(stats.W.^2,1));
p = size(XLoading,1);
sumSq = sum(XScore.^2,1).*sum(YLoading.^2,1);
[vipScore,idx] = sort(sqrt(p* sum(sumSq.*(W0.^2),2) ./ sum(sumSq,2)),'ascend');
vipNames = varNames(idx); XLoading_plot = XLoading(idx,:);
% vipNames = vipNames(vipScore>=1); XLoading_plot = XLoading_plot(vipScore>=1,:);

% scatter(XLoading_plot(:,1)/5,XLoading_plot(:,2)/5,'k','*','handlevisibility','off')
% text(XLoading_plot(:,1)/5+0.015,XLoading_plot(:,2)/5-0.015,vipNames)

    [~,idx] = sortrows(abs(XLoading(:,1)));
    XL_LV1 = table(varNames(idx),XLoading(idx,1));
    XL_LV1.Properties.VariableNames = {'Variable','Loading'};
    figure; b = barh(table2array(XL_LV1(:,2)),'facecolor',[0.5 0.5 0.5]); title('Loadings on LV1','fontsize',14)
yticks([1:length(XL_LV1.Variable)]); 
yticklabels(string(XL_LV1.Variable)); set(gca,'fontsize',16); %xlim([-5 5])
% ytickangle(45)
% ax.FontSize = 10

%% violin plots
figure; clrs = [1 1 0;0 1 1;1 0 0];
for n = 1:length(varNames) 
nexttile; 
groups.g1 = X_pre_z(Y==1,strcmp(string(vipNames(n)),varNames))*100;
groups.g2 = X_pre_z(Y==2,strcmp(string(vipNames(n)),varNames))*100;
groups.g3 = X_pre_z(Y==3,strcmp(string(vipNames(n)),varNames))*100;

b = bar(1,median(groups.g1)); hold on; b.EdgeColor = 'k';  b.FaceColor = clrs(1,:);b.FaceAlpha=0.4; 
b = bar(2,median(groups.g2)); hold on; b.EdgeColor = 'k'; b.FaceColor = clrs(2,:);b.FaceAlpha=0.4;
b = bar(3,median(groups.g3)); hold on; b.EdgeColor = 'k'; b.FaceColor = clrs(3,:);b.FaceAlpha=0.4;

s = swarmchart(ones(1,length(groups.g1)),groups.g1,20,'o','markeredgecolor','none','markerfacecolor','k','MarkerEdgeAlpha',0.2,'MarkerFaceAlpha',0.5);
s.XJitter = 'density'; s.XJitterWidth = 0.5;
s = swarmchart(2*ones(1,length(groups.g2)),groups.g2,20,'o','markeredgecolor','none','markerfacecolor','k','MarkerEdgeAlpha',0.2,'MarkerFaceAlpha',0.5);
s.XJitter = 'density'; s.XJitterWidth = 0.5;
s = swarmchart(3*ones(1,length(groups.g3)),groups.g3,20,'o','markeredgecolor','none','markerfacecolor','k','MarkerEdgeAlpha',0.2,'MarkerFaceAlpha',0.5);
s.XJitter = 'density'; s.XJitterWidth = 0.5;

xticks([1:3]); xticklabels({'T1','T2','T3'});
ylabel(vipNames(n)); 
% title(append('p = ',string(model_igg.univar_pvals(n))))

end