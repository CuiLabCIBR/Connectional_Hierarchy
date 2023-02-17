% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 5.
% <Network of neurotransmitter receptors and transporters expression shapes connectional hierarchy>
% The similarity between fc variability and receptor similarity were measured by spearman correlation.
% The node*receptor matrix was obtained from (Hansen,2022).
% Hansen, J. Y., Shafiei, G., Markello, R. D., Smart, K., Cox, S. M., N?rgaard, M., ... & Misic, B. (2022). 
% Mapping neurotransmitter systems to the structural and functional organization of the human neocortex. 
% Nature Neuroscience, 25(11), 1569-1581.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_06_receptor_similarity_network/'];
data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 1; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';
%% get the receptor similarity network
% get from Hansen, 2022
% https://github.com/netneurolab/hansen_receptors/tree/main/results
receptor_density = importdata([working_dir 'receptor_data_scale400.csv']);
receptor_density = zscore(receptor_density);
receptor_similarity = corrcoef(receptor_density');
save([mat_dir 'receptor_similarity.mat'],'receptor_similarity')

% plot the receptor similarity matrix at nodal level
half_flag = 0;
plot_matrix(receptor_similarity,net_label,net_order)
caxis([-1,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_receptor_similarity_full.png'])
close all

half_flag = 1;
plot_matrix(receptor_similarity,net_label,net_order,half_flag)
caxis([-1,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_receptor_similarity_half.png'])
close all

% plot the receptor similarity matrix at network level
half_flag = 1;
receptor_similarity_net = plot_matrix_mean(receptor_similarity,net_label,net_order,half_flag);
caxis([-0.35,0.35])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_receptor_similarity_net_half.png'])
close all

%% calculate the correlation between fc variability and receptor similarity
% HCP-D
load([data_dir 'fc_variability_hcpd.mat']);
[r_hcpd,p_hcpd,hcpd_fc_variability_receptor] = corr_matrix(fc_variability_hcpd.schaefer400,receptor_similarity,net_label,net_order,corr_method);

% used in step_02_density_plot.py
writetable(hcpd_fc_variability_receptor,[working_dir '/hcpd_fc_variability_receptor_similarity.csv'])

% HCP-YA
load([data_dir 'fc_variability_hcp.mat']);
[r_hcp,p_hcp,hcp_fc_variability_receptor] = corr_matrix(fc_variability_hcp.schaefer400,receptor_similarity,net_label,net_order,corr_method);

% used in step_02_density_plot.py
writetable(hcp_fc_variability_receptor,[working_dir '/hcp_fc_variability_receptor_similarity.csv'])