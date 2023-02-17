% ---------------------------------------------------------------------------------------------------------------
% This script is used to extract the mean bold signal data using schaefer400 atlas.
% Four rest runs were concatenated and separated into twelve runs
% to estimate inter- and intra-subject variability, respectively.
% ---------------------------------------------------------------------------------------------------------------

addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/cifti-matlab-master'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/gifti-master'));

working_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/hcp';
gii_dir = [working_dir filesep 'func_gii'];

out_dir_12run = [working_dir '/bold_signal/schaefer400_12run'];
mkdir(out_dir_12run);

sess_list = {'REST1','LR';'REST1','RL';'REST2','LR';'REST2','RL'};
         
sub_parcel = cifti_read([working_dir '/parcellations/Schaefer2018_400Parcels_7Networks_order.dlabel.nii']);
label_vertex = sub_parcel.cdata;
label = unique(label_vertex);

load('hcp_sublist.mat')
for sub_i = 1:length(hcp_sublist)
    
    ID_Str = hcp_sublist{sub_i};
    out_sub_12 = [out_dir_12run filesep ID_Str];
    mkdir(out_sub_12);
    
    %% import and combine the left and right brain surface data
    all_data = [];  % in total 4800 timepoints

    for sess_i = 1:length(sess_list)
        sess_now = sess_list{sess_i,1};
        phase_now = sess_list{sess_i,2};

        gii_L = [gii_dir filesep ID_Str filesep ID_Str '_task-' sess_now '_' phase_now '.L.func.gii'];
        gii_R = [gii_dir filesep ID_Str filesep ID_Str '_task-' sess_now '_' phase_now '.R.func.gii'];
        data_L = gifti(gii_L);data_R = gifti(gii_R);
        data_run = [data_L.cdata;data_R.cdata];
        all_data = [all_data data_run];
    end

    %% separate the concatenated data to 12 runs
    TimePoint_num = 400;

    for sess_i = 1:12
        sess_now = all_data(:,(sess_i-1)*TimePoint_num+1:sess_i*TimePoint_num);
        data_parcel_12run(:,:,sess_i) = compute_mat_base_label(sess_now,label,label_vertex);
    end

    save([out_sub_12 filesep 'data_parcel.mat'],'data_parcel_12run');    

end