%-------------------------------------------------------------------%
%  Binary Grey Wolf Optimization (BGWO) with KNN Imputation and Timing  %
%-------------------------------------------------------------------%

%---Input------------------------------------------------------------
% feat     : Feature vector (instances x features)
% label    : Label vector (instances x 1)
% N        : Number of wolves
% max_Iter : Maximum number of iterations

%---Output-----------------------------------------------------------
% sFeat    : Selected features (instances x features)
% Sf       : Selected feature index
% Nf       : Number of selected features
% curve    : Convergence curve
%--------------------------------------------------------------------

clc, clear, close all;

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
runs = 10; % Number of runs

% Initialize storage for accuracy results
Acc_results_BGWO1 = zeros(length(datasets), runs);
Acc_results_BGWO2 = zeros(length(datasets), runs);

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
    HO = cvpartition(label, 'HoldOut', ho, 'Stratify', false);

    % Storage for curves
    Curves_BGWO1 = zeros(runs, max_Iter);
    Curves_BGWO2 = zeros(runs, max_Iter);

    % Run Binary Grey Wolf Optimization (Version 1) multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Binary Grey Wolf Optimization (Version 1)
        [sFeat, Sf, Nf, curve] = jBGWO1(feat, label, N, max_Iter, HO);

        % Calculate the accuracy
        Acc_BGWO1 = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_BGWO1(i, run) = Acc_BGWO1;

        Curves_BGWO1(run,:) = curve;

        % Save the results to a file
        results_folder_BGWO1 = 'BGWO1_results/';
        if ~exist(results_folder_BGWO1, 'dir')
            mkdir(results_folder_BGWO1);
        end

        file_path_BGWO1 = fullfile(results_folder_BGWO1, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_BGWO1, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc_BGWO1);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Run Binary Grey Wolf Optimization (Version 2) multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Binary Grey Wolf Optimization (Version 2)
        [sFeat, Sf, Nf, curve] = jBGWO2(feat, label, N, max_Iter, HO);

        % Calculate the accuracy
        Acc_BGWO2 = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_BGWO2(i, run) = Acc_BGWO2;

        Curves_BGWO2(run,:) = curve;

        % Save the results to a file
        results_folder_BGWO2 = 'BGWO2_results/';
        if ~exist(results_folder_BGWO2, 'dir')
            mkdir(results_folder_BGWO2);
        end

        file_path_BGWO2 = fullfile(results_folder_BGWO2, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_BGWO2, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc_BGWO2);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Plot and save convergence curves
    [min_value1, min_index1] = min(Curves_BGWO1(:, end));
    [min_value2, min_index2] = min(Curves_BGWO2(:, end));

    % Plot BGWO1 convergence curve
    fig_BGWO1 = figure('Visible', 'off');
    plot(1:max_Iter, Curves_BGWO1(min_index1,:));
    xlabel('Number of Iterations');
    ylabel('Fitness Value');
    title(['BGWO1 Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_BGWO1 = 'BGWO1_images/';
    if ~exist(img_folder_BGWO1, 'dir')
        mkdir(img_folder_BGWO1);
    end
    img_path_BGWO1 = fullfile(img_folder_BGWO1, strcat(datasets{i}, '.png'));
    saveas(fig_BGWO1, img_path_BGWO1);

    close(fig_BGWO1);

    % Plot BGWO2 convergence curve
    fig_BGWO2 = figure('Visible', 'off');
    plot(1:max_Iter, Curves_BGWO2(min_index2,:));
    xlabel('Number of Iterations');
    ylabel('Fitness Value');
    title(['BGWO2 Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_BGWO2 = 'BGWO2_images/';
    if ~exist(img_folder_BGWO2, 'dir')
        mkdir(img_folder_BGWO2);
    end
    img_path_BGWO2 = fullfile(img_folder_BGWO2, strcat(datasets{i}, '.png'));
    saveas(fig_BGWO2, img_path_BGWO2);

    close(fig_BGWO2);
end

% End total timing
total_time = toc(total_start_time);
fprintf('Total execution time: %.2f seconds\n', total_time);

% Display overall results
disp('Accuracy results for Binary Grey Wolf Optimization Version 1 for each dataset:');
disp(Acc_results_BGWO1);

disp('Accuracy results for Binary Grey Wolf Optimization Version 2 for each dataset:');
disp(Acc_results_BGWO2);
