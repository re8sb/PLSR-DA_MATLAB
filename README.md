# PLSR-DA_MATLAB

A toolkit to implement partial least squares regression (PLSR) and discriminant analysis (PLSDA) in MATLAB.

Descriptions of codes are as follows:

sample_PLS.m: A sample call to PLSR and PLSDA using toy data.

PLSR_main.m: Takes raw data as an nxm array with m variables and n observations (X) and an nx1 array of Y values (output). Option to use least absolute shrinkage and selection operator (LASSO) to select model features and optional model orthogonalization. Runs 'plsregress' with either k-fold or leave-one-out cross-validation, and compares model performance to a user-specified number of null models. Outputs a data structure called 'model' containing all model statistics for downstream processing and visualization.

PLSDA_main.m: Takes raw data as an nxm array with m variables and n observations (X) and an nxp array of Y values where p is the number of discriminant groups. Every observation in Y should have a value of "1" if it is a member of the group designated to that column, and "0" in all other columns. Option to use least absolute shrinkage and selection operator (LASSO) to select model features and optional model orthogonalization. Runs 'plsregress' with either k-fold or leave-one-out cross-validation, and compares model performance to a user-specified number of null models. Outputs a data structure called 'model' containing all model statistics for downstream processing and visualization.

OPLS.m: Orthogonalizes X data so that direction of maximum variance in Y is in the direction of latent variable 1. Removes orthogonal components. Outputs a filtered X matrix which is passed into 'plsregress'.

loadings_plot.m: Plots the loadings on LV1 and LV2 as 2 bar graphs.

scores_plot.m: Plots the X scores on LV1 and LV2, and reports the percent variance captured in both X.

VIP.m: Computes Variable importance in projection (VIP) scores and plots them as a bar graph with VIP scores artifically directioned and colored according to feature loadings on latent variable 1.

univar_plot.m: Plots the univariate comparisons between model features as violin plots. P-value is reported from a Wilcoxon rank sum test using the Benjamini-Hochberg false discovery rate controlled at alpha = 0.05.

FDR.m: Computes the adjusted p-values from the Wilcoxon rank sum pairwise comparisons using the Benjamini-Hochberg method controlling the false discovery rate at alpha = 0.05.

PLSR_plot.m: Calls functions loadings_plot.m, scores_plot.m, and VIP.m to produce a loadings bar plot, X scores plot, and VIP scores bar plot.

PLSDA_plot.m: Calls functions loadings_plot.m, scores_plot.m, VIP.m, and univar_plot.m to produce a loadings bar plot, X scores plot, univariate comparisons between discriminant groups shown as a violin plot and swarmchart, and VIP scores bar plot. 

permtest.m: Runs a permutation test using 'nperm' permutations. Randomly permutes the Y data to generate 'nperm' null models, then compares the true model against the null distribution and computes an empirical p value. For PLSR, true model mean squared error (MSE) is compared against null model MSE. For PLSDA, true model cross validation (CV) accuracy is compared against null model CV accuracy. Plots a histogram of null distribution against true model (*).



