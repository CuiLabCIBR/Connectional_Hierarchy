% ---------------------------------------------------------------------------------------------------------------
% This script is used to prepare data for fc variability calculation.
% The subjects from the HCP-D were split into 14 groups (8 to 21 years).
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_01_individual_fc_variability/hcpd/'];
fc_dir = [root_dir 'data/fc/'];

%%
load([fc_dir '/FC_schaefer400_8run_hcpd.mat'],'all_session');
hcpd_fc = permute(all_session,[2 1 3]);

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
load([root_dir 'data/sub_info/hcpd_subject_info.mat'])
hcpd_age = cell2mat(hcpd_info(:,2));
hcpd_age = floor(hcpd_age./12);

age_group = [8:21]';
for i = 1:length(age_group)
    hcpd_age_group{i,1} = find(hcpd_age == age_group(i));
end

load([root_dir 'data/sub_info/hcpd_sublist.mat'],'hcpd_sublist_id')

%%
for i = 1:14
    idx = hcpd_age_group{i};
    fc = hcpd_fc(:,idx,:);
    fc = reshape(fc,[8*length(idx),79800]);
    save([fc_dir 'age_effects/fc_' num2str(i) '.mat'],'fc')
end