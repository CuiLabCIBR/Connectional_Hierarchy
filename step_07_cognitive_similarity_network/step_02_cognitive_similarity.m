% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate figures and results of Figure 6.
% <Implications of connectional hierarchy in cognitions>
% The similarity between fc variability and cognitive similarity were measured by spearman correlation.
% The activation probability maps were obtained using neurosynth (https://github.com/neurosynth/neurosynth).
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_07_cognitive_similarity_network/'];
neurosynth_dir = [working_dir 'cognitive_atlas/images/'];
parcellation_dir = [root_dir 'data/parcellation_files/'];

data_dir = [root_dir 'data/fc_variability/'];
mat_dir = [root_dir 'data/network_matrix/'];

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN.
half_flag = 1; % if plot the lower triangle of the matrix, set it to 1.

corr_method = 'spearman';
%% get cognitive similarity network
file_suffix = '*_association-test_z.nii.gz';
term_items = dir(neurosynth_dir);
term_items(1:2)=[];
schaefer_400 = spm_vol([parcellation_dir 'Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz']);
schaefer_400_data = spm_read_vols(schaefer_400);

for n = 1:length(term_items)
    activation_image = dir([neurosynth_dir term_items(n).name filesep file_suffix]);
    activation_image = [activation_image(1).folder filesep activation_image(1).name];
    activation_str = spm_vol(activation_image);
    activation_data = spm_read_vols(activation_str);
    for label=1:400
        label_idx = find(schaefer_400_data==label);
        region_prob = activation_data(label_idx);
        region_prob_mean(label,n) = mean(region_prob);
    end
end

cognitive_similarity = corrcoef(region_prob_mean');
save([mat_dir 'cognitive_similarity.mat'],'cognitive_similarity')

% plot the cognitive similarity matrix at nodal level
half_flag = 0;
plot_matrix(cognitive_similarity,net_label,net_order)
caxis([-0.5,0.8])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_cognitive_similarity_full.png'])
close all

half_flag = 1;
plot_matrix(cognitive_similarity,net_label,net_order,half_flag)
caxis([-0.5,0.8])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_cognitive_similarity_half.png'])
close all

% plot the cognitive similarity matrix at network level
half_flag = 1;
cognitive_similarity_net = plot_matrix_mean(cognitive_similarity,net_label,net_order,half_flag);
caxis([-0.2,0.39])
print(gcf,'-dpng','-r300',[working_dir '/matrix_plot_cognitive_similarity_net_half.png'])
close all

%% calculate the correlation between fc variability and cognitive similarity
% HCP-D
load([data_dir 'fc_variability_hcpd.mat']);
[r_hcpd,p_hcpd,hcpd_fc_variability_gene] = corr_matrix(fc_variability_hcpd.schaefer400,cognitive_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcpd_fc_variability_gene,[working_dir '/hcpd_fc_variability_cognitive_similarity.csv'])

% HCP-YA
load([data_dir 'fc_variability_hcp.mat']);
[r_hcp,p_hcp,hcp_fc_variability_gene] = corr_matrix(fc_variability_hcp.schaefer400,cognitive_similarity,net_label,net_order,corr_method);

% used in step_03_density_plot.py
writetable(hcp_fc_variability_gene,[working_dir '/hcp_fc_variability_cognitive_similarity.csv'])