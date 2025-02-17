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

%Test
clc; clear; close;

%                Name       Instances    Features    Dimensions
%     _________________    __________    ________    __________
% 
%     'Seeds'             210           7           'Low'     
%     'Zoo'               101           17          'Low'     
%     'Primary Tumor'     339           17          'Low'     
%     'Glass'             214           10          'Low'     
%     'ILPD'              583           10          'Low'     
%     'Horse Colic'       368           27          'Low'     
%     'SPECT Heart'       267           22          'Low'     
%     'Lymphography'      148           18          'Low'     
%     'Hepatitis'         155           19          'Low'     
%     'Musk 1'            476           168         'Medium'  
%     'Lung Discrete'     73            325         'Medium'  
%     'SCADI'             70            205         'Medium'  
%     'Arrhythmia'        452           279         'Medium'  
%     'Libras Movement'   360           90          'Medium'  
%     'Soybean'           307           35          'Medium'  
%     'Ionosphere'        351           34          'Medium'  
%     'Dermatology'       366           34          'Medium'  
%     'LSVT'              126           310         'Medium'  
%     'Colon'             62            2000        'High'    
%     'TOX_171'           171           5748        'High'    
%     'Leukemia'          72            7070        'High'    


%  datasets = { '1-Arrhythmia.mat', '2-colon.mat', '3-dermatology.mat', '4-glass.mat', '5-hepatitis.mat', ...
%              '6-horse-colic.mat', '7-ilpd.mat', '8-ionosphere.mat', '9-leukemia.mat', '10-libras-movement.mat', ...
%              '11-lsvt.mat', '12-lung_discrete.mat', '13-lympho.mat', '14-musk1.mat', '15-primary-tumor.mat', ...
%              '16-SCADI.mat', '17-seeds.mat', '18-soybean.mat', '19-spect-heart.mat', '20-TOX-171.mat', '21-zoo.mat'};

 datasets = { '9-leukemia.mat', '10-libras-movement.mat', '19-spect-heart.mat'};
%'18-soybean.mat',

% Define the path to the folder containing the datasets
folder_path = 'datasets/';

% Set parameters
kfold = 10;k = 5;N = 10;T = 100;
%%%%%%%%%%%%%%%%%%%%%%Adjustable parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parties = 8;        %Number of political parties
lambda = 1.0;       %Max limit of party switching rate

%fEvals = 30000;     %Number of function evaluations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

areas = parties;
members = parties;                
populationSize=parties * members; % Number of search agents
Max_iteration = 100; %round(fEvals / (parties * areas + areas));
plr = [  0.3,    0.4,    0.5,    0.6,    0.7,    0.8,    0.9]; % Personal learning rate
glr = [  0.65,   0.7,    0.75,   0.8,    0.85,   0.9,    0.95]; % Global learning rate
runs = 10;

pl = plr(7);
gl = glr(7);
%change plr & glr, combination in HLBDA pg 7

execution_times = zeros(1, length(datasets));

% Preallocate an array of structs to store CV models
O = repmat(struct('k', k, 'kfold', kfold, 'N', N, 'T', T, 'pp', pl, 'pg', gl), 1, length(datasets));

% Get the current date and time
startTime = datetime('now');

for i = 1:(length(datasets))
    
    % Measure execution time
    tic;
    
    % Load data
    dataset_name = strcat(folder_path, datasets{i});

    % Load data from the current file into a temporary variable
    temp = load(dataset_name);
    
    %load(dataset_name);
    
   % Determine variable names for features and labels
   % Determine variable names for features and labels
    if isfield(temp, 'feat') && isfield(temp, 'label')
        X = temp.feat;
        Y = temp.label;
    elseif isfield(temp, 'X') && isfield(temp, 'Y')
        X = temp.X;
        Y = temp.Y;
    elseif isfield(temp, 'Hepatitis') && isfield(temp, 'Class')
        X = temp.Hepatitis;
        Y = temp.Class;
    elseif isfield(temp, 'X') && isfield(temp, 'y')
        X = temp.X;
        Y = temp.y;
    else
        error('Could not determine variable names for features and labels.');
    end
     
    % disp(size(X))
    % disp(size(Y))

    % Xi are enteries while Xj are features
    % Yi are enteries while Yj are outcomes / labels

    % Split data into train & validate using cross-validation
    CV = cvpartition(Y, 'KFold', kfold, 'Stratify', true);
    O(i).Model = CV;     
    
     % Perform feature selection
     %[sFeat,Sf,Nf,curve] = jHLBDA(X, Y, O(i)); 
