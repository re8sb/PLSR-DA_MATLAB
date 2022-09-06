function scores_plot(PLSR_or_PLSDA,XScore,PCTVAR,Y,YscaleLabel,Q2,p_perm,categories,palette)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This function produces a scatter plot of Xscores, with each observation
%colored according to its associated value in Y.
%Scores vectors contain the projection of each observation along
%each PLS component (LV1 and LV2). A scatter plot shows how the
%observations in X are projected into LV-space, and visually can show how
%LV1 and LV2 capture the corresponding values in Y.
%
%INPUT:
%PLSR_or_PLSDA: ('PLSR" or 'PLSDA') This variable is defined in PLSR_plot.
%It is used to determine if coloring is done using a continuous color bar
%spectrum, or if DA then colors are set for each group.
%XScore: The scores associated with X data, as output in model.XScore.
%PCTVAR: The percent variance captured by each component, for reporting on
%the LV1 and LV2 axes of the scatter plot. Output in model.PCTVAR.
%Y: The Y data, used to color the scatter plot points.
%YscaleLabel: The label used for the colorbar, defining values in Y. [] for
%PLSDA.
%categories: The categories you are discriminating between. gbh[] for PLSR.

figure;

%If this function is called in PLSR analysis, use a continuous color bar
if strcmp(PLSR_or_PLSDA,'PLSR')
    scatter(XScore(:,1),XScore(:,2),50,Y(:,1),'filled','markeredgecolor','k'); 
    xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,1),'%.0f'),'%)')); 
    ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,2),'%.0f'),'%)')); 
        title({append('X scores',' (Q^2 = ',num2str(Q2*100,'%.0f'),'%)');...
        append('p = ',num2str(p_perm,'%.3f'))}); set(gca,'fontsize',16); 
    colormap copper; colormap(flipud(copper)); 
%     colormap summer; colormap(flipud(summer)); 

    c = colorbar('TickLabels',{},'Ticks',[]);  c.Label.String = YscaleLabel; c.Label.FontSize = 20;

% if this is called in PLSDA analysis, define color groups separately
elseif strcmp(PLSR_or_PLSDA,'PLSDA')
    mean_group1 = mean(XScore(1:ceil(length(XScore))/2,1));
    mean_group2 = mean(XScore((floor(length(XScore))/2+1):end,1));
%     clrs=[219, 164, 110;112, 93, 73]/255; %(dark color, light color)
    if mean_group1<mean_group2
        clrs = [palette(2,:);palette(1,:)];
    
    else
        clrs = [palette(1,:);palette(2,:)];
    
    end
gscatter(XScore(:,1),XScore(:,2),categorical(Y(:,1)),clrs,[],30, 'MarkerEdgeColor' ,'k');    
xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,1),'%.0f'),'%)')); 
    ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%, Y_{var} = ',num2str(100*PCTVAR(2,2),'%.0f'),'%)')); 
%     xlabel(append('LV1',' (X_{var} = ',num2str(100*PCTVAR(1,1),'%.0f'),'%)')); 
%     ylabel(append('LV2',' (X_{var} = ',num2str(100*PCTVAR(1,2),'%.0f'),'%)')); 
title({append('X scores',' (CV acc. = ',num2str(Q2,'%.0f'),'%)');...
        append('p = ',num2str(p_perm,'%.3f'))}); set(gca,'fontsize',16); 

%     colormap copper(2); colormap(flipud(copper)); 
    legend(categories{1},categories{2},'location','northeast')
end
%c.Direction = 'reverse';

% figure; subplot(1,2,1); scatter(XScore(:,1),XScore(:,2),[],Y,'filled','markeredgecolor','k'); %'MarkerFaceColor','#77F8FF'
% xlabel(append('LV1',' (Y var = ',num2str(100*PCTVAR(2,1),'%.1f'),'%)')); ylabel(append('LV2',' (',num2str(100*PCTVAR(2,2),'%.1f'),'%)')); title('X scores'); set(gca,'fontsize',20); 
% subplot(1,2,2); scatter(YScore(:,1),YScore(:,2),[],Y,'filled','markeredgecolor','k'); 
% %xlabel(append('LV1',' (Y_{var} = ',num2str(100*PCTVAR(2,1),'%.1f'),'%)')); ylabel(append('LV2',' (',num2str(100*PCTVAR(2,2),'%.1f'),'%)')); 
% title('Y scores'); set(gca,'fontsize',20);
% colormap winter; colorbar
end

