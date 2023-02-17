# This script is used to estimate the inter- and intra-individual variability

library(ReX)
library(R.matlab)

rm(list = ls())

working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc/'
out_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_01_individual_fc_variability/hcpd/'

subID <-  as.matrix(unlist(readMat(paste0(working_dir,'subID_hcpd.mat'))))
session <- as.matrix(unlist(readMat(paste0(working_dir,'session_hcpd.mat'))))

###########################################################################

data <- readMat(paste0(working_dir,'hcpd_fc_cammoun033.mat'))
data <- data$hcpd.fc
df_lme_cammoun033 <- data.frame(lme_ICC_2wayM(data, subID, session))
writeMat(paste0(out_dir,'lme_hcpd_cammoun033.mat'),lme_hcpd_cammoun033 = df_lme_cammoun033)