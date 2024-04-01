%%%%%%%%%%%%%%%%%%%%% Parliamentarism %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for a=1:areas
    newAWinner = Constituency_Winners(a,:);
    i = Constituency_Winners_Party(a);    
    
    toa = randi(areas);
    while(toa == a)
        toa = randi(areas);
    end

	toAWinner = Constituency_Winners(toa,:);
    for j = 1:dim
        distance = abs(toAWinner(1,j) - newAWinner(1,j));
        newAWinner(1,j) = toAWinner(1,j) + (2*rand()-1) * distance;
    end

    newAWFitness = jFitnessFunction(X, Y, newAWinner, O);
    
	%Replace only if improves
	if newAWFitness < Constituency_Winners_Fitness(a) 
        Positions(i,a,:) = newAWinner(1,:);
        Fitness(i,a) = newAWFitness;
        Constituency_Winners(a,:) = newAWinner(1,:);
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%