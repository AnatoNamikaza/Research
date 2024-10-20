%---------------------------------------------------------------------%
%  Ant Colony Optimization (ACO) with KNN Imputation and Timing       %
%---------------------------------------------------------------------%

%---Inputs-------------------------------------------------------------
% feat     : Feature vector (instances x features)
% label    : Label vector (instances x 1)
% N        : Number of ants
% max_Iter : Maximum number of iterations
% alpha    : Coefficient control tau
% beta     : Coefficient control eta
% tau      : Initial tau
% eta      : Initial eta
% rho      : Pheromone evaporation rate

%---Outputs------------------------------------------------------------
% sFeat    : Selected features
% Sf       : Selected feature index
% Nf       : Number of selected features
% curve    : Convergence curve
%----------------------------------------------------------------------

clc; clear; close all;

% Define the path to the folder containing the datasets
folder_path = 'Datasets_/';

% List of datasets in the folder
datasets = {
    'arrhythmia', 'colon', 'dermatology', 'glass', 'hepatitis', 'horse_colic', 'ilpd',...
    'ionosphere', 'leukemia', 'libras_movement', 'lsvt', 'lung_discrete', 'lympho',...
    'musk_1', 'primary_tumor', 'scadi', 'seeds', 'soybean', 'spect_heart', 'tox_171', 'zoo'};

% Parameter setting
N = 10;
max_Iter = 100;
tau = 1;
alpha = 1;
rho = 0.2;
beta = 0.1;
eta = 1;
runs = 10; % Number of runs

% Initialize storage for accuracy results
Acc_results_ACO = zeros(length(datasets), runs);

% Start total timing
total_start_time = tic;

% Loop through each dataset in the folder
for i = 1:length(datasets)
    dataset_name = strcat(folder_path, datasets{i});

    % Load the dataset
    temp = load(dataset_name);

    % Determine variable names for features and labels
    if isfield(temp, 'feat') && isfield(temp, 'label')
        feat = temp.feat;
        label = temp.label;
    elseif isfield(temp, 'X') && isfield(temp, 'Y')
        feat = temp.X;
        label = temp.Y;
    elseif isfield(temp, 'Hepatitis') && isfield(temp, 'Class')
        feat = temp.Hepatitis;
        label = temp.Class;
    elseif isfield(temp, 'X') && isfield(temp, 'y')
        feat = temp.X;
        label = temp.y;
    else
        error('Could not determine variable names for features and labels.');
    end

    % Hold-out method (20% validation set)
    ho = 0.2;
    HO = cvpartition(label, 'HoldOut', ho);

    % Storage for curves
    Curves_ACO = zeros(runs, max_Iter);

    % Run Ant Colony Optimization multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Ant Colony Optimization
        [sFeat, Nf, Sf, curve] = jACO(feat, label, N, max_Iter, tau, eta, alpha, beta, rho, HO);

        % Calculate the accuracy
        Acc_ACO = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_ACO(i, run) = Acc_ACO;

        Curves_ACO(run,:) = curve;

        % Save the results to a file
        results_folder_ACO = 'ACO_results/';
        if ~exist(results_folder_ACO, 'dir')
            mkdir(results_folder_ACO);
        end

        file_path_ACO = fullfile(results_folder_ACO, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_ACO, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc_ACO);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Plot and save convergence curves
    [min_value, min_index] = min(Curves_ACO(:, end));

    % Plot ACO convergence curve
    fig_ACO = figure('Visible', 'off');
    plot(1:max_Iter, Curves_ACO(min_index,:));
    xlabel('Number of Iterations');
    ylabel('Fitness Value');
    title(['ACO Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_ACO = 'ACO_images/';
    if ~exist(img_folder_ACO, 'dir')
        mkdir(img_folder_ACO);
    end
    img_path_ACO = fullfile(img_folder_ACO, strcat(datasets{i}, '.png'));
    saveas(fig_ACO, img_path_ACO);

    close(fig_ACO);
end

% End total timing
total_time = toc(total_start_time);
fprintf('Total execution time: %.2f seconds\n', total_time);

% Display overall results
disp('Accuracy results for Ant Colony Optimization for each dataset:');
disp(Acc_results_ACO);
