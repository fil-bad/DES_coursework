function G_out = partial_obs(G_in)
% function that change the automaton following the new partial
% observability condition.

G_out = struct("E",0, "X",G_in.X, "f",G_in.f, "x0",0);

new_e = ['m','r']';
G_out.E = new_e;

% now, we determine the position of events to be substituted
e2remove = ['n','s','e','w']';
e_index = zeros(4,1);
for e=1:length(e2remove)
    e_index(e) = find( G_in.E == e2remove(e));
end

r_old = find( G_in.E == 'r');

% change the indexes of events
for i=1:height(G_in.f)
    if ( ismember(G_in.f(i,3),e_index) )
        G_out.f(i,3) = 1;
    elseif ( ismember(G_in.f(i,3),r_old) )
        G_out.f(i,3) = 2;
    end
end
% finally, add the initial states

room = extractBefore(G_in.x0,4);
% build the state for x0
tmp_state = "{";
heading = ["N","S","E","W"];
for i=1:length(heading)
    tmp_state = tmp_state + room + heading(i) + ",";    
end
tmp_state = char(tmp_state);
tmp_state(end) = '}';
G_in.x0 = string(tmp_state);

% add all the other possible initial state

add_state = [tmp_state];
for i=1:( (length(G_out.X)/length(heading))-1 ) % up to 6 in our case
    tmp_state = replace(tmp_state, num2str(i), num2str(i+1));
    add_state = [add_state; tmp_state];
end

orig_length = height(G_out.X);
G_out.X = [G_out.X; add_state];

% add the new possible transitions:
add_state = string(add_state);

new_len = height(G_out.X);

% those that are loops through 'r' event
for x=orig_length+1:new_len
    G_out.f = [G_out.f; [x x find(G_out.E == 'r')]];
end

% those that goes to a deterministic state
trans_f = find (G_out.f(:,3) == 1);

for i=1:length(trans_f)
    % find the initial state that contains the one involved in transition
    offset = find(contains(add_state, G_out.X(G_out.f(trans_f(i),1))));
    
    G_out.f = [G_out.f; 
        [orig_length+offset G_out.f(trans_f(i),2) find(G_out.E == 'm')] ];
        
end


end

