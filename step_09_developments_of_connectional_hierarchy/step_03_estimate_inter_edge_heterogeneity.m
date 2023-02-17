% ---------------------------------------------------------------------------------------------------------------
% This script was used to generate results of Figure 8.
% <Development of connectional hierarchy in youth>
% Subjects from HCP-D were divided into fourteen groups, from 8 to 21 years.
% The inter-edge heterogeneity was then calculated for each age group.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_09_developments_of_connectional_hierarchy/'];
data_dir = [root_dir 'data/fc_variability/age_effects/'];
subinfo_dir = [root_dir 'data/sub_info/'];
load([subinfo_dir 'hcpd_sublist.mat'])

load('7net_label_schaefer400.mat')
% We excluded the limbic network in this study.
net_order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN. 
half_flag = 1;
%% separate the subjects into fourteen groups
load([root_dir 'data/sub_info/hcpd_subject_info.mat'])
hcpd_gender = hcpd_info(:,3);
hcpd_gender_num = ones(length(hcpd_gender),1);
idx = find(ismember(hcpd_gender,'F'));
hcpd_gender_num(idx) = 0;

hcpd_age_raw = cell2mat(hcpd_info(:,2));
hcpd_age = floor(hcpd_age_raw./12);

%% Get the averaged head motion and gender proportion in each age group
[~,~,HM_rest] = xlsread([subinfo_dir 'hcpd_rest_head_motion.xlsx']);
HM_rest = HM_rest(2:end,[2,6]);
[~,~,HM_task] = xlsread([subinfo_dir 'hcpd_task_head_motion.csv']);
HM_task = HM_task(2:end,[2,6]);

HM_all = [HM_rest;HM_task];

for sub_i = 1:length(hcpd_sublist_id)
    sub_name = hcpd_sublist_id{sub_i};
    idx = find(ismember(HM_all(:,1),sub_name));
    hcpd_HM(sub_i,1) = mean(cell2mat(HM_all(idx,2)));
end

hcpd_info = [hcpd_age_raw,hcpd_gender_num,hcpd_HM];

age_range = [8:21]';
for i = 1:length(age_range)
    hcpd_age_group{i,1} = find(hcpd_age == age_range(i));
    idx = hcpd_age_group{i};
    Age_group(i,1) = mean(hcpd_info(idx,1))./12;
    Gender_group(i,1) = sum(hcpd_info(idx,2))./length(idx);
    HM_group(i,1) = mean(hcpd_info(idx,3));
end
%% calculate the fc variability and inter-edge heterogeneity for each group

idx = find(tril(ones(6,6)));

for i = 1:14
    lme_path = [data_dir 'lme_' num2str(i) '.mat'];
    load(lme_path)
    b = lme.sigma2_b;
    w = lme.sigma2_w;
    b_w = b./w;
    b_w(isnan(b_w)) = 0;
    fc_variability_mat(:,:,i) = squareform(b_w);
    
    fc_variability_mat_mean = get_matrix_mean(fc_variability_mat(:,:,i),net_label,net_order);
    fc_variability_mean(i,:) = fc_variability_mat_mean(idx);
end

inter_edge_heterogeneity = mad(fc_variability_mean')';

%% Generate the data for GAM
Heterogeneity = inter_edge_heterogeneity;

% Age = age_range;
Age = Age_group;
Gender = Gender_group;
HeadMotion = HM_group;

[r,p] = partialcorr(Age,Heterogeneity,[Gender,HeadMotion])

tbl = table(Age,Gender,HeadMotion,Heterogeneity,'VariableNames',{'Age','Gender','HeadMotion','Heterogeneity'});
% used in step_04_gam_inter_edge_heterogeneity_age.R
writetable(tbl,[working_dir 'gam_age_heterogeneity.csv'])
