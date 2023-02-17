% ---------------------------------------------------------------------------------------------------------------
% This script is used to calculate the functional connectivity.
% Schaefer400 atlas was used, generating a 400*400 matrix.
% Timepoints with FD > 0.3 were excluded from the correlation analysis.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/'));

sub_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/data/xcpd_0.1.0/hcp_d/xcp_d/';
working_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/hcp';
bold_dir = [working_dir '/bold_signal/'];
fc_dir = [working_dir '/fc_matrix'];
mkdir(fc_dir)

load('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/hcp_sublist.mat')
sub_num = length(hcp_sublist);

%% FC estimation based on 12 runs
clear all_session_mat
clear all_session

for sub_i = 1:sub_num  % for each subject
    sub_i
    sub_name = hcp_sublist{sub_i};
    parcel_name = [bold_dir '/schaefer400_12run/' sub_name filesep 'data_parcel.mat'];    
    sub_data = load(parcel_name);sub_data = sub_data.data_parcel_12run;
    
    load([sub_dir sub_name '/func/' sub_name '_censor.mat'],'censor_12run')
       
    for run_i = 1:12
        censor_flag = censor_12run(:,run_i);
        schaefer400 = squeeze(sub_data(2:end,censor_flag,run_i));
        
        z_corr_data = atanh(corr(schaefer400'));
        all_session_mat(sub_i,run_i,:,:) = z_corr_data;
        all_session(sub_i,run_i,:) = mat2vec(z_corr_data);
    end
       
end

save([fc_dir '/FC_schaefer400_12run_hcp.mat'],'all_session','-v7.3');
save([fc_dir '/FC_schaefer400_12run_mat_hcp.mat'],'all_session_mat','-v7.3');

%%
fc_hcp = squareform(squeeze(mean(mean(all_session))));
save('F:/Cui_Lab/Connectional_Hierarchy/data/network_matrix/fc_hcp.mat','fc_hcp');