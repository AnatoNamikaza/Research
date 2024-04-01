%%%%%%%%%%%%%%%%%%%%% Party switching Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% party switching rate
psr = (1-t*((1)/Max_iter)) * lambda;

for i = 1:parties
    for j = 1:areas

        % checking the switching probability
        if rand() < psr
        
            %Selecting a party other than current where we want to send the member
            toParty = randi(parties);
            while(toParty == i)
                toParty = randi(parties);
            end
            
            %Deciding member in TO party
            [~,toPLeastFit] = max(Fitness(toParty,:));            
            
            %Deciding what to do with member in FROM party and switching
            temp = Positions(i,j,:);
            Positions(i,j,:) = Positions(toParty, toPLeastFit,:);
            Positions(toParty, toPLeastFit,:) = temp;
                
            temp = Fitness(i,j);
            Fitness(i,j) = Fitness(toParty, toPLeastFit);
            Fitness(toParty, toPLeastFit) = temp;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%