%        
%     % Accuracy 
%     Acc = jKNN(sFeat,Y,CV,O(i)); 
%     
%     folder_path_ = 'HLBDA/';
% 
%     % Check if the folder exists, if not, create it
%     if ~exist(folder_path_, 'dir')
%         mkdir(folder_path_);
%     end
%     
%     file_path = fullfile(folder_path_, strcat(datasets{i}, '.txt'));
% 
%     % Open the text file for appending
%     fileID = fopen(file_path, 'a');
%     
%     % Append results to the file
%     fprintf(fileID, 'Acc %d\n', Acc);
%     fprintf(fileID, 'sFeat: %f\n', sFeat);
%     fprintf(fileID, 'Sf: %f\n', Sf);
%     fprintf(fileID, 'Nf: %f\n', Nf);
%     fprintf(fileID, 'Curve: %f\n', curve);
% 
%     % Close the file
%     fclose(fileID);
% 
%     disp(curve)
%     disp(Acc)

    % Create file path with the dataset name and folder name
    file_path = fullfile('BPO & HLBPO 3/', strcat(datasets{i}, '.txt'));
    
    % Open the text file for appending
    fileID = fopen(file_path, 'a');

%     HLD_curve_str = ['[', sprintf('%.6f, ', curve(1:end-1)), sprintf('%.6f]', curve(end))];
%     fprintf(fileID, 'Curve: %s\n', HLD_curve_str);
%     fclose(fileID);

    B_Best_score_T = zeros(1,runs);
    B_Curves_T = zeros(runs,Max_iteration);

    HLB_Best_score_T = zeros(1,runs);
    HLB_Curves_T = zeros(runs,Max_iteration);

    for run=1:runs
        rng('shuffle');
        [B_Best_score_0,B_Best_pos,B_PO_cg_curve] = BPO(populationSize,areas,parties,lambda,Max_iteration,X,Y,O(i));
        B_Best_score_T(1,run) = B_Best_score_0;
        B_Curves_T (runs,:) = B_PO_cg_curve;
        %Acc1 = jKNN(B_Best_pos,Y,CV,O(i));

%         [HLB_Best_score_0,HLB_Best_pos,HLB_PO_cg_curve] = HLBPO(populationSize,parties,areas,lambda,Max_iteration,pl,gl,X,Y,O(i));
%         HLB_Best_score_T(1,run) = HLB_Best_score_0;
%         HLB_Curves_T (runs,:) = HLB_PO_cg_curve;
        %Acc2 = jKNN(HLB_Best_pos,Y,CV,O(i));

        % Create file path with the dataset name and folder name
        file_path = fullfile('BPO & HLBPO 3/', strcat(datasets{i}, '.txt'));
        
        % Open the text file for appending
        fileID = fopen(file_path, 'a');
        
        % Append results to the file
        fprintf(fileID, 'Run %d\n', run);
        
        %curve_str = ['curve: [', sprintf('%.6f, ', HLB_PO_cg_curve(1:end-1)), sprintf('%.6f]', HLB_PO_cg_curve(end))];

        % Write the formatted curve string to the file
        %fprintf(fileID, '%s\n', curve_str);
        
        fprintf(fileID, 'BPO Best Score: %s\n', B_Best_score_0);

        BP_curve_str = ['[', sprintf('%.6f, ', B_Best_pos(1:end-1)), sprintf('%.6f]', B_Best_pos(end))];
        fprintf(fileID, 'BPO Best Pos: %s\n', BP_curve_str);
        
        B_curve_str = ['[', sprintf('%.6f, ', B_PO_cg_curve(1:end-1)), sprintf('%.6f]', B_PO_cg_curve(end))];
        fprintf(fileID, 'Curve: %s\n', B_curve_str);
        
        disp(B_PO_cg_curve)
        
        fprintf(fileID, 'HLBPO Best Score: %s\n', HLB_Best_score_0);
        
        HP_curve_str = ['[', sprintf('%.6f, ', HLB_Best_pos(1:end-1)), sprintf('%.6f]', HLB_Best_pos(end))];
        fprintf(fileID, 'HLBPO Best Pos: %s\n', HP_curve_str);
        
        H_curve_str = ['[', sprintf('%.6f, ', HLB_PO_cg_curve(1:end-1)), sprintf('%.6f]', HLB_PO_cg_curve(end))];
        fprintf(fileID, 'Curve: %s\n', H_curve_str);
        
        disp(HLB_PO_cg_curve)
    
        % Close the file
        fclose(fileID);
    end

    % Find the row with the lowest values
