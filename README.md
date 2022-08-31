# PLSR-DA_MATLAB
A custom toolkit to implement partial least squares regression (PLSR) and discriminant analysis (PLSDA) in MATLAB.

Descriptions of codes are as follows:
OPLS: Orthogonalizes X data so that direction of maximum variance in Y is in the direction of LV1. Removes orthogonal components. Outputs a filtered X matrix which is passed into plsregress.
PLSR_main: Optionally pre-processes X and Y (zscores, calls OPLS), runs plsregress with either k-fold or leave-one-out cross-validation (part of plsregress functionality), and calls permtest.m. Outputs a data structure called 'model' containing all model statistics for downstream processing and visualization.
PLSR_plot: Calls functions loadings_plot.m, scores_plot.m, and VIP.m to produce figures.
PLSDA_main: Similar to PLSR_main.m, but for DA.
PLSDA_plot: "
CV: Cross-validation function. Not in use with the current workflow. Coded cross-validation from scratch, but ultimately decided to use plsregress.m's built-in cross validation.
permtest: Runs a permutation test and outputs either a paired Wilcoxon (signrank) or empirical p-value.
loadings_plot: Plots the loadings on LV1 and LV2 as 2 bar graphs.
scores_plot: Plots the X scores on LV1 and LV2, and reports the percent variance captured in both X
