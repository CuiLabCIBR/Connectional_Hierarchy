% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 1.
% <Individual variability of edge-wise functional connectivity reveals connectional hierarchy in the human brain>
% The fc variability matrix was plotted at the nodal-level and network-level for HCP-D and HCP-YA.
% The similarity between the two datasets were measured by spearman correlation.
% The within-network and between-network fc variability values were compared using permutation test.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_02_connectional_hierarchy_of_inter_individual_fc_variability/'];
data_dir = [root_dir 'data/fc_variability/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 0; % if plot the lower triangle of the matrix, set it to 1.

%% plot the fc variability matrix for hcp-d
load([data_dir 'fc_variability_hcpd.mat']);
hcpd_schaefer400 = fc_variability_hcpd.schaefer400;

% nodal level
half_flag = 0;
plot_matrix(hcpd_schaefer400,net_label,net_order,half_flag)
caxis([0,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcpd_schaefer400_full.png'])
close all

half_flag = 1;
plot_matrix(hcpd_schaefer400,net_label,net_order,half_flag)
caxis([0,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcpd_schaefer400_half.png'])
close all

% network level
half_flag = 0;
plot_matrix_mean(hcpd_schaefer400,net_label,net_order,half_flag);
caxis([0,0.8]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcpd_schaefer400_net_full.png'])
close all

half_flag = 1;
hcpd_schaefer400_net = plot_matrix_mean(hcpd_schaefer400,net_label,net_order,half_flag);
caxis([0,0.8]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcpd_schaefer400_net_half.png'])
close all

% used in step_04_barplot_connectional_hierarchy.R
save([data_dir '/hcpd_schaefer400_net.mat'],'hcpd_schaefer400_net')

%% plot the fc variability matrix for hcp-ya
load([data_dir 'fc_variability_hcp.mat']);
hcp_schaefer400 = fc_variability_hcp.schaefer400;

% nodal level
half_flag = 0;
plot_matrix(hcp_schaefer400,net_label,net_order,half_flag)
caxis([0,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcp_schaefer400_full.png'])
close all

half_flag = 1;
plot_matrix(hcp_schaefer400,net_label,net_order,half_flag)
caxis([0,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcp_schaefer400_half.png'])
close all

% network level
half_flag = 0;
plot_matrix_mean(hcp_schaefer400,net_label,net_order,half_flag);
caxis([0,0.8]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcp_schaefer400_net_full.png'])
close all

half_flag = 1;
hcp_schaefer400_net = plot_matrix_mean(hcp_schaefer400,net_label,net_order,half_flag);
caxis([0,0.8]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_hcp_schaefer400_net_half.png'])
close all

% used in step_04_barplot_connectional_hierarchy.R
save([data_dir '/hcp_schaefer400_net.mat'],'hcp_schaefer400_net')

%% calculate the similarity between hcp-d and hcp-ya
corr_method = 'spearman';

% nodal-level similarity
[r_node,p_node,hcpd_hcp_schaefer400] = corr_matrix(fc_variability_hcpd.schaefer400,fc_variability_hcp.schaefer400,net_label,net_order,corr_method);

% used in step_02_density_plot_nodal_level.py
writetable(hcpd_hcp_schaefer400,[working_dir '/hcpd_hcp_fc_variability_schaefer400.csv'])

% network-level similarity
idx = find(tril(ones(6,6)) > 0);
[r_net,p_net] = corr(hcpd_schaefer400_net(idx),hcp_schaefer400_net(idx),'type',corr_method);
hcpd_hcp_schaefer400_net.hcpd = hcpd_schaefer400_net(idx);
hcpd_hcp_schaefer400_net.hcp = hcp_schaefer400_net(idx);
hcpd_hcp_schaefer400_net = struct2table(hcpd_hcp_schaefer400_net);

% used in step_03_scatterplot_network_level.R
writetable(hcpd_hcp_schaefer400_net,[working_dir 'hcpd_hcp_fc_variability_schaefer400_net.csv'])

%% permutation test between A-A, S-S and S-A fc variability
outpath = [data_dir, 'hcpd_'];
% used in step_05_barplot_S_A_axis.R
[S_S,A_A,S_A] = get_sensorimotor_association_fc_var(hcpd_schaefer400,net_label,net_order,outpath);

M = 10000
[p,diff_true] = permutation_test(A_A,S_S,M)
[p,diff_true] = permutation_test(A_A,S_A,M)
[p,diff_true] = permutation_test(S_S,S_A,M)

outpath = [data_dir, 'hcp_'];
% used in step_05_barplot_S_A_axis.R
[S_S,A_A,S_A] = get_sensorimotor_association_fc_var(hcp_schaefer400,net_label,net_order,outpath);
[p,diff_true] = permutation_test(A_A,S_S,M)
[p,diff_true] = permutation_test(A_A,S_A,M)
[p,diff_true] = permutation_test(S_S,S_A,M)