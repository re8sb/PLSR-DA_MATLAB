function [vipScore,vipNames] = VIP(stats,XLoading,YLoading,XScore,varNames,palette,whichScores,plotThresh,Y,PLSR_or_PLSDA)
%% PLSR framework, Dolatshahi Lab
%% Author: Remziye Erdogan, 6/25/2021
%This function calculates and plots the VIP scores for each variable, then
%plots them on a bar graph. The VIP scores' color and direction is
%determined by the sign (+/-) of each variable's loading on the LV
%specified by which_LV.
%INPUT:
%stats: contains the weights (W) needed to calculate the VIP scores.
%XLoading: Loadings of the variables in X.
%YLoading: Loadings of the variables in Y.
%XScore: Scores of the observations in X along LV1 and LV2.
%varNames: A cell array containing variable names.
%palette: Colors for plotting specified in PLSR_plot.m.
%whichScores: if 'all', plots all VIP scores. if 'thresh', plots only VIP
%scores > 'plotThresh'.
%plotThresh: if whichScores == 'thresh', only plot VIP scores greater than
%this value.

%Calculate VIP scores:
W0 = stats.W ./ sqrt(sum(stats.W.^2,1));
p = size(XLoading,1);
sumSq = sum(XScore.^2,1).*sum(YLoading.^2,1);

if strcmp(whichScores,'all')
% plot all VIP scores
    [vipScore,idx] = sort(sqrt(p* sum(sumSq.*(W0.^2),2) ./ sum(sumSq,2)),'ascend');
    vipNames = varNames(idx);
    XLoading = XLoading(idx);
elseif strcmp(whichScores,'thresh')
    % %keep only vipScore > 1 for plotting
    [vipScore,idx] = sort(sqrt(p* sum(sumSq.*(W0.^2),2) ./ sum(sumSq,2)),'ascend');
    vipNames = varNames(idx);
    XLoading = XLoading(idx);
    vipNames = vipNames(abs(vipScore) > plotThresh);
    XLoading = XLoading(abs(vipScore) > plotThresh);
    vipScore = vipScore(abs(vipScore) > plotThresh);
end
%On which LV would you like to base the color/direction of yout your VIP scores bar graph?
which_LV = 1;

%Define the colors to use for pos/neg loadings.
color_pos = palette(2,:); color_neg = palette(1,:);

if strcmp(PLSR_or_PLSDA,'PLSDA')
    mean_group1 = mean(XScore(Y(:,1)==1));
    mean_group2 = mean(XScore(Y(:,1)==0));
    
    if mean_group1<mean_group2
        color_neg = palette(1,:); color_pos = palette(2,:);
    
    else
        color_pos = palette(1,:); color_neg = palette(2,:);
    
    end
end

% color_pos = palette(2,:); color_neg = palette(1,:);

figure;

%Plot dotted lines at X = +/-1, the threshold for determining VIP score
%significance.
plot(ones(length(vipScore)+3),[-1:length(vipScore)+1],'k--'); hold on
plot(-ones(length(vipScore)+3),[-1:length(vipScore)+1],'k--')
yticks(1:1:length(vipScore));
yticklabels(vipNames); title('VIP Scores')%title(append('VIP Scores ',YDataLabel))
ax = gca; ax.FontSize = 16;%ax.FontSize = 20;
% ax.YLabel.FontSize = 9;

%Plot the negative VIP scores, then the positive VIP scores
barh(vipScore.*sign(XLoading(:,which_LV)).*(XLoading(:,which_LV) <= 0),'FaceColor',color_neg); hold on
% barh(-vipScore.*sign(XLoading(:,which_LV)).*(XLoading(:,which_LV) <= 0),'FaceColor',color_neg); hold on
barh(vipScore.*sign(XLoading(:,which_LV)).*(XLoading(:,which_LV) > 0),'FaceColor',color_pos)

ylim([0 length(vipScore)+1]); xlim([-2 1.75])

end

