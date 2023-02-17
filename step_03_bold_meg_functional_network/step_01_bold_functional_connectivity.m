% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 2.
% <Hemodynamic and electrophysiological functional connectome basis of connectional hierarchy>
% The similarity between fc variability matrix and bold connectivity matrix were measured by spearman correlation.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_03_bold_meg_functional_network/'];
data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 0; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';

%% HCP-D
fc_hcpd = load([mat_dir 'fc_hcpd.mat']);
fc_hcpd = fc_hcpd.fc_mat;

% plot the bold fc matrix at nodal level
half_flag = 0;
plot_matrix(fc_hcpd,net_label,net_order,half_flag)
caxis([-0.7,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcpd_full.png'])
close all

half_flag = 1;
plot_matrix(fc_hcpd,net_label,net_order,half_flag)
caxis([-0.7,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcpd_half.png'])
close all

% plot the bold fc matrix at network level
half_flag = 1;
fc_hcpd_net = plot_matrix_mean(fc_hcpd,net_label,net_order,half_flag);
caxis([-0.36,0.36])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcpd_net_half.png'])
close all

load([data_dir 'fc_variability_hcpd.mat']);
[r_hcpd,p_hcpd,hcpd_fc_variability_fc] = corr_matrix(fc_variability_hcpd.schaefer400,fc_hcpd,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcpd_fc_variability_fc,[working_dir '/hcpd_fc_variability_fc_hcpd.csv'])

%% HCP-YA
fc_hcp = load([mat_dir 'fc_hcp.mat']);
fc_hcp = fc_hcp.fc_mat;

% plot the bold fc matrix at nodal level
half_flag = 0;
plot_matrix(fc_hcp,net_label,net_order)
caxis([-0.7,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcp_full.png'])
close all

half_flag = 1;
plot_matrix(fc_hcp,net_label,net_order,half_flag)
caxis([-0.7,0.7]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcp_half.png'])
close all

% plot the bold fc matrix at network level
half_flag = 1;
fc_hcp_net = plot_matrix_mean(fc_hcp,net_label,net_order,half_flag);
caxis([-0.36,0.36])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_fc_hcp_net_half.png'])
close all

load([data_dir 'fc_variability_hcp.mat']);
[r_hcp,p_hcp,hcp_fc_variability_fc] = corr_matrix(fc_variability_hcp.schaefer400,fc_hcp,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcp_fc_variability_fc,[working_dir '/hcp_fc_variability_fc_hcp.csv'])
