% Update positions using Hyper Learning Position Updating Strategy (HLPUS)
for i = 1:size(Positions, 1)
    for j = 1:size(Positions, 2)
        Position_vector_ij = squeeze(Positions(i, j, :))';

        % Calculate transfer function value
        TF = TransferFunction(Position_vector_ij);

        % Generate random number in the interval [0, 1]
        r1 = rand;

        if 0 <= r1 < pl
            % Update position using Eq. (14)
            Positions(i, j, :) = UpdatePosition(Position_vector_ij, 'personal_best');
        elseif pl <= r1 < gl
            % Update position with respect to personal best solution
            Positions(i, j, :) = UpdatePosition(Position_vector_ij, 'global_best');
        elseif gl <= r1 <= 1
            % Update position with respect to global best solution
            Positions(i, j, :) = Global_Best_Position;
        end
    end
end


% Function to calculate the transfer function value
function TF = TransferFunction(x)
    TF = abs(x / sqrt(x^2 + 1));
end

% Function to update position based on strategy
function new_position = UpdatePosition(position, strategy)
    global Leader_pos
    
    if strcmp(strategy, 'personal_best')
        new_position = (1 - position) .* rand(size(position)) + position .* rand(size(position)) .* abs(Leader_pos - position);
    elseif strcmp(strategy, 'global_best')
        new_position = (1 - position) .* rand(size(position)) + position .* rand(size(position)) .* abs(Leader_pos - position);
    else
        error('Invalid strategy specified.');
    end
end