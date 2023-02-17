% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 3.
% <Structural connectome basis of connectional hierarchy in FC variability>
% The similarity between fc variability matrix and sc matrix were measured by spearman correlation.
% Correlation analysis only used none-zero connections of the sc matrix.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_04_white_matter_structural_network/'];
data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 1; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';

load([data_dir 'fc_variability_hcpd.mat']);
load([data_dir 'fc_variability_hcp.mat']);

%% HCP-D
load([mat_dir 'sc_hcpd.mat'])

% plot the sc matrix at nodal level
sc = log(sc_mat .* sc_mask);

half_flag = 0;
plot_matrix(sc,net_label,net_order,half_flag)
caxis([min(sc(sc_mask)),max(sc(sc_mask))]);
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_hcpd_full.png'])
close all

half_flag = 1;
plot_matrix(sc,net_label,net_order,half_flag)
caxis([min(sc(sc_mask)),max(sc(sc_mask))]);
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_hcpd_half.png'])
close all

% plot the sc matrix at network level
half_flag = 1;
sc_net = plot_sc_mean(sc_mat .* sc_mask,net_label,net_order,half_flag);
caxis([-3,0.5])
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_mean_hcpd_half.png'])
close all

% similarity between fc variability and sc
[r_hcpd,p_hcpd,hcpd_fc_variability_sc] = corr_matrix(fc_variability_hcpd.schaefer400,sc_mat,net_label,net_order,corr_method,sc_mask);
sc_log = log(hcpd_fc_variability_sc.mat_b);
hcpd_fc_variability_sc.mat_b = sc_log;

% used in step_02_density_plot.py
writetable(hcpd_fc_variability_sc,[working_dir '/hcpd_fc_variability_sc.csv']) 

%% HCP-YA
load([mat_dir 'sc_hcp.mat'])

% plot the sc matrix at nodal level
sc = log(sc_mat .* sc_mask);

half_flag = 0;
plot_matrix(sc,net_label,net_order,half_flag)
caxis([min(sc(sc_mask)),max(sc(sc_mask))]);
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_hcp_full.png'])
close all

half_flag = 1;
plot_matrix(sc,net_label,net_order,half_flag)
caxis([min(sc(sc_mask)),max(sc(sc_mask))]);
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_hcp_half.png'])
close all

% plot the sc matrix at network level
half_flag = 1;
sc_net = plot_sc_mean(sc_mat .* sc_mask,net_label,net_order,half_flag);
caxis([-3,-0.4])
print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_sc_network_mean_hcp_half.png'])
close all

% similarity between fc variability and sc
[r_hcp,p_hcp,hcp_fc_variability_sc] = corr_matrix(fc_variability_hcp.schaefer400,sc_mat,net_label,net_order,corr_method,sc_mask);
sc_log = log(hcp_fc_variability_sc.mat_b);
hcp_fc_variability_sc.mat_b = sc_log;

% used in step_02_density_plot.py
writetable(hcp_fc_variability_sc,[working_dir '/hcp_fc_variability_sc.csv']) 