%Test
clc; clear; close;

% datasets = { '1-Arrhythmia.mat', '2-colon.mat', '3-dermatology.mat', '4-glass.mat', '5-hepatitis.mat', ...
%             '6-horse-colic.mat', '7-ilpd.mat', '8-ionosphere.mat', '9-leukemia.mat', '10-libras-movement.mat', ...
%             '11-lsvt.mat', '12-lung_discrete.mat', '13-lympho.mat', '14-musk1.mat', '15-primary-tumor.mat', ...
%             '16-SCADI.mat', '17-seeds.mat', '19-spect-heart.mat', '20-TOX-171.mat', '21-zoo.mat'};

%'18-soybean.mat' not plotted yet

datasets = { '9-leukemia.mat', '10-libras-movement.mat', '19-spect-heart.mat'};

% Define the path to the folder containing the datasets
folder_path = 'BPO & HLBPO 3/';

for i = 1:(length(datasets))    
    % Measure execution time
    tic;
    
    % Load data
    dataset_name = strcat(folder_path, datasets{i},'.txt');

    % Open the text file
    fid = fopen(dataset_name, 'r');
    
   % Read the first line containing curve values
    first_line = fgetl(fid);
    curve_values_str = extractBetween(first_line, '[', ']');
    curve_values = str2double(strsplit(char(curve_values_str), ', '));
    curve = curve_values;
    
    % Initialize cell arrays to store curves
    B_Curves_T = {};
    HLB_Curves_T = {};
    
    line_number = 2;
    
    % Read the rest of the file
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'Curve:')
            curve_values_str = extractBetween(line, '[', ']');
            curve_values = str2double(strsplit(char(curve_values_str), ', '));
            if mod(line_number, 2) == 0
                B_Curves_T{end+1, 1} = curve_values;
            else
                HLB_Curves_T{end+1, 1} = curve_values;
            end
            line_number = line_number + 1;
        end
    end
        
    % Close the file
    fclose(fid);
    
    % Convert cell arrays to matrices
    B_Curves_T = cell2mat(B_Curves_T);
    HLB_Curves_T = cell2mat(HLB_Curves_T);
    
    % Display the results
    disp('Curves on even occurrence:');
    disp(B_Curves_T);
    
    disp('Curves on odd occurrence:');
    disp(HLB_Curves_T);

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
    colors = {'#FF0000', '#00FF00', '#0000FF', '#00FFFF', '#FF00FF', '#FFFF00', '#000000', '#77AC30', '#FFA500', '#800080'};
    
    [min_value1, min_index1] = min(B_Curves_T(:, end));
    [min_value2, min_index2] = min(HLB_Curves_T(:, end));
    
    B_PO_cg_curve = B_Curves_T(min_index1,:);
    HLB_PO_cg_curve = HLB_Curves_T(min_index2,:);
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

end

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