%% Sample call to PLSR and PLSDA. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RE 9/1/22
close all
clear; clc

%% PLSR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = rand(10,10);
Y = rand(10,1);
varNames = {'a','b','c','d','e','f','g','h','i','j'}';
nperm = 1000;
ncomp = 2;
Y_data_name = 'output';
model_PLSR = PLSR_main(X,Y,ncomp,varNames,'no','yes',{'kfold',5},nperm,Y_data_name);

%% PLSDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = rand(10,10);
Y = logical([1 1 1 1 1 0 0 0 0 0])'; Y = double([Y ~Y]);
varNames = {'a','b','c','d','e','f','g','h','i','j'}';
nperm = 1000;
ncomp = 2;
categories = {'group 1','group 2'};

model_PLSDA = PLSDA_main(X,Y,ncomp,varNames,'no','yes',{'kfold',5},nperm,categories);
