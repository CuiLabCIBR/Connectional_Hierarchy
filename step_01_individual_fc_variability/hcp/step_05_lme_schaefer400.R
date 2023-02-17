# This script is used to estimate the inter- and intra-individual variability

library(ReX)
library(R.matlab)

rm(list = ls())

working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc/'
out_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_01_individual_fc_variability/hcp/'

subID <-  as.matrix(unlist(readMat(paste0(working_dir,'subID_hcp.mat'))))
session <- as.matrix(unlist(readMat(paste0(working_dir,'session_hcp.mat'))))

###########################################################################
i = 1
data <- readMat(paste0(working_dir,'hcp/hcp_fc', as.character(i), '.mat'))
data <- data$fc
df_lme_all <- data.frame(lme_ICC_2wayM(data, subID, session))

for (i in 2:100) {
  print(i)
  data <- readMat(paste0(working_dir,'hcp/hcp_fc', as.character(i), '.mat'))
  data <- data$fc
  df_lme <- data.frame(lme_ICC_2wayM(data, subID, session))
  df_lme_all <- rbind(df_lme_all,df_lme)
}

writeMat(paste0(out_dir,'lme_hcp_schaefer400.mat'),lme_hcp_schaefer400 = df_lme_all)
