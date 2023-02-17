% ---------------------------------------------------------------------------------------------------------------
% This script is used to prepare data for fc variability calculation.
% The data is save as a 2D matrix, dim: (sess * subji) * edges.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_01_individual_fc_variability/hcpd/'];
fc_dir = [root_dir 'data/fc/'];

%% fc
load([fc_dir '/FC_cammoun033_8run_hcpd.mat'],'all_session');
hcpd_fc = permute(all_session,[2 1 3]);
% 8 sessions, 415 subjects, 79800 edges
hcpd_fc = reshape(hcpd_fc,[8*415,2278]);
save([fc_dir 'hcpd_fc_cammoun033.mat'],'hcpd_fc')

%% subject/session information
load([root_dir 'data/sub_info/hcpd_sublist.mat'],'hcpd_sublist_id')
subID = repmat(hcpd_sublist_id,[1,8])';
subID = subID(:);
save([fc_dir 'subID_hcpd.mat'],'subID')

for i = 1:8
    sess_str{i,1} = ['sess-' num2str(i)];
end
session = repmat(sess_str,[415,1]);
save([fc_dir 'session_hcpd.mat'],'session')

