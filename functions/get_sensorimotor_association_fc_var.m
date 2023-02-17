function [S_S,A_A,S_A] = get_sensorimotor_association_fc_var(data_mat,net_label,net_order,out_path)
% This function is used to get edges within sensorimotor, within
% association and between sensorimotor and association networks.
% input:
%       data_mat:  N*N data matrix, N is the node number.
%       net_label: N*1 vector assigns each node to a network.
%       net_order: M*1 vector indicates the network order, M is the network number.
%       out_path: filepath to save output results.
% output£º
%       S_S: edges within sensorimotor (S-S) networks (i.e., VS,SM).
%       A_A: edges within association (A-A) networks (i.e., DA,VA,FP,DM).
%       S_A: edges between sensorimotor and association (S-A) networks.

t = [];
start = 1;
lines = 1;

for i = 1:length(net_order)
    add = find(net_label==net_order(i));
    t = [t;add];
    start = start + length(add);
    lines(i+1) = start;
end

data_reorder = data_mat(t,t);

%%
VS = mat2vec(data_reorder(lines(1):lines(2)-1,lines(1):lines(2)-1));%visual
SM = mat2vec(data_reorder(lines(2):lines(3)-1,lines(2):lines(3)-1));%somatomotor
VS_SM = reshape(data_reorder(lines(1):lines(2)-1,lines(2):lines(3)-1),1,61*77);
S_S = [VS,SM,VS_SM];

A_A = mat2vec(data_reorder(lines(3):lines(7)-1,lines(3):lines(7)-1));

S_A = data_reorder(lines(3):lines(7)-1,lines(1):lines(3)-1);
S_A = reshape(S_A,1,236*138);

if exist('out_path','var')
    save([out_path 'fc_variability_S_S.mat'],'S_S');
    save([out_path 'fc_variability_A_A.mat'],'A_A');
    save([out_path 'fc_variability_S_A.mat'],'S_A');
end