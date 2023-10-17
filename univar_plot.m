function [pAdj, indAccepted] = univar_plot(X,Y,categories,vipNames,vipScores,varNames,palette)
%plot univariate swarmcharts/violin plots for top scoring VIP scores
%(VIP>1)
vipNames = flipud(vipNames);
figure; 
% nplots = length(vipScores(vipScores>1));
nplots = length(vipScores);
for n = 1:nplots
    subplot(3,ceil(nplots/3),n)

groups.g1 = X(Y(:,1)==1,strcmp(string(vipNames(n)),varNames));
groups.g2 = X(Y(:,1)==0,strcmp(string(vipNames(n)),varNames));

s = swarmchart(ones(1,length(groups.g1)),log(groups.g1),20,'o','markerfacecolor',...
    palette(2,:),'markeredgecolor','k','markerfacealpha',0.5); hold on
s.XJitter = 'density';
s.XJitterWidth = 0.5;
s = swarmchart(2*ones(1,length(groups.g2)),log(groups.g2),20,'o','markerfacecolor',...
    palette(1,:),'markeredgecolor','k','markerfacealpha',0.5);
s.XJitter = 'density';
s.XJitterWidth = 0.5;

scatter([1,2],[median(log(groups.g1)),median(log(groups.g2))],'o','markerfacecolor','w','markeredgecolor','k')

xticks([1 2]); xticklabels({categories{2},categories{1}})
ylabel(vipNames(n));
plot([0.8 1.2],[mean(log(groups.g1)) mean(log(groups.g1))],'-','linewidth',2,'color','k')
plot([1.8 2.2],[mean(log(groups.g2)) mean(log(groups.g2))],'-','linewidth',2,'color','k')
[h,p(n)]=ttest2(groups.g2,groups.g1,'Vartype','unequal');
%[p(n),h]=ranksum(groups.g1,groups.g2);
xlim([0.5 2.5])
title(append('p = ',num2str(p(n),'%0.3f')))
end
[pAdj, indAccepted] = findFDR(p, length(p), 0.05);

%figure
for n = 1:length(vipNames)
    subplot(3,ceil(nplots/3),n)
    
    groups.g1 = X(1:length(Y(Y(:,1)==1)),strcmp(string(vipNames(n)),varNames));
    groups.g2 = X((length(Y(Y(:,1)==1))+1):end,strcmp(string(vipNames(n)),varNames));

    %violinplot_SD(groups,{'Cd56+CD3-IFNy+','CD56+CD3-IFNy-'},'ShowData',logical(1),'ShowMean',logical(1));
    %xtickangle(45); ylabel(vipNames(n))
    %xticklabels(categories)
    %title(append('p = ',string(p(n))))
end

end

