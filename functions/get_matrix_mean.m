function [data_mat_mean,net_edges] = get_matrix_mean(data_mat,net_label,net_order)
% This function is used to get the network-avearged values of a nodal-level matrix.
% input:
%       data_mat:  N*N data matrix, N is the node number.
%       net_label: N*1 vector assigns each node to a network.
%       net_order: M*1 vector indicates the network order, M is the network number.
% output£º
%       data_mat_mean: M*M network-avearged matrix.
%       net_edges: M*M cell matrix which stores edges within and between networks.

if exist('net_order','var')
    order = net_order;
else
    order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
end

t = [];
start = 1;
lines = 1;
mask = net_label;

for i = 1:length(order)
    add = find(mask==order(i));
    t = [t;add];
    start = start + length(add);
    lines(i+1) = start;
end

data_reorder = data_mat(t,t);
data_dim = size(data_reorder);

%%
idx_begin = lines(1:end-1);
idx_end = lines(2:end)-1;

for i = 1:length(lines)-1
   for j = 1:length(lines)-1
       data_temp = data_reorder(idx_begin(i):idx_end(i),idx_begin(j):idx_end(j));
       if i == j
           data_temp = mat2vec(data_temp);
       end
       data_temp = data_temp(:);
       data_mat_mean(i,j) = mean(data_temp);
       net_edges{i,j} = data_temp;
   end
end