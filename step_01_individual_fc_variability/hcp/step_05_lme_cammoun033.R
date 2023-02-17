# This script is used to estimate the inter- and intra-individual variability

library(ReX)
library(R.matlab)

rm(list = ls())

working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc/'
out_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_01_individual_fc_variability/hcp/'

subID <-  as.matrix(unlist(readMat(paste0(working_dir,'subID_hcp.mat'))))
session <- as.matrix(unlist(readMat(paste0(working_dir,'session_hcp.mat'))))

###########################################################################

data <- readMat(paste0(working_dir,'hcp_fc_cammoun033.mat'))
data <- data$hcp.fc
df_lme_cammoun033 <- data.frame(lme_ICC_2wayM(data, subID, session))
writeMat(paste0(out_dir,'lme_hcp_cammoun033.mat'),lme_hcp_cammoun033 = df_lme_cammoun033)