function x_final = explore_obs(G,w)
% Given any word and an observer automaton from an unknown state, we find
% out in which state we end up, starting from the completely unknown state.

if isempty(w)
    x_final = G.x0;
    return;
end

x_final = find(ismember(G.X,G.x0,'rows')); % initial state position.

for e=1:length(w)
   e_num = find (G.E == w(e));
   f_row = find(ismember(G.f(:,[1 3]), [x_final e_num], 'rows'));
   
   if isempty(f_row) % our word has led us to an illegal state
       x_final = NaN;
       return;
   end       
   x_final = G.f(f_row,2);
end

% once found the final state of the word, we have to convert to the actual
% value of the state.

x_final = G.X(x_final,:);

end

