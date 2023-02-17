# This script is used to estimate the inter- and intra-individual variability

library(ReX)
library(R.matlab)

rm(list = ls())

working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc/'
out_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_01_individual_fc_variability/hcpd/'

subID <-  as.matrix(unlist(readMat(paste0(working_dir,'subID_hcpd.mat'))))
session <- as.matrix(unlist(readMat(paste0(working_dir,'session_hcpd.mat'))))

###########################################################################
i = 1
data <- readMat(paste0(working_dir,'hcpd/hcpd_fc', as.character(i), '.mat'))
data <- data$fc
df_lme_all <- data.frame(lme_ICC_2wayM(data, subID, session))

for (i in 2:100) {
  print(i)
  data <- readMat(paste0(working_dir,'hcpd/hcpd_fc', as.character(i), '.mat'))
  data <- data$fc
  df_lme <- data.frame(lme_ICC_2wayM(data, subID, session))
  df_lme_all <- rbind(df_lme_all,df_lme)
}

writeMat(paste0(out_dir,'lme_hcpd_schaefer400.mat'),lme_hcpd_schaefer400 = df_lme_all)
