% ---------------------------------------------------------------------------------------------------------------
% This script is used to prepare data for fc variability calculation.
% The data is save as a 2D matrix, dim: (sess * subji) * edges.
% As the data matrix is too large, it is divided into 100 parts.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_01_individual_fc_variability/hcp/'];
fc_dir = [root_dir 'data/fc/'];

%% fc
load([fc_dir '/FC_schaefer400_12run_hcp.mat'],'all_session');
hcp_fc = permute(all_session,[2 1 3]);
% 12 sessions, 245 subjects, 79800 edges
hcp_fc = reshape(hcp_fc,[12*245,79800]);
save([fc_dir 'hcp_fc_schaefer400.mat'],'hcp_fc')

mkdir([fc_dir 'hcp'])

% divide the fc matrix into 100 parts
for i = 1:100
    idx = (i-1)*798+1:i*798;
    fc = hcp_fc(:,idx);
    save([fc_dir 'hcp/hcp_fc' num2str(i) '.mat'],'fc')
end

%% subject/session information
load([root_dir 'data/sub_info/hcp_sublist.mat'],'hcp_sublist')
subID = repmat(hcp_sublist,[1,12])';
subID = subID(:);
save([fc_dir 'subID_hcp.mat'],'subID')

for i = 1:12
    sess_str{i,1} = ['sess-' num2str(i)];
end
session = repmat(sess_str,[245,1]);
save([fc_dir 'session_hcp.mat'],'session')
