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

for n = 1:nplots
    nexttile
    % subplot(3,ceil(nplots/3))

    for m = 1:width(Y)
        group = X(Y(:,m)==1,strcmp(string(vipNames(n)),varNames));

        b = bar(m,median(group)); hold on; b.EdgeColor = 'k';  b.FaceColor = 'w';b.FaceAlpha=0.4; 
        s = swarmchart(ones(1,length(group))*m,group,20,'o','markerfacecolor',...
            palette(m,:),'markeredgecolor','k','markerfacealpha',0.5);
        s.XJitter = 'density';
        s.XJitterWidth = 0.5;
        
        scatter(m,mean((group)),100,'_','markerfacecolor','none','markeredgecolor','k','linewidth',2)
        % plot([m-0.2 m+0.2],mean((group)),'-','linewidth',2,'color','k')

    end
        xticks([1:1:m]); xticklabels(categories)
        ylabel(vipNames(n));
        xlim([0.5 m+0.5])

    if m == 2 % use a t-test to compare 2 groups
        [h,p(n)]=ttest2(X(Y(:,1)==1,strcmp(string(vipNames(n)),varNames)),...
            X(Y(:,2)==1,strcmp(string(vipNames(n)),varNames)),'Vartype','unequal');
        %[p(n),h]=ranksum(groups.g1,groups.g2);
        title(append('p = ',num2str(p(n),'%0.3f')))
                [pAdj, indAccepted] = findFDR(p, length(p), 0.05);

    elseif m > 2 % use a kruskalwallis test to compare multiple groups
        % make a group variable
        [~,~,stats]=kruskalwallis(X(:,n),Ygroup,'off');
        c=multcompare(stats,'CriticalValueType','dunn-sidak','Display','off');
        p(:,n)=c(:,6);
        pAdj = ''; indAccepted = '';
    end        

 end



end