%     [min_values, min_row_index] = min(B_Curves_T);
%     
%     % Get the row with the lowest values
%     lowest_values_B_PO_cg_curve = B_Curves_T(min_row_index, :);
% 
%     %Acc2 = jKNN(B_Best_pos,Y,CV,O);

    % Specify the folder path
     folder_path1 = 'img/';
     folder_path2 = 'BPO_img/';
     folder_path3 = 'HLBPO_img/';

    % Check if the folder exists, if not, create it
     if ~exist(folder_path1, 'dir')
         mkdir(folder_path1);
     end
     
     if ~exist(folder_path2, 'dir')
         mkdir(folder_path2);
     end
     
     if ~exist(folder_path3, 'dir')
         mkdir(folder_path3);
     end
    
    % Concatenate folder path, dataset name, and the desired suffix
     filename1 = strcat(folder_path1, datasets{i}, '.png');
     filename2 = strcat(folder_path2, datasets{i}, '.png');
     filename3 = strcat(folder_path3, datasets{i}, '.png');
% 
    % Plot the convergence curve and save with custom filename
    % colors = {
    %     'r', [1, 0, 0];         % Red
    %     'g', [0, 1, 0];         % Green
    %     'b', [0, 0, 1];         % Blue
    %     'c', [0, 1, 1];         % Cyan
    %     'm', [1, 0, 1];         % Magenta
    %     'y', [1, 1, 0];         % Yellow
    %     'k', [0, 0, 0];         % Black
    %     'w', [1, 1, 1];         % White
    %     'lightblue', [0.68, 0.85, 0.9];    % Light Blue
    %     'lightgreen', [0.56, 0.93, 0.56];  % Light Green
    %     'orange', [1, 0.65, 0];            % Orange
    %     'purple', [0.63, 0.13, 0.94];      % Purple
    %     'pink', [1, 0.75, 0.8];            % Pink
    %     'brown', [0.64, 0.16, 0.16];       % Brown
    % };
    
    % Define colors for each curve
    % colors = {'r', 'm', 'b', 'g', 'c', 'y', 'k', [0.64, 0.16, 0.16], 'p', 'o'};
     colors = {'#FF0000', '#00FF00', '#0000FF', '#00FFFF', '#FF00FF', '#FFFF00', '#000000', '#77AC30', '#FFA500', '#800080'};
     [min_value1, min_index1] = min(B_Curves_T(:, end));   
     [min_value2, min_index2] = min(HLB_Curves_T(:, end));

     B_PO_cg_curve = B_Curves_T(min_index1,:)
     HLB_PO_cg_curve = HLB_Curves_T(min_index2,:)
    % Plot the convergence curves and save as a single image
     plotConvergenceCurve( ...
         {curve, B_PO_cg_curve, HLB_PO_cg_curve}, ...
         filename1, ...
         {'HLBDA', 'BPO', 'HLBPO'}, ...
         colors);
  
     plotConvergenceCurve( ...
         {B_Curves_T(1,:), B_Curves_T(2,:), B_Curves_T(3,:), B_Curves_T(4,:), B_Curves_T(5,:), B_Curves_T(6,:), B_Curves_T(7,:), B_Curves_T(8,:), B_Curves_T(9,:), B_Curves_T(10,:)}, ...
         filename2, ...
         {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'}, ...
         colors);
 
     plotConvergenceCurve( ...
         {HLB_Curves_T(1,:), HLB_Curves_T(2,:),  HLB_Curves_T(3,:), HLB_Curves_T(4,:), HLB_Curves_T(5,:), HLB_Curves_T(6,:), HLB_Curves_T(7,:), HLB_Curves_T(8,:), HLB_Curves_T(9,:), HLB_Curves_T(10,:)}, ...
         filename3, ...
         {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'}, ...
         colors);

    %Finding statistics
%     B_Best_score_Best = min(B_Best_score_T);
%     HLB_Best_score_Best = min(HLB_Best_score_T);
%     B_Best_score_Worst = max(B_Best_score_T);
%     HLB_Best_score_Worst = max(HLB_Best_score_T);
%     B_Best_score_Median = median(B_Best_score_T,2);
%     HLB_Best_score_Median = median(HLB_Best_score_T,2);
%     B_Best_Score_Mean = mean(B_Best_score_T,2);
%     HLB_Best_Score_Mean = mean(HLB_Best_score_T,2);
%     B_Best_Score_std = std(B_Best_score_T);
%     HLB_Best_Score_std = std(HLB_Best_score_T);


    %acc table & feature selection ratio & classification acc & box plot


    %Printing results
%     display(['Best, Worst, Median, Mean, and Std. are as: ', num2str(B_Best_score_Best),'  ', num2str(B_Best_score_Worst),'  ', num2str(B_Best_score_Median),'  ', num2str(B_Best_Score_Mean),'  ', num2str(B_Best_Score_std)]);
%     display(['Best, Worst, Median, Mean, and Std. are as: ', num2str(HLB_Best_score_Best),'  ', num2str(HLB_Best_score_Worst),'  ', num2str(HLB_Best_score_Median),'  ', num2str(HLB_Best_Score_Mean),'  ', num2str(HLB_Best_Score_std)]);


    % Measure execution time
    execution_time = toc;
    execution_times(i) = execution_time;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the ending time
endTime = datetime('now');

% Open a file for writing
fileID = fopen('operation_times.txt', 'w');

% Write the starting and ending times to the file
fprintf(fileID, 'Start Time: %s\n', char(startTime));
fprintf(fileID, 'End Time: %s\n', char(endTime));

% Close the file
fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(execution_times)
% Display overall execution times
total_execution_time = sum(execution_times);
disp(['Total execution time for all functions: ', num2str(total_execution_time), ' seconds']);

% Get the ending time
endTime = datetime('now');

% Open a file for writing
fileID = fopen('operation_times.txt', 'w');

% Write the starting and ending times to the file
fprintf(fileID, 'Start Time: %s\n', char(startTime));
fprintf(fileID, 'End Time: %s\n', char(endTime));

% Close the file
fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define input data
inputData = 1:10;

% Execute the function in parallel using parfor
parfor i = 1:10
    output(i) = myFunction(i);
end

% Display the output
disp(output);

% Define a function to be executed in parallel
function result = myFunction(input)
    % Perform some computation
    result = input * 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotConvergenceCurve(curves, filename, labels, colors)
    % Define an array of markers
    markers = {'o', '+', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};

    % Create a figure without displaying it
    fig = figure('Visible', 'off');

    % Plot all convergence curves with labels, colors, and markers
    hold on;
    for i = 1:length(curves)
        % Use markers sequentially
        %marker = markers{mod(i - 1, length(markers)) + 1};
        indices = 1:5:length(curves{i});
        plot(1:length(curves{i}), curves{i}, 'LineWidth', 0.25, 'DisplayName', labels{i}, 'Color', colors{i}, 'Marker', markers(i), 'MarkerIndices', indices, 'MarkerSize', 2)
    end
    hold off;

    % Customize the plot
    title('Convergence Curves');
    xlabel('Iteration');
    ylabel('Fitness');
    grid on;
    legend('show');
    
    % Delete the existing file if it exists
    if nargin > 1 && exist(filename, 'file') == 2
        delete(filename);
    end
    
    % Save the plot with custom filename
    if nargin > 1
        saveas(fig, filename);
    end
    
    % Close the figure
    close(fig);
end

%Total execution time for all functions: 12573.8449 seconds
