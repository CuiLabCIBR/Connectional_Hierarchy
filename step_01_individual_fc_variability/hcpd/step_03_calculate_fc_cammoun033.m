% ---------------------------------------------------------------------------------------------------------------
% This script is used to calculate the functional connectivity.
% Cammoun033 atals was used, generating a 68*68 matrix.
% Timepoints with FD > 0.3 were excluded from the correlation analysis.
% Notes: the individual fMRI data is stored on the server and not shared in this project.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/'));

sub_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/data/xcpd_0.1.0/hcp_d/xcp_d/';
working_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/hcpd';
bold_dir = [working_dir '/bold_signal/'];
fc_dir = [working_dir '/fc_matrix'];
mkdir(fc_dir)

load('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/hcpd_sublist.mat')
sub_num = length(hcpd_sublist);

%% FC estimation based on 8 runs
clear all_session_mat
clear all_session

for sub_i = 1:sub_num  % for each subject
    sub_i
    sub_name = hcpd_sublist{sub_i};
    parcel_name = [bold_dir '/cammoun033_8run/' sub_name filesep 'data_parcel.mat'];    
    sub_data = load(parcel_name);sub_data = sub_data.data_parcel_8run;
    
    load([sub_dir sub_name '/func/' sub_name '_censor.mat'],'censor_8run')
       
    for run_i = 1:8
        censor_flag = censor_8run(:,run_i);
        cammoun033 = squeeze(sub_data(2:end,censor_flag,run_i));
        
        z_corr_data = atanh(corr(cammoun033'));
        all_session_mat(sub_i,run_i,:,:) = z_corr_data;
        all_session(sub_i,run_i,:) = mat2vec(z_corr_data);
    end
       
end

save([fc_dir '/FC_cammoun033_8run_hcpd.mat'],'all_session','-v7.3');
