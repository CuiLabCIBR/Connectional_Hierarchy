clear
clc

working_dir = 'F:\Cui_Lab\Projects\Connectional_Hierarchy\';
addpath(genpath(working_dir))
var_dir = [working_dir 'data\fc_variability\'];
mat_dir = [working_dir 'data\network_matrix\'];
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
corr_method = 'spearman';

%%
r = cell(13,3);
r(1,:) = {'r-value','hcp-d','hcp-ya'};
r(2:end,1) = {'meg-delta','meg-theta','meg-alpha','meg-beta','meg-lgamma','meg-hgamma',...
              'sc','gene','receptor','cognition','disorder','fc'};
r_mat = zeros(12,2);
p = cell(13,3);
p(1,:) = {'p-value','hcp-d','hcp-ya'};
p(2:end,1) = {'meg-delta','meg-theta','meg-alpha','meg-beta','meg-lgamma','meg-hgamma',...
              'sc','gene','receptor','cognition','disorder','fc'};
p_mat = zeros(12,2);

%% fc intersubject variability
load('7net_label_schaefer400.mat')

load([var_dir 'fc_variability_hcpd.mat']);
load([var_dir 'fc_variability_hcp.mat']);

[r_hcp,p_hcp,hcpd_hcp_fc_variability] = corr_matrix(fc_variability_hcpd.schaefer400,fc_variability_hcp.schaefer400,net_label,net_order,corr_method);
%% meg
load('7net_label_schaefer400.mat')

meg_name = {'delta','theta','alpha','beta','lgamma','hgamma'};
for i = 1:6
    load([mat_dir 'meg_fc_' meg_name{i} '.mat'],'meg_fc')
    [r_mat(i,1),p_mat(i,1)] = corr_matrix(fc_variability_hcpd.schaefer400,meg_fc,net_label,net_order,corr_method);
    p_mat(i,1) = p_mat(i,1) * 6;
    [r_mat(i,2),p_mat(i,2)] = corr_matrix(fc_variability_hcp.schaefer400,meg_fc,net_label,net_order,corr_method);
    p_mat(i,2) = p_mat(i,2) * 6;
end

%% sc
load('7net_label_schaefer400.mat')

load([mat_dir 'sc_hcpd.mat'])
[r_mat(7,1),p_mat(7,1),hcpd_fc_variability_sc] = corr_matrix(fc_variability_hcpd.schaefer400,sc_mat,net_label,net_order,corr_method,sc_mask);
sc_log = log(hcpd_fc_variability_sc.mat_b);
hcpd_fc_variability_sc.mat_b = sc_log;

load([mat_dir 'sc_hcp.mat'])
[r_mat(7,2),p_mat(7,2),hcp_fc_variability_sc] = corr_matrix(fc_variability_hcp.schaefer400,sc_mat,net_label,net_order,corr_method,sc_mask);
sc_log = log(hcp_fc_variability_sc.mat_b);
hcp_fc_variability_sc.mat_b = sc_log;

%% gene
load('7net_label_schaefer400.mat')

load([mat_dir 'transcriptional_similarity.mat'])
[r_mat(8,1),p_mat(8,1)] = corr_matrix(fc_variability_hcpd.schaefer400,transcriptional_similarity,net_label,net_order,corr_method);
[r_mat(8,2),p_mat(8,2)] = corr_matrix(fc_variability_hcp.schaefer400,transcriptional_similarity,net_label,net_order,corr_method);

%% receptor
load('7net_label_schaefer400.mat')

load([mat_dir 'receptor_similarity.mat'])
[r_mat(9,1),p_mat(9,1)] = corr_matrix(fc_variability_hcpd.schaefer400,receptor_similarity,net_label,net_order,corr_method);
[r_mat(9,2),p_mat(9,2)] = corr_matrix(fc_variability_hcp.schaefer400,receptor_similarity,net_label,net_order,corr_method);

%% cognition
load('7net_label_schaefer400.mat')
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN

load([mat_dir 'cognitive_similarity.mat'])
[r_mat(10,1),p_mat(10,1)] = corr_matrix(fc_variability_hcpd.schaefer400,cognitive_similarity,net_label,net_order,corr_method);
[r_mat(10,2),p_mat(10,2)] = corr_matrix(fc_variability_hcp.schaefer400,cognitive_similarity,net_label,net_order,corr_method);

%% disorder
load(['7net_label_cammoun033.mat'])
net_order = [1 2 3 4 5 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN

load([mat_dir 'disorder_similarity.mat'])
[r_mat(11,1),p_mat(11,1)] = corr_matrix(fc_variability_hcpd.cammoun033,disorder_similarity,net_label,net_order,corr_method);
[r_mat(11,2),p_mat(11,2)] = corr_matrix(fc_variability_hcp.cammoun033,disorder_similarity,net_label,net_order,corr_method);

%% fc
load('7net_label_schaefer400.mat')
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN

load([mat_dir 'fc_hcpd.mat'])
[r_mat(12,1),p_mat(12,1)] = corr_matrix(fc_variability_hcpd.schaefer400,fc_mat,net_label,net_order,corr_method);
load([mat_dir 'fc_hcp.mat'])
[r_mat(12,2),p_mat(12,2)] = corr_matrix(fc_variability_hcp.schaefer400,fc_mat,net_label,net_order,corr_method);

%% save results
r(2:end,2:end) = num2cell(r_mat);
p(2:end,2:end) = num2cell(p_mat);
corr_results = [r,p];
corr_results = corr_results([1,13,2:12],:);
xlswrite('F:\Cui_Lab\Projects\Connectional_Hierarchy\fc_variability_correlation.xlsx',corr_results)