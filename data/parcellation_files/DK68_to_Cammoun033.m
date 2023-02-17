%
% this script is used to build the correspondence between
% DK-68 and Cammoun033, these two atals include same regions
% but wiht different order.

clear
clc

% addpath(genpath('/path/to/ENIGMA/matlab/'))
working_dir = 'F:\Cui_Lab\Projects\Connectional_Hierarchy\data\parcellation_files\';
cd(working_dir)
%%
[~, dk68_labels, ~, ~] = load_fc();
dk68_labels = dk68_labels';

load('Cammoun033_label.mat','Cammoun033_label');

for i = 1:68
    dk2cammoun(i,1) = find(ismember(dk68_labels,Cammoun033_label(i)));
end

save('dk2cammoun.mat','dk2cammoun')