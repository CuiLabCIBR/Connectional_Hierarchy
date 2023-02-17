% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 4.
% <Transcriptional similarity of gene expression underlying connectional hierarchy>
% The similarity between fc variability and correlated gene expression were measured by spearman correlation.
% The gene expression data were obatined using abagen (https://abagen.readthedocs.io), 
% Brain-specific genes were analyzed (Fagerberg, 2014).
% Fagerberg, L., Hallstr?m, B. M., Oksvold, P., Kampf, C., Djureinovic, D., Odeberg, J., ... & Uhl¨¦n, M. (2014). 
% Analysis of the human tissue-specific expression by genome-wide integration of transcriptomics and antibody-based proteomics.
% Molecular & cellular proteomics, 13(2), 397-406.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_05_correlated_gene_expression_network/'];
data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 0; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';
%% get the correlated gene expression network
[gene_expressions_schaefer400,gene_label] = xlsread([working_dir 'gene_expressions_schaefer400.csv']);
gene_expressions_schaefer400(:,1) = [];
gene_label(1) = [];
gene_label = gene_label';

% brain-specific genes
[~,brain_gene_label] = xlsread([working_dir 'brain_gene_label.xlsx']);
idx_brain_gene = find(ismember(gene_label,brain_gene_label));
brain_gene_expressions_schaefer400 = gene_expressions_schaefer400(:,idx_brain_gene);
transcriptional_similarity = corrcoef(brain_gene_expressions_schaefer400');
save([mat_dir 'transcriptional_similarity.mat'],'transcriptional_similarity')

% plot the transcriptional similarity matrix at nodal level
half_flag = 0;
plot_matrix(transcriptional_similarity,net_label,net_order)
caxis([-0.6,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_transcriptional_similarity_full.png'])
close all

half_flag = 1;
plot_matrix(transcriptional_similarity,net_label,net_order,half_flag)
caxis([-0.6,1]);
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_transcriptional_similarity_half.png'])
close all

% plot the transcriptional similarity matrix at network level
half_flag = 1;
transcriptional_similarity_net = plot_matrix_mean(transcriptional_similarity,net_label,net_order,half_flag);
caxis([-0.25,0.4])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_transcriptional_similarity_net_half.png'])
close all

%% HCP-D
load([data_dir 'fc_variability_hcpd.mat']);
[r_hcpd,p_hcpd,hcpd_fc_variability_gene] = corr_matrix(fc_variability_hcpd.schaefer400,transcriptional_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcpd_fc_variability_gene,[working_dir '/hcpd_fc_variability_transcriptional_similarity.csv'])

%% HCP-YA
load([data_dir 'fc_variability_hcp.mat']);
[r_hcp,p_hcp,hcp_fc_variability_gene] = corr_matrix(fc_variability_hcp.schaefer400,transcriptional_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcp_fc_variability_gene,[working_dir '/hcp_fc_variability_transcriptional_similarity.csv'])