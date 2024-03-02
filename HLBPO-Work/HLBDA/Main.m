%-------------------------------------------------------------------------%
%  Hyper Learning Binary Dragonfly Algorithm source code demo version     %
%-------------------------------------------------------------------------%


%---Inputs-----------------------------------------------------------------
% feat:   features
% label:  labelling
% N:      Number of dragonflies
% T:      Maximum number of iterations
% pl:     Probability of personal learning
% gl:     Probability of global learning
% kfold:  Number of K-fold cross-validation
% k:      Number of k in KNN
%---Outputs----------------------------------------------------------------
% sFeat:  Selected features
% Sf:     Selected feature index
% Nf:     Number of selected features
% curve:  Convergence curve
%--------------------------------------------------------------------------


%% Hyper Learning Binary Dragonfly Algorithm 
clc; clear; close; 
% Set parameter
kfold=10; k=5; N=10; T=100; pl=0.4; gl=0.7;
O.k=k; O.kfold=kfold; O.N=N; O.T=T; O.pp=pl; O.pg=gl;
% Load data
load ionosphere.mat;
% Split data into train & validate using cross-validation
CV=cvpartition(label,'KFold',kfold,'Stratify',true);
O.Model=CV; 
% Perform feature selection
[sFeat,Sf,Nf,curve]=jHLBDA(feat,label,O); 
% Accuracy 
Acc=jKNN(sFeat,label,CV,O); 




