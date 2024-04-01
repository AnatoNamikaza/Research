% %%%%%%%%%%%%%%%%%%%%% Election Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:size(Positions,1)
%     for j=1:size(Positions,2)
%         Position_vector_ij = squeeze(Positions(i, j, :))';
%         %Calculate objective function for each search agent
%         fitness(i,j)=jFitnessFunction(X,Y,Position_vector_ij, O);
%         
%         %Update the leader
%         if fitness(i,j)<Leader_score % Change this to > for maximization problem
%             Leader_score=fitness(i,j); 
%             Leader_pos=Position_vector_ij;
%         end
%     end
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% Election Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store the fitness of all members of all parties in each constitution
Fitness = zeros(parties,areas);

% Calculate fitness for all positions
for i = 1:parties
    for j = 1:areas
        Position_vector_ij = squeeze(Positions(i, j, :))';
        
        % Calculate objective function for each search agent
        fit = jFitnessFunction(X, Y, Position_vector_ij, O);

        if isinf(fit)
            fit  = sigmoid(fit);
        end
        
        % Update the leader of the corresponding party
        if fit < Leader_score % Change this to > for maximization problem
            Leader_score = fit; 
            Leader_pos = Position_vector_ij;
        end
       
        % Store fitness value for further processing
        Fitness(i, j) = fit;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% Govt. Formation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute set of party leaders P* using Eq. (12)
% Array to store winners of each party
Party_Leaders = zeros(parties, dim); 
Party_Leaders_Fitness = zeros(parties);
%Party_Leaders_Area = zeros(parties);

% Compute set of constituency winners C* using Eq. (11)
% Array to store winners of each area
Constituency_Winners = zeros(areas, dim);
Constituency_Winners_Fitness = zeros(areas);
Constituency_Winners_Party = zeros(areas);

% Update Party_Leaders array (winners of each party)
for i = 1:parties
    [min_value, min_column_index] = min(Fitness(i, :));
    Party_Leaders(i, :) = squeeze(Positions(i, min_column_index, :))';
    Party_Leaders_Fitness(i) = min_value;
    %Party_Leaders_Area(i) = min_column_index;
end

% Update Constituency_Winners array (winners of each area)
for j = 1:areas
    [min_value, min_row_index] = min(Fitness(:, j));
    Constituency_Winners(j, :) = squeeze(Positions(min_row_index, j, :))';
    Constituency_Winners_Fitness(j) = min_value;
    Constituency_Winners_Party(j) = min_row_index;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = sigmoid(x)
    result = 1 ./ (1 + exp(-x));
end