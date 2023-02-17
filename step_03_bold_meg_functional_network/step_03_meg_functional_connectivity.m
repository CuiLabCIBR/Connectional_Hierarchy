% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 2.
% <Hemodynamic and electrophysiological functional connectome basis of connectional hierarchy>
% The similarity between fc variability matrix and meg connectivity matrix were measured by spearman correlation.
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

load([data_dir 'fc_variability_hcpd.mat']);
load([data_dir 'fc_variability_hcp.mat']);

%% calculate the correlation between meg connectivity and fc variability
meg_name = {'delta','theta','alpha','beta','lgamma','hgamma'};
for i = 1:6
    load([mat_dir 'meg_fc_' meg_name{i} '.mat'],'meg_fc')
    % plot the meg fc matrix
    plot_matrix(meg_fc,net_label,net_order,half_flag)
    print(gcf,'-dpng','-r300',[working_dir 'matrix_plot_meg_network_' meg_name{i} '.png'])
    close all
        
    [r_hcpd(i,1),p_hcpd(i,1)] = corr_matrix(fc_variability_hcpd.schaefer400,meg_fc,net_label,net_order,corr_method);
    p_hcpd(i,1) = p_hcpd(i,1) * 12; % bonferroni correction
    [r_hcp(i,1),p_hcp(i,1)] = corr_matrix(fc_variability_hcp.schaefer400,meg_fc,net_label,net_order,corr_method);
    p_hcp(i,1) = p_hcp(i,1) * 12; % bonferroni correction
end
r = [r_hcpd;r_hcp];
p = [p_hcpd;p_hcp];

meg_corr_results = cell(13,4);
meg_corr_results(1,:) = {'Frequency','Rho','P value','Dataset'};
meg_corr_results(2:end,1) = repmat({'Delta';'Theta';'Alpha';'Beta';'Low-gamma';'High-gamma'},[2,1]);
meg_corr_results(2:end,4) = [repmat({'HCP-D'},[6,1]);repmat({'HCP-YA'},[6,1])];
meg_corr_results(2:end,2) = num2cell(r);
meg_corr_results(2:end,3) = num2cell(p);

% used in step_02_barplot_fc_variability_meg_connectivity_corr.R
xlswrite([working_dir 'meg_corr_results.xlsx'],meg_corr_results) 
