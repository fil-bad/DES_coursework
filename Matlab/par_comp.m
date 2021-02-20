function G_out = par_comp(G_in1, G_in2)
% This function will merge two automata through the parallel operator,
% outputting the resulting struct. Due to the several operation involved,
% we will separe each section to be computed.

G_out = struct("E",0, "X",0, "f",0, "x0",0);

% Part I: compute the set of events.

G_out.E = G_in1.E; % initial events set

for i = 1:length(G_in2.E)
    if ~(ismember( G_in2.E(i), G_in1.E ))
        G_out.E(end+1) =  G_in2.E(i);
    end
end

% Part II: compute the new states.

x_tmp = [];
for i = 1:length(G_in2.X)
    x_tmp = [x_tmp; G_in1.X + G_in2.X(i)];
end
% the resulting states are now in a column vector of X_1*X_2 length
G_out.X = x_tmp;

% Part III: compute the transition matrix.

f_tmp = [];

for x1 = 1:length(G_in1.X) % for each new state
    for x2 = 1:length(G_in2.X)
        for e = 1:length(G_out.E) % for each new event
            
            if (ismember( G_out.E(e),G_in1.E ) && ...
                    ~ismember( G_out.E(e), G_in2.E )) % E1 private event
                
                event = find( G_in1.E == G_out.E(e));
                for t = 1:length(G_in1.f)
                    if (all((G_in1.f(t,:) == [x1 0 event]) == [1 0 1]))
                        % the transition is well defined
                        f_tmp = [f_tmp; 
                                [x1+(x2-1)*length(G_in1.X) G_in1.f(t,2)+(x2-1)*length(G_in1.X) e]
                                ];
                    end
                end
                
            elseif (~ismember( G_out.E(e),G_in1.E ) && ...
                    ismember( G_out.E(e), G_in2.E )) % E2 private event
                
                event = find( G_in2.E == G_out.E(e) );
                for t = 1:length(G_in2.f)
                    if (all((G_in2.f(t,:) == [x2 0 event]) == [1 0 1]))
                        % the transition is well defined
                        f_tmp = [f_tmp; 
                                [x1+(x2-1)*length(G_in1.X) x1+(G_in2.f(t,2)-1)*length(G_in1.X) e]
                                ];
                    end
                end
                
            elseif (ismember( G_out.E(e),G_in1.E ) && ...
                    ismember( G_out.E(e), G_in2.E )) % shared event
                
                event1 = find( G_in1.E == G_out.E(e) );
                event2 = find( G_in2.E == G_out.E(e) );
                
                for t1 = 1:length(G_in1.f)
                    if (all((G_in1.f(t1,:) == [x1 0 event1]) == [1 0 1]))
                        for t2 = 1:length(G_in2.f)
                            if (all((G_in2.f(t2,:) == [x2 0 event2]) == [1 0 1]))
                                % the transition is well defined for both
                                f_tmp = [f_tmp; 
                                    [x1+(x2-1)*length(G_in1.X) G_in1.f(t1,2)+(G_in2.f(t2,2)-1)*length(G_in1.X) e]
                                    ];
                            end
                        end
                    end
                end      
            else
                continue     
            end            
        end
    end
end

G_out.f = f_tmp;

% Part IV: compute the initial condition.

G_out.x0 = G_in1.x0 + G_in2.x0;

end

