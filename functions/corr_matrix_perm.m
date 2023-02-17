function [r_true,r_rand,p,mat_a_b] = corr_matrix_perm(mat_a,mat_b,rand_num,corr_method,net_label,net_order,mask)
% This function is used to calculate the correlation between two matrices.
% input:
%       mat_a: N*N data matrix a, N is the node number.
%       mat_b: N*N data matrix b.
%       rand_num: the number of random iterations.
%       corr_method: the correlation method, default: 'spearman'.
%       net_label: N*1 vector assigns each node to a network.
%       net_order: M*1 vector indicates the network order, M is the network number.
%       mask: N*N mask, calculate the correlation within the mask if provided.
% output£º
%       r_ture: the correlation coefficient between mat_a and mat_b.
%       r_rand: the correlation coefficient between randomized mat_a and mat_b.
%       p: the significance level of the correlation.
%       mat_a_b: a table variabile includes the unique elements from mat_a and mat_b.

if nargin < 4
    corr_method = 'spearman';
end

[node_num,~] = size(mat_a);

if exist('net_label') && exist('net_order')
    %% reorder the data matrix
    t = [];
    
    for i = 1:length(net_order)
        add = find(net_label == net_order(i));
        t = [t;add];
    end
    
    %     net_rand = randperm(length(net_order));
    %     for i = 1:length(net_order)
    %         add = find(net_label == net_order(net_rand(i)));
    %         add = add(randperm(length(add)));
    %         t = [t;add];
    %     end
    
    mat_a = mat_a(t,t);
    mat_b = mat_b(t,t);
    
    [node_num,~] = size(mat_a);
end

%% apply a mask 
if exist('mask')
    mask = mask(t,t);
    mat_a = mat_a .* mask;
    mat_b = mat_b .* mask; 
    mask_vector = mat2vec(mask)';
    mat_a_vector = mat2vec(mat_a)';
    mat_b_vector = mat2vec(mat_b)';
    mat_a_vector(mask_vector==0) = [];
    mat_b_vector(mask_vector==0) = [];
else
    mat_a_vector = mat2vec(mat_a)';
    mat_b_vector = mat2vec(mat_b)';
end

r_true = corr(mat_a_vector,mat_b_vector,'type',corr_method);

% permutation test
for rand_i = 1:rand_num
    idx_rand = randperm(node_num);
    mat_a_rand = mat_a(idx_rand,idx_rand);
    mat_a_rand_vector = mat2vec(mat_a_rand)';
    if exist('mask')
        mask_rand = mask(idx_rand,idx_rand);
        mask_rand_vector = mat2vec(mask_rand)';
        mat_a_rand_vector(mask_rand_vector == 0) = [];
    end
    r_rand(rand_i,1) = corr(mat_a_rand_vector,mat_b_vector,'type',corr_method);
end

if r_true > 0
    p = (1+length(find(r_rand >= r_true)))/(rand_num+1);
else
    p = (1+length(find(r_rand <= r_true)))/(rand_num+1);
end

%% save the results
mat_a_b.mat_a = mat_a_vector;
mat_a_b.mat_b = mat_b_vector;
mat_a_b = struct2table(mat_a_b);