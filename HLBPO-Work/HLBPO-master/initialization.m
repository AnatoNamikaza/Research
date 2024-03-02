function Positions = initialization(parties,areas,dim)
    Positions = rand(parties,areas, dim) > 0.5;
end

% It generates a matrix of size SearchAgents_no-by-dim 
% filled with random numbers drawn from a uniform distribution between 0 and 1. 
% Then, it converts these random numbers into binary values (0s and 1s) 
% by comparing each element to 0.5. 
% If the random number is greater than 0.5, 
% the corresponding element in the Positions matrix is set to 1;
% otherwise, it is set to 0.