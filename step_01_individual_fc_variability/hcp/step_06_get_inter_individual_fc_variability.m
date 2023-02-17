% ---------------------------------------------------------------------------------------------------------------
% This script is used to get the FC variability matrix.
% The between-subject variability was normalized by 
% dividing the within-subject variance, which was defined
% as the FC variability in this study.
% ---------------------------------------------------------------------------------------------------------------

clear
clc

root_dir = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/';
addpath(genpath(root_dir))

working_dir = [root_dir 'step_01_individual_fc_variability/hcp/'];
var_dir = [root_dir 'data/fc_variability/'];

%% schaefer400
load([working_dir, 'lme_hcp_schaefer400.mat'])

% between-subject variance
b = lme_hcp_schaefer400.sigma2_b;
% within-subject variance
w = lme_hcp_schaefer400.sigma2_w;
b_w = b./w;
b_w = squareform(b_w);

fc_variability_hcp.schaefer400 = b_w;

%% cammoun033
load([working_dir, 'lme_hcp_cammoun033.mat'])

% between-subject variance
b = lme_hcp_cammoun033.sigma2_b;
% within-subject variance
w = lme_hcp_cammoun033.sigma2_w;
b_w = b./w;
b_w = squareform(b_w);

fc_variability_hcp.cammoun033 = b_w;

%%
save([var_dir 'fc_variability_hcp.mat'],'fc_variability_hcp')
