% ---------------------------------------------------------------------------------------------------------------
% This script is used to prepare data for fc variability calculation.
% The data is save as a 2D matrix, dim: (sess * subji) * edges.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_01_individual_fc_variability/hcp/'];
fc_dir = [root_dir 'data/fc/'];

%% fc
load([fc_dir '/FC_cammoun033_12run_hcp.mat'],'all_session');
hcp_fc = permute(all_session,[2 1 3]);
% 12 sessions, 245 subjects, 79800 edges
hcp_fc = reshape(hcp_fc,[12*245,2278]);
save([fc_dir 'hcp_fc_cammoun033.mat'],'hcp_fc')

%% subject/session information
% load([root_dir 'data/sub_info/hcp_sublist.mat'],'hcp_sublist')
% subID = repmat(hcp_sublist,[1,12])';
% subID = subID(:);
% save([fc_dir 'subID_hcp.mat'],'subID')
% 
% for i = 1:12
%     sess_str{i,1} = ['sess-' num2str(i)];
% end
% session = repmat(sess_str,[245,1]);
% save([fc_dir 'session_hcp.mat'],'session')