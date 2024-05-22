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
function [Leader_score,Leader_pos,Convergence_curve]=BPO(Positions,parties,areas,lambda_max,Max_iter,pl,gl,X,Y,O)

dim = size(X, 2); % Dimensionality of the problem (number of features)

% initialize position vector and score for the leader
% Store the position and fitness of global best solution
% This would be the leader with the minimum fitness
Leader_pos = zeros(1, dim);
Leader_score = inf;  %change this to -inf for maximization problems

Convergence_curve=zeros(1,Max_iter);

%Initialize the positions of search agents
Positions = initialization(parties,areas,dim);

auxPositions = Positions;
prevPositions = Positions;

%Running phases for initializations
Election;   %Run election phase

auxFitness = Fitness;
prevFitness = Fitness;

t = 1; % Loop counter
lambda = lambda_max;

while t <= Max_iter
    prevFitness = auxFitness;
    prevPositions = auxPositions;
    auxFitness = Fitness;
    auxPositions = Positions;

    ElectionCampaign;
    PartySwitching;
    Election;
    Parliamentarism;

    HLPUS;

    lambda = lambda - lambda_max/Max_iter;
    Convergence_curve(t)=Leader_score;
    %printing best score
    fprintf('\nIteration %d Best (HLBPO)= %f',t - 1,Convergence_curve(t));

    t=t+1;    
end