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
p = zeros(parties, dim); % Array to store winners of each party
c = zeros(areas, dim);   % Array to store winners of each area

% Calculate fitness for all positions
for i = 1:size(Positions, 1)
    for j = 1:size(Positions, 2)
        Position_vector_ij = squeeze(Positions(i, j, :))';
        
        % Calculate objective function for each search agent
        fit = jFitnessFunction(X, Y, Position_vector_ij, O);
        
        % Update the leader of the corresponding party
        if fit < Leader_score % Change this to > for maximization problem
            Leader_score = fit; 
            Leader_pos = Position_vector_ij;
        end
       
        % Store fitness value for further processing
        fitness(i, j) = fit;
    end
end

% Update p array (winners of each party)
for i = 1:size(p, 1)
    [min_value, min_column_index] = min(fitness(i, :));
    p(i, :) = squeeze(Positions(i, min_column_index, :))';
end

% Update c array (winners of each area)
for j = 1:size(c, 1)
    [min_value, min_row_index] = min(fitness(:, j));
    c(j, :) = squeeze(Positions(min_row_index, j, :))';
end

% Compute set of party leaders P* using Eq. (12)
Party_Leaders = p;

% Compute set of constituency winners C* using Eq. (11)
Constituency_Winners = c;

% Store the position and fitness of global best solution
% This would be the leader with the minimum fitness
Global_Best_Position = Leader_pos;
Global_Best_Fitness = Leader_score;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
