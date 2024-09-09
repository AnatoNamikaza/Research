%-------------------------------------------------------------------%
%  Genetic Algorithm (GA) with KNN Imputation and Timing            %
%-------------------------------------------------------------------%

%---Input------------------------------------------------------------
% feat     : Feature vector (instances x features)
% label    : Label vector (instances x 1)
% N        : Number of chromosomes
% max_Iter : Maximum number of generations
% CR       : Crossover rate
% MR       : Mutation rate

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
runs = 10; % Number of runs for each version of GA
CR1 = 0.8;
MR1 = 0.3;
CR2 = 0.6;
MR2 = 0.001;

% Initialize storage for accuracy results
Acc_results_GA1 = zeros(length(datasets), runs);
Acc_results_GA2 = zeros(length(datasets), runs);

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
    Curves_GA1 = zeros(runs, max_Iter);
    Curves_GA2 = zeros(runs, max_Iter);

    % Run the Genetic Algorithm version 1 multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Genetic Algorithm version 1
        [sFeat, Sf, Nf, curve] = jGA1(feat, label, N, max_Iter, CR1, MR1, HO);
        
        % Calculate the accuracy
        Acc = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_GA1(i, run) = Acc;

        Curves_GA1(run,:) = curve;

        % Save the results to a file
        results_folder_GA1 = 'GA1_results/';
        if ~exist(results_folder_GA1, 'dir')
            mkdir(results_folder_GA1);
        end

        file_path_GA1 = fullfile(results_folder_GA1, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_GA1, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Run the Genetic Algorithm version 2 multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Genetic Algorithm version 2
        [sFeat, Sf, Nf, curve] = jGA2(feat, label, N, max_Iter, CR2, MR2, HO);
        
        % Calculate the accuracy
        Acc = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_GA2(i, run) = Acc;

        Curves_GA2(run,:) = curve;

        % Save the results to a file
        results_folder_GA2 = 'GA2_results/';
        if ~exist(results_folder_GA2, 'dir')
            mkdir(results_folder_GA2);
        end

        file_path_GA2 = fullfile(results_folder_GA2, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_GA2, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Plot and save the convergence curve for Genetic Algorithm version 1
    [min_value1, min_index1] = min(Curves_GA1(:, end));

    fig_GA1 = figure('Visible', 'off');
    plot(1:max_Iter, Curves_GA1(min_index1,:));
    xlabel('Number of Generations');
    ylabel('Fitness Value');
    title(['GA Version 1 Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_GA1 = 'GA1_images/';
    if ~exist(img_folder_GA1, 'dir')
        mkdir(img_folder_GA1);
    end
    img_path_GA1 = fullfile(img_folder_GA1, strcat(datasets{i}, '.png'));
    saveas(fig_GA1, img_path_GA1);

    close(fig_GA1);

    % Plot and save the convergence curve for Genetic Algorithm version 2
    [min_value2, min_index2] = min(Curves_GA2(:, end));

    fig_GA2 = figure('Visible', 'off');
    plot(1:max_Iter, Curves_GA2(min_index2,:));
    xlabel('Number of Generations');
    ylabel('Fitness Value');
    title(['GA Version 2 Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_GA2 = 'GA2_images/';
    if ~exist(img_folder_GA2, 'dir')
        mkdir(img_folder_GA2);
    end
    img_path_GA2 = fullfile(img_folder_GA2, strcat(datasets{i}, '.png'));
    saveas(fig_GA2, img_path_GA2);

    close(fig_GA2);
end

% End total timing
total_time = toc(total_start_time);
fprintf('Total execution time: %.2f seconds\n', total_time);

% Display overall results
disp('Accuracy results for Genetic Algorithm version 1 for each dataset:');
disp(Acc_results_GA1);
disp('Accuracy results for Genetic Algorithm version 2 for each dataset:');
disp(Acc_results_GA2);
