clc; clear; close;

% Define datasets
datasets = {
    'arrhythmia', 'colon', 'dermatology', 'glass', 'hepatitis', 'horse_colic', 'ilpd',...
    'ionosphere', 'leukemia', 'libras_movement', 'lsvt', 'lung_discrete', 'lympho',...
    'musk_1', 'primary_tumor', 'scadi', 'seeds', 'soybean', 'spect_heart', 'tox_171', 'zoo'};

% Define folder names
folders = {'ACO_results', 'BDA_results', 'BGWO1_results', 'BGWO2_results', 'BPSO_results',...
           'GA2_results', 'SCA_results', 'WOA_results'};

% Initialize global result table
global_result = zeros(length(datasets), length(folders));

% Loop over each dataset
for i = 1:length(datasets)
    dataset = datasets{i};
    
    % Loop over each folder
    for j = 1:length(folders)
        folder = folders{j};
        
        % Construct the file path for the current dataset in the current folder
        file_path = fullfile(folder, strcat(dataset, '.txt'));
        
        % Open the text file
        fid = fopen(file_path, 'r');
        
        if fid == -1
            fprintf('File not found: %s\n', file_path);
            continue;
        end
        
        % Initialize a variable to store all curves' minimum values
        curve_min_values = [];
        
        % Read the file line by line
        while ~feof(fid)
            line = fgetl(fid);
            if contains(line, 'Curve:')
                % Extract the curve values between the square brackets
                curve_values_str = extractBetween(line, '[', ']');
                curve_values = str2double(strsplit(char(curve_values_str), ' '));
                
                % Find the minimum value of this curve and store it
                curve_min_values(end+1) = min(curve_values); %#ok<*SAGROW>
            end
        end
        
        % Close the file
        fclose(fid);
        
        % Find the minimum value among all curve minimums for this dataset
        if ~isempty(curve_min_values)
            global_result(i, j) = min(curve_min_values);
        else
            global_result(i, j) = NaN; % In case there are no curves found
        end
    end
end

% Convert the result to a table and add row/column names
global_result_table = array2table(global_result, 'RowNames', datasets, 'VariableNames', folders);

% Display the result table
disp(global_result_table);

% Optionally, save the global result table to a file
writetable(global_result_table, 'global_result.csv', 'WriteRowNames', true);

