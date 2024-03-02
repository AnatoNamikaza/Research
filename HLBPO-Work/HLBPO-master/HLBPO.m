%_________________________________________________________________________________
%  Political Optimizer: A novel socio-inspired meta-heuristic 
%                       for global optimization source codes version 1.0
%
%  Developed in MATLAB R2015a
%
%  Author and programmer: Qamar Askari
%
%         e-Mail: l165502@lhr.nu.edu.pk
%                 syedqamar@gift.edu.pk
%
%
%   Main paper:
%   Askari, Q., Younas, I., & Saeed, M. (2020). Political Optimizer: 
%       A novel socio-inspired meta-heuristic for global optimization.
%   Knowledge-Based Systems, 2020, 
%   DOI: https://doi.org/10.1016/j.knosys.2020.105709
%____________________________________________________________________________________
% 
function [Leader_score,Leader_pos,Convergence_curve]=HLBPO(SearchAgents_no,parties,areas,lambda_max,Max_iter,pl,gl,X,Y,O)

dim = size(X, 2); % Dimensionality of the problem (number of features)

% initialize position vector and score for the leader
Leader_pos = zeros(1, dim);
Leader_score = inf;  %change this to -inf for maximization problems
Convergence_curve=zeros(1,Max_iter);

%Initialize the positions of search agents
Positions=initialization(parties,areas,dim);
fitness=zeros(parties,areas);

% Compute set of party leaders P* using Eq. (12)
Party_Leaders = 0;

% Compute set of constituency winners C* using Eq. (11)
Constituency_Winners = 0;

% Store the position and fitness of global best solution
% This would be the leader with the minimum fitness
Global_Best_Position = 0;
Global_Best_Fitness = 0;

%Running phases for initializations
Election;   %Run election phase

%GovernmentFormation;

t=1;% Loop counter
lambda = lambda_max;

while t < Max_iter
    prevPositions = Positions;
    prevFitness = Fitness;

    ElectionCampaign;
    
    PartySwitching;
    Election;
    Parliamentarism;

    HLPUS;

    lambda = lambda - lambda_max/Max_iter;
    t=t+1;
    Convergence_curve(t)=Leader_score;

    %printing best score
    %[t Leader_score];
end