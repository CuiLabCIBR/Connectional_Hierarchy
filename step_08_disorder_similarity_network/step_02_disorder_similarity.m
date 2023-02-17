% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 7.
% <Implications of connectional hierarchy on brain disorders>
% The similarity between fc variability and disorder similarity were measured by spearman correlation.
% The limbic network was not excluded and the network-level analysis was not performed here.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_08_disorder_similarity_network/'];
neurosynth_dir = [working_dir 'cognitive_atlas/images/'];
parcellation_dir = [root_dir 'data/parcellation_files/'];

data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_cammoun033.mat')
% we didn't exclude limbic network here
net_order = [1 2 3 4 5 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
half_flag = 0; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';
%% get disorder similarity network
load([root_dir 'data/enigma_results/enigma_ct_cammoun033.mat'])
enigma_ct = cell2mat(enigma_ct_cammoun033(2:end,2:end));
enigma_ct = zscore(enigma_ct);
disorder_similarity = corrcoef(enigma_ct');
save([mat_dir 'disorder_similarity.mat'],'disorder_similarity')

% plot the disorder similarity matrix at nodal level
plot_matrix(disorder_similarity)
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_disorder_similarity.png'])
close all

%% HCP-D
load([data_dir 'fc_variability_hcpd.mat']);

% plot the fc variability matrix at nodal level
plot_matrix(fc_variability_hcpd.cammoun033)
caxis([0,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcpd_cammoun033.png'])
close all

% similarity between fc variability and disorder similarity
[r_hcpd,p_hcpd,hcpd_fc_variability_gene] = corr_matrix(fc_variability_hcpd.cammoun033,disorder_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcpd_fc_variability_gene,[working_dir '/hcpd_fc_variability_disorder_similarity.csv'])

%% HCP-YA
load([data_dir 'fc_variability_hcp.mat']);

% plot the fc variability matrix at nodal level
plot_matrix(fc_variability_hcp.cammoun033)
caxis([0,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcp_cammoun033.png'])
close all

% similarity between fc variability and disorder similarity
[r_hcp,p_hcp,hcp_fc_variability_gene] = corr_matrix(fc_variability_hcp.cammoun033,disorder_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcp_fc_variability_gene,[working_dir '/hcp_fc_variability_disorder_similarity.csv'])