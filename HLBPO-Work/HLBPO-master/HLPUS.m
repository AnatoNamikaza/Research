% Update positions using Hyper Learning Position Updating Strategy (HLPUS)
for i = 1:parties
    for j = 1:areas        
        for k = 1:dim
            
            % Calculate transfer function value
            TF = TransferFunction(Positions(i, j, k));
    
            % Generate random number in the interval [0, 1]
            r1 = rand;
    
            if (0 <= r1) && (r1 < pl)
                r2 = rand;

                if r2 < TF

                    Positions(i, j, k) = (1 - TF);

                elseif r2 >= TF

                    Positions(i, j, k) = TF;

                end

            elseif (pl <= r1) && (r1 < gl)

                % Update position with respect to personal best solution
                Positions(i, j, k) = Party_Leaders(i,k);

            elseif (gl <= r1) && (r1 <= 1)

                % Update position with respect to global best solution
                Positions(i, j, k) = Leader_pos(k);

            end
        end
    end
end


% Function to calculate the transfer function value
function TF = TransferFunction(x)
    TF = abs(x / sqrt(x^2 + 1));
end