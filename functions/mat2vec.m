function data_vector = mat2vec(data_matrix)
% This function is used to extract the upper triangle of a 2-D matrix as a vector,
% and the data matrix and be recovered from the vector by using 'squareform'.
% input:
%       data_matrix: N*N data matrix, N is the number of nodes.
% output:
%       data_vector: M*1 data vector, M = N*(N-1)/2.

data_vector=[];
for n =1:size(data_matrix,1)
    tmp = data_matrix(n,n+1:end);
    data_vector = [data_vector,tmp;];
end

% data_matrix = squareform(data_vector);