%-------------------------------------------------------------------%
%  Binary Particle Swarm Optimization (BPSO) with KNN Imputation and Timing  %
%-------------------------------------------------------------------%

%---Input------------------------------------------------------------
% feat     : Feature vector (instances x features)
% label    : Label vector (instances x 1)
% N        : Number of particles
% max_Iter : Maximum number of iterations
% c1       : Cognitive factor
% c2       : Social factor

%---Output-----------------------------------------------------------
% sFeat    : Selected features 
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
c1 = 2; 
c2 = 2;

% Initialize storage for accuracy results
Acc_results_BPSO = zeros(length(datasets), runs);

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
    Curves_BPSO = zeros(runs, max_Iter);

    % Run the Binary Particle Swarm Optimization multiple times
    for run = 1:runs
        % Start timing for this run
        run_start_time = tic;

        % Binary Particle Swarm Optimization
        [sFeat, Sf, Nf, curve] = jBPSO(feat, label, N, max_Iter, c1, c2, HO);
        
        % Calculate the accuracy
        Acc = jKNN(sFeat, label, HO); % Replace with your own accuracy calculation
        Acc_results_BPSO(i, run) = Acc;

        Curves_BPSO(run,:) = curve;

        % Save the results to a file
        results_folder_BPSO = 'BPSO_results/';
        if ~exist(results_folder_BPSO, 'dir')
            mkdir(results_folder_BPSO);
        end

        file_path_BPSO = fullfile(results_folder_BPSO, strcat(datasets{i}, '.txt'));
        fileID = fopen(file_path_BPSO, 'a');
        fprintf(fileID, 'Run %d: Accuracy: %g %%\n', run, Acc);
        fprintf(fileID, 'Selected Features: %s\n', mat2str(sFeat));
        fprintf(fileID, 'Curve: %s\n', mat2str(curve));

        % End timing for this run
        run_time = toc(run_start_time);
        fprintf(fileID, 'Run time: %.2f seconds\n', run_time);

        fclose(fileID);
    end

    % Plot and save the convergence curve
    [min_value, min_index] = min(Curves_BPSO(:, end));

    fig_BPSO = figure('Visible', 'off');
    plot(1:max_Iter, Curves_BPSO(min_index,:));
    xlabel('Number of Iterations');
    ylabel('Fitness Value');
    title(['BPSO Convergence Curve for ', datasets{i}]);
    grid on;

    img_folder_BPSO = 'BPSO_images/';
    if ~exist(img_folder_BPSO, 'dir')
        mkdir(img_folder_BPSO);
    end
    img_path_BPSO = fullfile(img_folder_BPSO, strcat(datasets{i}, '.png'));
    saveas(fig_BPSO, img_path_BPSO);

    close(fig_BPSO);
end

% End total timing
total_time = toc(total_start_time);
fprintf('Total execution time: %.2f seconds\n', total_time);

% Display overall results
disp('Accuracy results for Binary Particle Swarm Optimization for each dataset:');
disp(Acc_results_BPSO);
