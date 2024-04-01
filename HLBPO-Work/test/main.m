

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
