% ---------------------------------------------------------------------------------------------------------------
% This script is used to extract the mean bold signal data using cammoun033 atlas.
% Four rest runs and five task runs were concatenated and separated into 
% eight runs to estimate inter- and intra-subject variability.
% ---------------------------------------------------------------------------------------------------------------

addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/functions/'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/cifti-matlab-master'));
addpath(genpath('/GPFS/cuizaixu_lab_permanent/yanghang/code/gifti-master'));

working_dir = '/GPFS/cuizaixu_lab_permanent/yanghang/projects/p01_connectional_hierarchy/hcpd';
gii_dir = [working_dir filesep 'func_gii'];

out_dir_8run = [working_dir '/bold_signal/cammoun033_8run'];
mkdir(out_dir_8run);

sess_list = {'REST1','AP';'REST1','PA';'REST2','AP';'REST2','PA';'CARIT','AP';'CARIT','PA';...
             'GUESSING','AP';'GUESSING','PA';'EMOTION','PA'};
         
load([working_dir '/parcellations/cammoun033.mat'])
label_vertex = cammoun033;
label = unique(label_vertex);

load('hcpd_sublist.mat')
for sub_i = 1:length(hcpd_sublist)
    
    mkdir(out_sub_4);
    out_sub_8 = [out_dir_8run filesep ID_Str];
    mkdir(out_sub_8);
    
    %% import and combine the left and right brain surface data
    all_data = [];  % in total 3200 timepoints

    for sess_i = 1:length(sess_list)
        sess_now = sess_list{sess_i,1};
        phase_now = sess_list{sess_i,2};

        gii_L = [gii_dir filesep ID_Str filesep ID_Str '_task-' sess_now '_' phase_now '.L.func.gii'];
        gii_R = [gii_dir filesep ID_Str filesep ID_Str '_task-' sess_now '_' phase_now '.R.func.gii'];
        data_L = gifti(gii_L);data_R = gifti(gii_R);
        data_run = [data_L.cdata;data_R.cdata];
        all_data = [all_data data_run];
    end

    %% separate the concatenated data to 8 runs to estimate intra-subject variability
    TimePoint_num = 400;

    for sess_i = 1:8
        sess_now = all_data(:,(sess_i-1)*TimePoint_num+1:sess_i*TimePoint_num);
        data_parcel_8run(:,:,sess_i) = compute_mat_base_label(sess_now,label,label_vertex);
    end

    save([out_sub_8 filesep 'data_parcel.mat'],'data_parcel_8run');    

end