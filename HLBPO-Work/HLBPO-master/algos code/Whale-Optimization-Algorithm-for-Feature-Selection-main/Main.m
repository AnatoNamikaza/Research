%---------------------------------------------------------------------%
%  Whale Optimization Algorithm (WOA) with KNN Imputation and Timing  %
%---------------------------------------------------------------------%


%---Inputs-----------------------------------------------------------
% feat     : feature vector ( Instances x Features )
% label    : label vector ( Instances x 1 )
% N        : Number of whales
% max_Iter : Maximum number of iterations
% b        : Constant 

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
runs = 10; % Number of runs for the algorithm

% Initialize storage for accuracy results
Acc_results = zeros(length(datasets), runs);

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

    Curves_T = zeros(runs, max_Iter);

    % Run the WOA algorithm multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Whale Optimization Algorithm
        [sFeat, Sf, Nf, curve] = jWOA(feat, label, N, max_Iter, HO);

        % Calculate the accuracy
        Acc = jKNN(sFeat, label, HO);
        Acc_results(i, run) = Acc;

        Curves_T(run,:) = curve;

        % Save the results to a file
        results_folder = 'WOA_results/';
        if ~exist(results_folder, 'dir')
            mkdir(results_folder);
        end

        file_path = fullfile(results_folder, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Plot the convergence curve for the best run
    [min_value1, min_index1] = min(Curves_T(:, end));

    % Create a figure but don't display it
    fig = figure('Visible', 'off');
    plot(1:max_Iter, Curves_T(min_index1,:));
    xlabel('Number of Iterations');
    ylabel('Fitness Value');
    title(['WOA Convergence Curve for ', datasets{i}]);
    grid on;

    % Save the convergence plot
    img_folder = 'WOA_images/';
    if ~exist(img_folder, 'dir')
        mkdir(img_folder);
    end
    img_path = fullfile(img_folder, strcat(datasets{i}, '.png'));
    saveas(fig, img_path);

    % Close the figure after saving
    close(fig);
end

% End total timing
total_time = toc(total_start_time);
fprintf('Total execution time: %.2f seconds\n', total_time);

% Display overall results
disp('Accuracy results for each dataset:');
disp(Acc_results);



