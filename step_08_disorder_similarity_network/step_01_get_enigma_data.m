% ---------------------------------------------------------------------------------------------------------------
% This script was used to get the enigma results used in Figure 7.
% <Implications of connectional hierarchy on brain disorders>
% Ten cortical thickness abnormality maps were obtained using enigma-toolbox (https://enigma-toolbox.readthedocs.io/).
% The other three maps were obtained from previous studies.
% More detials, see 'Connectional_Hierarchy/data/enigma_results/ReadMe.txt'
% ---------------------------------------------------------------------------------------------------------------

clear
clc

% addpath(genpath('/path/to/ENIGMA/matlab/'))
root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
enigma_dir = [root_dir 'data/enigma_results/'];
parcellation_dir = [root_dir 'data/parcellation_files//'];
%% Initialize the results
% get the label of Desikan-Killiany atlas
[~, dk68_labels, ~, ~] = load_fc(); % this is a function of enigma-toolbox
dk68_labels = dk68_labels';

% cortical thickness
enigma_ct_dk68 = cell(69,14);
enigma_ct_dk68(1,1) = {'cortical thickness (cohen d)'};
enigma_ct_dk68(1,2:end) = [{'22q'}, {'adhd'}, {'asd'}, {'bp'}, {'gge'}, {'ltle'},{'rtle'},...
                      {'mdd'}, {'ocd'}, {'sz'}, {'obes'}, {'szty'}, {'pd'}];
enigma_ct_dk68(2:end,1) = dk68_labels;

% surface area
enigma_sa_dk68 = cell(69,10);
enigma_sa_dk68(1,1) = {'cortical thickness (cohen d)'};
enigma_sa_dk68(1,2:end) = [{'22q'}, {'adhd'}, {'bp'}, {'mdd'}, {'ocd'}, {'sz'}, {'obes'}, {'szty'}, {'pd'}];
enigma_sa_dk68(2:end,1) = dk68_labels;

%%
% 22q11.2 deletion syndrome (22q)
sum_stats = load_summary_stats('22q');
enigma_ct_dk68(2:end,2) = num2cell(sum_stats.CortThick_case_vs_controls.d_icv);
enigma_sa_dk68(2:end,2) = num2cell(sum_stats.CortSurf_case_vs_controls.d_icv);

% Attention deficit hyperactivity disorder (adhd)
sum_stats = load_summary_stats('adhd');
enigma_ct_dk68(2:end,3) = num2cell(sum_stats.CortThick_case_vs_controls_adult.d_icv);
enigma_sa_dk68(2:end,3) = num2cell(sum_stats.CortSurf_case_vs_controls_adult.d_icv);

% Autism spectrum disorder (asd)
sum_stats = load_summary_stats('asd');
enigma_ct_dk68(2:end,4) = num2cell(sum_stats.CortThick_case_vs_controls_meta_analysis.d_icv);

% Bipolar disorder (bp)
sum_stats = load_summary_stats('bipolar');
enigma_ct_dk68(2:end,5) = num2cell(sum_stats.CortThick_case_vs_controls_adult.d_icv);
enigma_sa_dk68(2:end,4) = num2cell(sum_stats.CortSurf_case_vs_controls_adult.d_icv);

% Epilepsy
sum_stats = load_summary_stats('epilepsy');
enigma_ct_dk68(2:end,6) = num2cell(sum_stats.CortThick_case_vs_controls_gge.d_icv); % idiopathic generalised epilepsy (gge)
enigma_ct_dk68(2:end,7) = num2cell(sum_stats.CortThick_case_vs_controls_ltle.d_icv); % left temporal lobe epilepsy (ltle)
enigma_ct_dk68(2:end,8) = num2cell(sum_stats.CortThick_case_vs_controls_rtle.d_icv); % right temporal lobe epilepsy (rtle)

% Major depressive disorder
sum_stats = load_summary_stats('depression');
enigma_ct_dk68(2:end,9) = num2cell(sum_stats.CortThick_case_vs_controls_adult.d_icv);
enigma_sa_dk68(2:end,5) = num2cell(sum_stats.CortSurf_case_vs_controls_adult.d_icv);

% Obsessive-compulsive disorder (ocd)
sum_stats = load_summary_stats('ocd');
enigma_ct_dk68(2:end,10) = num2cell(sum_stats.CortThick_case_vs_controls_adult.d_icv);
enigma_sa_dk68(2:end,6) = num2cell(sum_stats.CortSurf_case_vs_controls_adult.d_icv);

% Schizophrenia (sz)
sum_stats = load_summary_stats('schizophrenia');
enigma_ct_dk68(2:end,11) = num2cell(sum_stats.CortThick_case_vs_controls.d_icv);
enigma_sa_dk68(2:end,7) = num2cell(sum_stats.CortSurf_case_vs_controls.d_icv);

% Obesity (obes)
obesity_ct_sa = xlsread([enigma_dir 'obesity_ct_sa.xlsx']);
enigma_ct_dk68(2:end,12) = num2cell(obesity_ct_sa(:,1));
enigma_sa_dk68(2:end,8) = num2cell(obesity_ct_sa(:,2));

% Schizopypy (szty)
schizotypy_ct_sa = xlsread([enigma_dir 'schizotypy_ct_sa.xlsx']);
enigma_ct_dk68(2:end,13) = num2cell(schizotypy_ct_sa(:,1));
enigma_sa_dk68(2:end,9) = num2cell(schizotypy_ct_sa(:,2));

% Parkinson's disease (pd)
pd_ct_sa = xlsread([enigma_dir 'pd_ct_sa.xlsx']);
enigma_ct_dk68(2:end,14) = num2cell(pd_ct_sa(:,1));
enigma_sa_dk68(2:end,10) = num2cell(pd_ct_sa(:,2));

save([enigma_dir 'enigma_ct_dk68.mat'],'enigma_ct_dk68')
save([enigma_dir 'enigma_sa_dk68.mat'],'enigma_sa_dk68')

%% convert the results from DK-68 to Cammoun033
load([parcellation_dir 'dk2cammoun.mat'])
enigma_ct_cammoun033 = enigma_ct_dk68([1;dk2cammoun+1],:);
enigma_sa_cammoun033 = enigma_sa_dk68([1;dk2cammoun+1],:);

save([enigma_dir 'enigma_ct_cammoun033.mat'],'enigma_ct_cammoun033')
save([enigma_dir 'enigma_sa_cammoun033.mat'],'enigma_sa_cammoun033')
