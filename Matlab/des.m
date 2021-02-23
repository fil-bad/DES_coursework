clear variables
clc
close all

%% DES Coursework


%% Automata definition
% Map Automaton

G_M = struct("E",0, "X",0, "f",0, "x0",0);

G_M.E = ['n','s','e','w']';
G_M.X = ["Rm1","Rm2","Rm3","Rm4","Rm5","Rm6","Rm7"]';
G_M.f = [
    1,2,3;
    2,1,4;
    2,3,2;
    3,2,1;
    3,7,3;
    7,3,4;
    3,4,2;
    4,3,1;
    4,5,2;
    5,4,1;
    5,6,4;
    6,5,3
    ];
G_M.x0 = "Rm1";


% Robot Automaton

G_R = struct("E",0, "X",0, "f",0, "x0",0);

G_R.E = ['n','s','e','w','r']';
G_R.X = ["N","S","E","W"]';
G_R.f = [
    1,1,1;
    1,3,5;
    2,2,2;
    2,4,5;
    3,3,3;
    3,2,5;
    4,4,4;
    4,1,5
    ];
G_R.x0 = "N";

%% Build the parallel automaton

G_Tot = par_comp(G_M, G_R);

%% Build the partially observable automaton

G_N = partial_obs(G_Tot);

%% Build the observer (for non-observable case)

G_obs = observer(G_Tot);

%sum of each column, for each row
row_sum = sum(G_obs.X);

%sum of each row, for each column
col_sum = sum(G_obs.X')';

[U,S,V] = svd(G_obs.X);

sing_values = diag(S(1:4,1:4));

% 

%% Explore the observer automaton

word = ['m','r','r','m','r','m','r','r','m','r','m'];

x_final = explore_obs(G_obs, word);
if ~isnan(x_final)
    % so the final possible states from the original set are:
    x_fin_or = G_Tot.X(find(x_final));
    
    disp(x_fin_or)
else
    disp("We ended up in an empty state.")
end
%% PART II: new map M2.

% Mew map Automaton.

G_M2 = struct("E",0, "X",0, "f",0, "x0",0);

G_M2.E = ['n','s','e','w']';
G_M2.X = ["Rm1","Rm2","Rm3","Rm4","Rm5","Rm6"]';
G_M2.f = [
    1,2,3;
    2,1,4;
    2,3,2;
    3,2,1;
    3,4,2;
    4,3,1;
    4,5,2;
    5,4,1;
    5,6,3;
    6,5,4
    ];
G_M2.x0 = "Rm1";

G_Tot2 = par_comp(G_M2, G_R);
G_N2 = partial_obs(G_Tot2);
G_obs2 = observer(G_Tot2);

%sum of each column, for each row
row_sum2 = sum(G_obs2.X);

%sum of each row, for each column
col_sum2 = sum(G_obs2.X')';


[U2,S2,V2] = svd(G_obs2.X); % there are singular eigs in S2

sing_values2 = diag(S2(1:4,1:4));


x_final2 = explore_obs(G_obs2, word);    

if ~isnan(x_final2)
    % so the final possible states with the new automaton are:
    x_fin_or2 = G_Tot2.X(find(x_final2));
    
    disp(x_fin_or2)
else
    disp("We ended up in an empty state.")
end








