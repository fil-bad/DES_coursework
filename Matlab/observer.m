function G_out = observer(G_in)
%OBSERVER Summary of this function goes here
%   Detailed explanation goes here

G_out = struct("E",G_in.E, "X",0, "f",0, "x0",0);

% as suggested the whole initial state is given by the vector of all ones
% notice that the state will be expressed as a row, so that the "vector" of
% states will always be a column vector.
G_out.f = {};
G_out.x0 = ones(1,height(G_in.X));

G_out.X = G_out.x0; % the first defined state
x_new = G_out.x0;

while height(x_new) > 0
    
    x_til = x_new(1,:); % take the first state,
    x_new(1,:) = [];    % and remove it from the queue of states
    
    for e = 1:length(G_in.E) % compute the reachability
        
        state_index = find (G_in.f(:,3) == e); % find all the states with
                                               % the active event 'e'
        x_next = zeros(1,height(G_in.X));
        
        for x = 1:length(state_index)
            x_tmp = G_in.f(state_index(x),1); % starting x state
            if (x_til(x_tmp) == 1)
                % if the Gamma is referred to a state we're considering
                x_next(G_in.f(state_index(x),2)) = 1;
                % then we consider the f(x,e) as a valid transition
            end
        end
        % once found the new state
        if any(x_next) % if it is a valid state
            % we define the transition map
            G_out.f(end+1,:) = {x_til, x_next, e}; 
            
            if ~ismember(x_next, G_out.X,'rows') % if the state does not
                                                 % exist yet
                G_out.X = [G_out.X; x_next]; % add it to the list 
                                             % of all states
                x_new = [x_new; x_next];     % add at the end of the queue 
            end
        end
    end
end

f_tmp = zeros(height(G_out.f),width(G_out.f));

for h=1:height(G_out.f)
    f_tmp(h,1) = find (ismember(G_out.X, cell2mat(G_out.f(h,1)),'rows'));
    f_tmp(h,2) = find (ismember(G_out.X, cell2mat(G_out.f(h,2)),'rows'));
    f_tmp(h,3) = cell2mat(G_out.f(h,3));
end

G_out.f = f_tmp;


end

