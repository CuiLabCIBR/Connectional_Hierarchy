function [p,diff_true] = permutation_test(x,y,rand_num)
% This function is used to perform the permutation test,
% which tests the mean value differences between two groups.
% input:
%       x: the data vector of group1.
%       y: the data vector of group2.
%       rand_num: the number of random iterations.
% output:
%       p: the significance level.
%       diff_true: the mean value differences between two groups.

x = x(:);
y = y(:);
idx_group1 = 1:length(x);
idx_group2 = 1:length(y);

data = [x;y];

diff_true = mean(x) - mean(y);
diff_rand = zeros(rand_num,1);

% permutation test
for iter_i = 1:rand_num
    idx_rand = randperm(length(data));
    idx_rand_group1 = idx_rand(idx_group1);
    idx_rand_group2 = idx_rand(idx_group2);
    rand_group1 = data(idx_rand_group1);
    rand_group2 = data(idx_rand_group2);
    diff_rand(iter_i) = mean(rand_group1) - mean(rand_group2);
end

if diff_true > 0
    p = (1+length(find(diff_rand >= diff_true)))/(rand_num+1);
else
    p = (1+length(find(diff_rand <= diff_true)))/(rand_num+1);
end