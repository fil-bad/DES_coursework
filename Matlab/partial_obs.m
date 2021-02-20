function G_out = partial_obs(G_in)
% function that change the automaton following the new partial
% observability condition.

G_out = struct("E",0, "X",G_in.X, "f",G_in.f, "x0",G_in.x0);

new_e = ['m','r']';
G_out.E = new_e;

% now, we determine the position of events to be substituted
e2remove = ['n','s','e','w']';
e_index = zeros(4,1);
for e=1:length(e2remove)
    e_index(e) = find( G_in.E == e2remove(e));
end

r_old = find( G_in.E == 'r');

% finally, change the indexes of events
for i=1:height(G_in.f)
    if ( ismember(G_in.f(i,3),e_index) )
        G_out.f(i,3) = 1;
    elseif ( ismember(G_in.f(i,3),r_old) )
        G_out.f(i,3) = 2;
    end


end

