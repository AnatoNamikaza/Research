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


% %% Hyper Learning Binary Dragonfly Algorithm 
% clc; clear; close; 
% % Set parameter
% kfold=10; k=5; N=10; T=100; pl=0.4; gl=0.7;
% O.k=k; O.kfold=kfold; O.N=N; O.T=T; O.pp=pl; O.pg=gl;
% % Load data
% load ionosphere.mat;
% % Split data into train & validate using cross-validation
% CV=cvpartition(label,'KFold',kfold,'Stratify',true);
% O.Model=CV; 
% % Perform feature selection
% [sFeat,Sf,Nf,curve]=jHLBDA(feat,label,O); 
% % Accuracy 
% Acc=jKNN(sFeat,label,CV,O); 

%Test
clc; clear; close;

%load 'ionosphere.mat';

datasets = { 'TOX-171.mat', 'Arrhythmia.mat', 'colon.mat', 'dermatology.mat', 'glass.mat', 'hepatitis.mat', ...
            'horse-colic.mat', 'ilpd.mat', 'ionosphere.mat', 'leukemia.mat', 'libras-movement.mat', ...
            'lsvt.mat', 'lung_discrete.mat', 'lympho.mat', 'musk1.mat', 'primary-tumor.mat', ...
            'SCADI.mat', 'seeds.mat', 'soybean.mat', 'spect-heart.mat', 'zoo.mat'};

% Store statistics
stats = cell(length(datasets), 2);

% Set parameters
kfold = 10;k = 5;N = 10;T = 100;pl = 0.4;gl = 0.7;

for i = 1:length(datasets)
    
    O.k = k;O.kfold = kfold;O.N = N;O.T = T;O.pp = pl;O.pg = gl;
    
    % Load data
    dataset_name = datasets{i};
    load(dataset_name);
    
    % Determine variable names for features and labels
    if exist('feat', 'var') && exist('label', 'var')
        X = feat;
        Y = label;
    elseif exist('X', 'var') && exist('Y', 'var')
        % Assuming X is features and Y is labels
    elseif exist('Hepatitis', 'var') && exist('Class', 'var')
        X = Hepatitis;
        Y = Class;
    elseif exist('X', 'var') && exist('y', 'var')
        % Assuming X is features and y is labels
        Y = y;
    else
        error('Could not determine variable names for features and labels.');
    end


    % Split data into train & validate using cross-validation
    CV = cvpartition(Y, 'KFold', kfold, 'Stratify', true);
    O.Model = CV; 
    
    % Perform feature selection
    [sFeat,Sf,Nf,curve] = jHLBDA(X, Y, O); 
    
    % Accuracy 
    Acc = jKNN(sFeat, Y, CV, O); 
    
    % Store statistics
    stats{i, 1} = dataset_name;
    stats{i, 2} = Acc;
end

% Display statistics
disp('Dataset Name, Accuracy');
%for i = 1:length(datasets)
%    disp([stats{i, 1}, ', ', num2str(stats{i, 2})]);
%end


