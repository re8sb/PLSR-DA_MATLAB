%% Biplot
%% This function creates a bioplot (combined scores and loadings plot) for a multiclass PLSDA model
figure
clrs = {'b','k','y'};
xline(0,'handlevisibility','off');yline(0,'handlevisibility','off'); hold on
scatter(model_ga.XScore(Y==1,1),model_ga.XScore(Y==1,2),50,'^','markerfacecolor',clrs{1}, 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',1);    
scatter(model_ga.XScore(Y==2,1),model_ga.XScore(Y==2,2),75,'s','markerfacecolor','none', 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',1);    
scatter(model_ga.XScore(Y==3,1),model_ga.XScore(Y==3,2),50,'o','markerfacecolor',clrs{3}, 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',1);    

xlabel(append('LV1',' (X_{var} = ',num2str(100*model_ga.PCTVAR(1,1),'%.0f'),'%, Y_{var} = ',num2str(100*model_ga.PCTVAR(2,1),'%.0f'),'%)')); 
    ylabel(append('LV2',' (X_{var} = ',num2str(100*model_ga.PCTVAR(1,2),'%.0f'),'%, Y_{var} = ',num2str(100*model_ga.PCTVAR(2,2),'%.0f'),'%)')); 
%     xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%)')); 
%     ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%)')); 
% title({append('X scores',' (CV acc. = ',num2str(Q2,'%.0f'),'%)');...
%         append('p = ',num2str(p_perm,'%.3f'))}); set(gca,'fontsize',16); 
title(append('X scores',' (CV acc. = ',num2str(model_ga.CV_accuracy,'%.0f'),'%, p = ',num2str(model_ga.p_perm,'%.3f'),')')); set(gca,'fontsize',16); 

    legend(categories,'location','northeast')

% scatter(model_ga.XLoading(:,1)/10,model_ga.XLoading(:,2)/10,'*','markeredgecolor','k')
% %% compute VIP scores (show features with VIP scores > 1 on loadings plot)
% W0 = model_ga.stats.W ./ sqrt(sum(model_ga.stats.W.^2,1));
% p = size(model_ga.XLoading,1);
% sumSq = sum(model_ga.XScore.^2,1).*sum(model_ga.YLoading.^2,1);
% [vipScore,idx] = sort(sqrt(p* sum(sumSq.*(W0.^2),2) ./ sum(sumSq,2)),'ascend');
% vipScore(model_ga.XLoading(:,1)<0)=-vipScore(model_ga.XLoading(:,1)<0);
% vipNames = model_ga.varNames(idx); XLoading_plot = model_ga.XLoading(idx,:);
% % vipNames = vipNames(vipScore>=1); XLoading_plot = XLoading_plot(vipScore>=1,:);
% % figure; %xline(1,'k--'); hold on
% % xline(-1,'k--');
% % b = barh(vipScore,'facecolor',[0.5 0.5 0.5]); title('VIP Scores','fontsize',14)
% figure
% [sort_loadings,idx] = sort(model_ga.XLoading(:,1),'descend');
% b = barh(sort_loadings,'facecolor',[0.5 0.5 0.5]); title('Loadings on LV1','fontsize',14)
% yticks([1:length(varNames)]);yticklabels(string(varNames(idx))); set(gca,'fontsize',16); %xlim([-5 5])
% 
% yticks([1:length(vipNames)]); 
% % yticklabels(string(vipNames)); set(gca,'fontsize',16); %xlim([-5 5])
% 
% % scatter(XLoading_plot(:,1)/5,XLoading_plot(:,2)/5,'k','*','handlevisibility','off')
% % text(XLoading_plot(:,1)/5+0.015,XLoading_plot(:,2)/5-0.015,vipNames)
% 
%     [~,idx] = sortrows(abs(XLoading(:,2)));
%     XL_LV1 = table(varNames(idx),XLoading(idx,1));
%     XL_LV1.Properties.VariableNames = {'Variable','Loading'};
%     figure; b = barh(table2array(XL_LV1(:,2)),'facecolor',[0.5 0.5 0.5]); title('Loadings on LV2','fontsize',14)
% yticks([1:length(XL_LV1.Variable)]); 
% yticklabels(string(XL_LV1.Variable)); set(gca,'fontsize',16); %xlim([-5 5])
% ytickangle(45)
% ax.FontSize = 10
% vipNames = flipud(vipNames);
% %% violin plots
% figure; %clrs = [1 1 0;0 1 1;1 0 0];
% % model_ga.vipNames = flipud(model_ga.vipNames);
% for n = 1:length(vipNames) 
% nexttile; 
% groups.g1 = model_ga.XpreZ(Y==1,strcmp(string(vipNames(n)),varNames));
% groups.g2 = model_ga.XpreZ(Y==2,strcmp(string(vipNames(n)),varNames));
% groups.g3 = model_ga.XpreZ(Y==3,strcmp(string(vipNames(n)),varNames));
% 
% b = bar(1,median(groups.g1)); hold on; b.EdgeColor = 'k';  b.FaceColor = 'w';b.FaceAlpha=0.4; 
% b = bar(2,median(groups.g2)); hold on; b.EdgeColor = 'k'; b.FaceColor = 'w';b.FaceAlpha=0.4;
% b = bar(3,median(groups.g3)); hold on; b.EdgeColor = 'k'; b.FaceColor = 'w';b.FaceAlpha=0.4;
% 
% s = swarmchart(ones(1,length(groups.g1)),groups.g1,50,'^','markeredgecolor','k','markerfacecolor',clrs{1},'MarkerEdgeAlpha',1,'MarkerFaceAlpha',0.5); hold on
% s.XJitter = 'density'; s.XJitterWidth = 0.5;
% s = swarmchart(2*ones(1,length(groups.g2)),groups.g2,50,'s','markeredgecolor','k','markerfacecolor','none','MarkerEdgeAlpha',1,'MarkerFaceAlpha',0.5);
% s.XJitter = 'density'; s.XJitterWidth = 0.5;
% s = swarmchart(3*ones(1,length(groups.g3)),groups.g3,50,'o','markeredgecolor','k','markerfacecolor',clrs{3},'MarkerEdgeAlpha',1,'MarkerFaceAlpha',0.5);
% s.XJitter = 'density'; s.XJitterWidth = 0.5;
% 
% xticks([1:3]); xticklabels(categories);
% ylabel(vipNames(n)); 
% % title(append('p = ',string(model_igg.univar_pvals(n))))
% 
% % [~,~,stats]=kruskalwallis([groups.g1;groups.g2;groups.g3],Y);
% % c=multcompare(stats,'CriticalValueType','dunn-sidak');
% % pvals(:,n)=c(:,6);
% ylim([0 115])
% end