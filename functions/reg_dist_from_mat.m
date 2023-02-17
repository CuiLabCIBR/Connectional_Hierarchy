function mat_reg_dist = reg_dist_from_mat(mat,dist)
% This function is used to regress the Euclidean distance from the connectivity matrix.
% input:
%       mat: N*N connectivity matrix, N is the number of nodes.
%       dist: N*N distance matrix¡£
% output:
%       mat_reg_dist: N*N connectivity matrix, regressed the Euclidean distance.

x = mat2vec(dist)'; % extract the lower triangle elements as a vector 
x = bsxfun(@minus, x, mean(x));

% Regression
y = mat2vec(mat)'; % extract the lower triangle elements as a vector 
[b,dev,stats] = glmfit(x,y); %% regression
con = b(1); %constsant term
resid = stats.resid; % residuals
z = resid+con; %% add constant term
mat_reg_dist = squareform(z); % convert vector to matrix