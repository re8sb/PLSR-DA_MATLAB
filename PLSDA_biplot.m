function PLSDA_biplot(XScore,PCTVAR,Y,categories,CV_accuracy,p_perm,palette,XLoading,varNames)
    % this function makes a scores/loadings biplot for multi-class PLSDA
    % models.
    figure
    mkrs = {'o','s','^','d',};
    xline(0,'handlevisibility','off');yline(0,'handlevisibility','off'); hold on

    for m = 1:width(Y)
        scatter(XScore(Y(:,m)==1,1),XScore(Y(:,m)==1,2),50,mkrs{m},'markerfacecolor',palette(m,:), 'MarkerEdgeColor' ,'k','markerfacealpha',0.5,'markeredgealpha',1);    
    end
        %%%%%% here, trying to figure out scaling
    % scatter(zscore(XLoading(:,1)),zscore(XLoading(:,2)),'*','markeredgecolor','k') %might need to find a way to auto scale this
    % text(zscore(XLoading(:,1))/2,zscore(XLoading(:,2))/2,varNames) 
    % scatter(XLoading(:,1)*max(max(XScore)),XLoading(:,2)*max(max(XScore)),'*','markeredgecolor','k') %might need to find a way to auto scale this
    % text(XLoading(:,1)*max(max(XScore))+0.1,XLoading(:,2)*max(max(XScore))+0.1,varNames) 

    xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,1),'%.0f'),'%)')); 
    ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,2),'%.0f'),'%)')); 

    title(append('X scores',' (CV acc. = ',num2str(CV_accuracy,'%.0f'),'%, p = ',num2str(p_perm,'%.3f'),')')); set(gca,'fontsize',16); 
    
        legend(categories,'location','northeast')

end