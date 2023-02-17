% ---------------------------------------------------------------------------------------------------------------
% This script is used to separate the dtseries.nii into L.func.gii and R.func.gii, and excluded the medial wall.
% The HCP minimal preprocessed fMRI data were post-processed using xcp-d.
% Post-processed steps include nuisance regression, filtering and smooth.
% Post-processed data *_space-fsLR_den-91k_desc-residual_smooth_bold.dtseries.nii for each subject was used.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/cifti-matlab-master'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/gifti-master'));

sub_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/data/xcpd_0.1.0/hcp_d/xcp_d/';
working_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/hcpd';

gii_dir = [working_dir filesep 'func_gii'];
if ~exist(gii_dir)
   mkdir(gii_dir); 
end

sess_list = {'REST1','AP';'REST1','PA';'REST2','AP';'REST2','PA';'CARIT','AP';'CARIT','PA';...
             'GUESSING','AP';'GUESSING','PA';'EMOTION','PA'};  

load('hcpd_sublist.mat')
%% using wb_command -cifti-separate to extract the left and right brain surface data
for sub_i = 1:length(hcpd_sublist)
    ID_Str = hcpd_sublist{sub_i}
    
    for sess_i = 1:length(sess_list)
        sess_now = sess_list{sess_i,1};
        phase_now = sess_list{sess_i,2};
        run_data = [sub_dir ID_Str '/func/' ID_Str '_task-' sess_now '_acq-' phase_now ...
                     '_space-fsLR_den-91k_desc-residual_smooth_bold.dtseries.nii'];
        
        out_sub = [gii_dir filesep ID_Str];      
        if ~exist(out_sub,'dir')
            mkdir(out_sub); 
        end
        
        out_run_L = [out_sub filesep ID_Str '_task-' sess_now '_' phase_now '.L.func.gii'];
        out_run_R = [out_sub filesep ID_Str '_task-' sess_now '_' phase_now '.R.func.gii'];

        cmd = [wb_command ' -cifti-separate ' run_data ' COLUMN -metric CORTEX_LEFT ' out_run_L...
               ' -metric CORTEX_RIGHT ' out_run_R];        
        unix(cmd);
    end
end
