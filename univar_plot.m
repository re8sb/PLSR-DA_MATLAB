function [pAdj, indAccepted,p] = univar_plot(X,Y,categories,vipNames,vipScores,varNames,palette)
%plot univariate swarmcharts/violin plots for top scoring VIP scores
%(VIP>1)
vipNames = flipud(vipNames);
figure; 
% nplots = length(vipScores(vipScores>1));
nplots = length(vipScores);

for i = 1:width(Y)
 Ygroup(Y(:,i)==1)=i; 
end 
Ygroup = Ygroup';
% Ygroup=Y;

for n = 1:nplots
    nexttile
    % subplot(3,ceil(nplots/3))

    for m = 1:width(Y)
        group = X(Y(:,m)==1,strcmp(string(vipNames(n)),varNames));

        boxchart(m*ones(1,height(group)),group,'markerstyle','none','boxfacecolor',palette(m,:),'boxedgecolor','k','boxwidth',1); hold on

        % b = bar(m,median(group)); hold on; b.EdgeColor = 'k';  b.FaceColor = 'w';b.FaceAlpha=0.4; 
        s = swarmchart(ones(1,length(group))*m,group,20,'o','markerfacecolor',...
            palette(m,:),'markeredgecolor','k','markerfacealpha',0.5);
        s.XJitter = 'density';
        s.XJitterWidth = 0.5;
        
        % scatter(m,mean((group)),100,'_','markerfacecolor','none','markeredgecolor','k','linewidth',2)
        % plot([m-0.2 m+0.2],mean((group)),'-','linewidth',2,'color','k')

    end
        xticks([1:1:m]); xticklabels(categories)
        ylabel(vipNames(n));
        xlim([0 m+1])

    if m == 2 % use a t-test to compare 2 groups
        [h,p(n)]=ttest2(X(Y(:,1)==1,strcmp(string(vipNames(n)),varNames)),...
            X(Y(:,2)==1,strcmp(string(vipNames(n)),varNames)),'Vartype','unequal');
        %[p(n),h]=ranksum(groups.g1,groups.g2);
        title(append('p = ',num2str(p(n),'%0.3f')))
                [pAdj, indAccepted] = findFDR(p, length(p), 0.05);

    elseif m > 2 % use a kruskalwallis test to compare multiple groups
        % make a group variable
        [~,~,stats]=kruskalwallis(X(:,strcmp(string(vipNames(n)),varNames)),Ygroup,'off');
        c=multcompare(stats,'CriticalValueType','dunn-sidak','Display','off');
        p(:,n)=c(:,6);
        pAdj = ''; indAccepted = '';
    end        

        %     [~,~,stats]=kruskalwallis(X(:,n),Ygroup,'off');
        % c=multcompare(stats,'CriticalValueType','dunn-sidak','Display','off');
        % p(:,n)=c(:,6);
        % pAdj = ''; indAccepted = '';

 end
% 
% s = swarmchart(ones(1,length(groups.g1)),(groups.g1),20,'o','markerfacecolor',...
%     [81 127 245]/255,'markeredgecolor','k'); hold on
% s.XJitter = 'density';
% s.XJitterWidth = 0.5;
% s = swarmchart(2*ones(1,length(groups.g2)),(groups.g2),20,'o','markerfacecolor',...
%     [68 210 242]/255,'markeredgecolor','k');
% s.XJitter = 'density';
% s.XJitterWidth = 0.5;
% 
% xticks([1 2]); xticklabels({categories{2};categories{1}})
% ylabel(vipNames(n));
% plot([0.8 1.2],[median((groups.g1)) median((groups.g1))],'-','linewidth',2,'color','k')
% plot([1.8 2.2],[median((groups.g2)) median((groups.g2))],'-','linewidth',2,'color','k')
% plot([0.8 1.2],[mean((groups.g1)) mean((groups.g1))],':','linewidth',2,'color','r')
% plot([1.8 2.2],[mean((groups.g2)) mean((groups.g2))],':','linewidth',2,'color','r')
% % [h,p(n)]=ttest2(groups.g2,groups.g1,'Vartype','unequal');
% [p(n),h]=ranksum(groups.g1,groups.g2);
% xlim([0.5 2.5])
% title(append('p = ',num2str(p(n))))
% end
% [pAdj, indAccepted] = findFDR(p, length(p), 0.05);
% 
% figure
% for n = 1:length(vipNames)
%     subplot(3,ceil(nplots/3),n)
% 
%     groups.g1 = X(1:length(Y(Y(:,1)==1)),strcmp(string(vipNames(n)),varNames));
%     groups.g2 = X((length(Y(Y(:,1)==1))+1):end,strcmp(string(vipNames(n)),varNames));
% 
%     violinplot_SD(groups,categories,'ShowData',logical(1),'ShowMean',logical(1));
%     xtickangle(45); ylabel(vipNames(n))
%     xticklabels(categories)
%     title(append('p = ',string(p(n))))
% end

end

