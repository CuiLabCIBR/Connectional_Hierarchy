function [r,p,mat_a_b] = corr_matrix(mat_a,mat_b,net_label,net_order,corr_method,mask,cov)
% This function is used to calculate the correlation between two matrices.
% input:
%       mat_a: N*N data matrix a, N is the node number.
%       mat_b: N*N data matrix b.
%       net_label: N*1 vector assigns each node to a network.
%       net_order: M*1 vector indicates the network order, M is the network number.
%       corr_method: the correlation method, default: 'spearman'.
%       mask: N*N mask, calculate the correlation within the mask if provided.
%       cov: N*N covariates matrix, calculate the partial correlation if provided.
% output£º
%       r: the correlation coefficient between mat_a and mat_b.
%       p: the significance level of the correlation.
%       mat_a_b: a table variabile includes the unique elements from mat_a and mat_b.

if nargin < 5
    corr_method = 'spearman';
end

%% reorder the data matrix
t = [];

for i = 1:length(net_order)
    add = find(net_label == net_order(i));
    t = [t;add];
end

mat_a = mat_a(t,t);
mat_b = mat_b(t,t);

%% apply a mask 
if nargin > 5
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

%% calculate the correlation between mat_a and mat_b
if nargin < 7
    [r,p] = corr(mat_a_vector,mat_b_vector,'type',corr_method);
else   
    cov = cov(t,t);
    cov = cov .* mask;
    cov_vector = mat2vec(cov)';
    cov_vector(mask_vector==0) = [];
    [r,p] = partialcorr(mat_a_vector,mat_b_vector,cov_vector,'type',corr_method);
end

%% save the results
mat_a_b.mat_a = mat_a_vector;
mat_a_b.mat_b = mat_b_vector;
mat_a_b = struct2table(mat_a_b);